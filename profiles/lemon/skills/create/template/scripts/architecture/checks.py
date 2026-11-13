"""The architecture checks. Each violation is `path:line: [rule] message`."""

import re
from collections import defaultdict
from typing import NamedTuple

import forbid
import luau
import resolve
import rojo


class Violation(NamedTuple):
    path: str
    line: int
    rule: str
    message: str

    def __str__(self):
        return f"{self.path}:{self.line}: [{self.rule}] {self.message}"


def _luau_files(root, sources):
    for source in sources:
        for path in sorted((root / source).rglob("*")):
            if path.suffix in (".luau", ".lua") and path.is_file():
                yield path


def _realm_of(rel, realms):
    for realm, root in realms.items():
        if rel.startswith(root + "/"):
            return realm, rel[len(root) + 1:].split("/")
    return None, None


def _layout(rel, realms):
    """A source file sits at <realm>/<family>/<feature>/..., except the two bootstraps."""
    realm, parts = _realm_of(rel, realms)
    if realm is None or len(parts) >= 3:
        return None
    if len(parts) == 1 and parts[0] == rojo.BOOTSTRAP.get(realm):
        return None
    return (
        f"files under {realms[realm]}/ live at <family>/<feature>/. "
        "Move this file into a feature folder."
    )


def _file_rules(rel, text, config, config_shared):
    limit = config["limits"]["max_lines"]
    lines = text.count("\n") + 1
    if lines > limit:
        yield 1, "max-lines", f"{lines} lines; the limit is {limit}. Split it by responsibility."
    if rel.startswith(config_shared + "/"):
        plain = luau.scrub(text, keep_strings=False)
        for pattern in config["shared_pure"]["forbidden"]:
            for match in re.finditer(pattern, plain):
                yield luau.line_of(plain, match.start()), "shared-pure", (
                    f"shared code must stay pure; `{match.group(0).strip()}` touches the engine. "
                    "Pass what it needs in as arguments."
                )


def _cycles(graph):
    """Strongly connected groups of more than one feature (Tarjan)."""
    index, low, stack, on, groups, counter = {}, {}, [], set(), [], [0]

    def visit(node):
        index[node] = low[node] = counter[0]
        counter[0] += 1
        stack.append(node)
        on.add(node)
        for other in graph[node]:
            if other not in index:
                visit(other)
                low[node] = min(low[node], low[other])
            elif other in on:
                low[node] = min(low[node], index[other])
        if low[node] == index[node]:
            group = []
            while True:
                member = stack.pop()
                on.discard(member)
                group.append(member)
                if member == node:
                    break
            if len(group) > 1:
                groups.append(sorted(group))

    for node in sorted(graph):
        if node not in index:
            visit(node)
    return groups


def _realm_entries(root, realms):
    """Every server and client feature folder needs an init.luau: its public surface."""
    for realm in ("server", "client"):
        base = root / realms[realm]
        for family in sorted(p for p in base.glob("*") if p.is_dir()):
            for feature in sorted(p for p in family.iterdir() if p.is_dir()):
                if not (feature / "init.luau").exists():
                    rel = feature.relative_to(root).as_posix()
                    yield Violation(
                        rel, 1, "realm-entry",
                        f"{realm} feature has no init.luau, so it has no public surface and never starts.",
                    )


def run(root, config):
    realms = config["realms"]
    roots = list(realms.values())
    game, mapped = rojo.build_tree(root / config["project"]["root_project"], root)
    found, graph, where = [], defaultdict(set), {}

    for path in _luau_files(root, config["project"]["sources"]):
        rel = path.relative_to(root).as_posix()
        text = path.read_text()
        for line, rule, message in _file_rules(rel, text, config, realms["shared"]):
            found.append(Violation(rel, line, rule, message))
        if message := _layout(rel, realms):
            found.append(Violation(rel, 1, "layout", message))
        node = mapped.get(path)
        if node is None:
            found.append(Violation(rel, 1, "unmapped-file", "Rojo never loads this file. Keep source files under src/server, src/client or src/shared."))
            continue
        code = luau.scrub(text, keep_strings=True)
        aliases = resolve.collect_aliases(code, node, game)
        for line, expr in luau.find_requires(code, luau.scrub(text, keep_strings=False)):
            try:
                target = resolve.resolve_expr(expr, node, game, aliases)
            except resolve.RequireError as error:
                found.append(Violation(rel, line, error.rule, error.message))
                continue
            if target.opaque:
                continue
            if target.file is None:
                found.append(Violation(rel, line, "require-not-a-module", f"{target.path} is a folder, not a ModuleScript."))
                continue
            dst = target.file.relative_to(root).as_posix()
            for name, reason in forbid.violations(config["forbid"], rel, dst, roots):
                found.append(Violation(rel, line, name, f"requires {dst}. {reason}".strip()))
            a, b = forbid.feature_of(rel, roots), forbid.feature_of(dst, roots)
            if a and b and a != b:
                graph[a].add(b)
                graph.setdefault(b, set())
                where.setdefault((a, b), (rel, line))

    found.extend(_realm_entries(root, realms))
    for group in _cycles(graph):
        rel, line = where[(group[0], next(b for b in group if (group[0], b) in where))]
        found.append(Violation(rel, line, "no-cycles", f"features depend on each other in a loop: {' <-> '.join(group)}. Extract what they share into a third feature."))
    return sorted(found)
