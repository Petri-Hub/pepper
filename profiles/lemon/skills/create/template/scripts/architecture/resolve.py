"""Resolve `require(<instance path>)` against the instance tree Rojo builds.

Only static paths are understood: `script`, `game:GetService("X")`, a local alias for
either, then `.Name`, `.Parent`, `["Name"]`, `:WaitForChild("Name")` or
`:FindFirstChild("Name")`. Anything else is reported instead of guessed, which is
also the rule for people: a require should be readable as a path.
"""

import re

_ALIAS = re.compile(r"(?m)^[ \t]*local[ \t]+(\w+)[ \t]*(?::[^=\n]+)?=[ \t]*([^\n]+?)[ \t]*$")
_SERVICE = re.compile(r'game\s*:\s*GetService\(\s*"(\w+)"\s*\)')
_STEPS = (
    re.compile(r"\.Parent\b"),
    re.compile(r"\.(\w+)"),
    re.compile(r'\[\s*"([^"]+)"\s*\]'),
    re.compile(r':(?:WaitForChild|FindFirstChild)\(\s*"([^"]+)"[^)]*\)'),
)


class RequireError(Exception):
    def __init__(self, rule, message):
        super().__init__(message)
        self.rule, self.message = rule, message


def _step(node, name):
    if node.opaque:
        child = node.child(name)
        child.opaque = True
        return child
    if name not in node.children:
        raise RequireError(
            "require-unresolved",
            f"'{name}' is not a child of {node.path or 'game'}. "
            f"Its children are: {', '.join(sorted(node.children)) or 'none'}.",
        )
    return node.children[name]


def _base(expr, own, game, aliases):
    if re.match(r"script\b", expr):
        return own, expr[len("script"):]
    service = _SERVICE.match(expr)
    if service:
        return _step_service(game, service.group(1)), expr[service.end():]
    word = re.match(r"(\w+)", expr)
    if word and word.group(1) in aliases:
        return aliases[word.group(1)], expr[word.end():]
    raise RequireError(
        "require-dynamic",
        "require must start from `script`, `game:GetService(...)` or a local alias of one of them.",
    )


def _step_service(game, name):
    if name not in game.children:
        game.child(name).opaque = True  # a service the project does not map
    return game.children[name]


def resolve_expr(expr, own, game, aliases):
    """Return the node `expr` points to, or raise RequireError."""
    node, rest = _base(expr.strip(), own, game, aliases)
    while rest.strip():
        rest = rest.lstrip()
        for index, pattern in enumerate(_STEPS):
            match = pattern.match(rest)
            if match:
                if index == 0:
                    if node.parent is None:
                        raise RequireError("require-unresolved", "`.Parent` goes above the game root.")
                    node = node.parent
                else:
                    node = _step(node, match.group(1))
                rest = rest[match.end():]
                break
        else:
            raise RequireError(
                "require-dynamic",
                f"cannot read `{rest.strip()}` statically; write the require as a plain instance path.",
            )
    return node


def collect_aliases(code, own, game):
    """Map local names to the instances they were assigned, in file order."""
    aliases = {}
    for match in _ALIAS.finditer(code):
        name, rhs = match.groups()
        if "require" in rhs:
            continue
        try:
            aliases[name] = resolve_expr(rhs, own, game, aliases)
        except RequireError:
            pass  # not an instance path (a number, a table, ...): not an alias
    return aliases
