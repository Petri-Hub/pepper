"""Rebuild the instance tree Rojo would create from a project file.

The checker resolves every `require` against this tree, so a path that builds fine
but fails in Studio (`script.Parent` in an `init.luau`) is found before the game runs.
"""

import json
from pathlib import Path

REALMS = ("shared", "server", "client")
BOOTSTRAP = {"server": "init.server.luau", "client": "init.client.luau"}
INIT_NAMES = ("init.luau", "init.lua", "init.server.luau", "init.client.luau")
SCRIPT_SUFFIXES = (".server.luau", ".client.luau", ".luau", ".lua")


class Node:
    def __init__(self, name, parent=None):
        self.name, self.parent = name, parent
        self.children, self.file, self.opaque = {}, None, False

    def child(self, name):
        if name not in self.children:
            self.children[name] = Node(name, self)
        return self.children[name]

    @property
    def path(self):
        parts, node = [], self
        while node.parent is not None:
            parts.append(node.name)
            node = node.parent
        return ".".join(reversed(parts))


def _script_name(filename):
    for suffix in SCRIPT_SUFFIXES:
        if filename.endswith(suffix):
            return filename[: -len(suffix)]
    return None


def _mount(node, path, mapped):
    """Attach what Rojo would build from `path` (a file or folder) to `node`."""
    if not path.exists():
        node.opaque = True  # e.g. Packages before `wally install`
        return
    if path.is_file():
        node.file = path
        mapped[path] = node
        return
    init = next((path / n for n in INIT_NAMES if (path / n).exists()), None)
    if init:
        node.file = init
        mapped[init] = node
    for entry in sorted(path.iterdir()):
        if entry == init or entry.name.startswith("."):
            continue
        if entry.is_dir():
            _mount(node.child(entry.name), entry, mapped)
        elif entry.suffix in (".rbxm", ".rbxmx"):
            node.child(entry.stem).opaque = True
        elif _script_name(entry.name):
            _mount(node.child(_script_name(entry.name)), entry, mapped)


def build_tree(project_file, root):
    """Return (tree root node, {source file: node}) for one Rojo project file."""
    spec = json.loads(Path(project_file).read_text())["tree"]
    game, mapped = Node("game"), {}

    def apply(node, body):
        if "$path" in body:
            _mount(node, root / body["$path"], mapped)
        for key, value in body.items():
            if not key.startswith("$"):
                apply(node.child(key), value)

    apply(game, spec)
    return game, mapped
