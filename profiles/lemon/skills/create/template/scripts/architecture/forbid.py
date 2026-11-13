"""Declarative `[[forbid]]` rules: which file may not require which.

A rule in architecture.toml reads like a sentence:

    [[forbid]]
    name = "client-never-requires-server"
    from = ["src/client/**"]
    to = ["src/server/**"]
    reason = "..."

Globs: `*` matches within one folder, `**` matches across folders. `except_to` lists
targets that stay allowed, and `same_feature = "allow"` lets a feature's own files
require each other.
"""

import re


def glob_to_regex(pattern):
    out, i = [], 0
    while i < len(pattern):
        if pattern.startswith("**/", i):
            out.append("(?:.*/)?")
            i += 3
        elif pattern.startswith("**", i):
            out.append(".*")
            i += 2
        elif pattern[i] == "*":
            out.append("[^/]*")
            i += 1
        else:
            out.append(re.escape(pattern[i]))
            i += 1
    return re.compile("".join(out) + r"\Z")


def _matches(patterns, path):
    return any(glob_to_regex(p).match(path) for p in patterns)


def feature_of(path, realm_roots):
    """'family/feature' for a path inside <realm root>/<family>/<feature>/, else None."""
    for root in realm_roots:
        prefix = root.rstrip("/") + "/"
        if path.startswith(prefix):
            parts = path[len(prefix):].split("/")
            return "/".join(parts[:2]) if len(parts) >= 3 else None
    return None


def violations(rules, src, dst, realm_roots):
    """Yield (rule name, reason) for each forbid rule the edge src -> dst breaks."""
    for rule in rules:
        if not _matches(rule["from"], src) or not _matches(rule["to"], dst):
            continue
        if _matches(rule.get("except_to", []), dst):
            continue
        a, b = feature_of(src, realm_roots), feature_of(dst, realm_roots)
        if rule.get("same_feature") == "allow" and a and a == b:
            continue
        yield rule["name"], rule.get("reason", "")
