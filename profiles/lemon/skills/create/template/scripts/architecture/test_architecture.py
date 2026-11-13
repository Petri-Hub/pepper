"""Self-test: each rule must fire on the mistake it exists for, and stay quiet otherwise.

Run: python3 scripts/architecture/test_architecture.py
Each test copies the project into a temp folder, breaks one thing and runs the checks.
Paths passed to `write` are relative to src/, for example "server/player/stamina/init.luau".
"""

import shutil
import sys
import tempfile
import tomllib
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import checks  # noqa: E402

TEMPLATE = Path(__file__).resolve().parents[2]
SERVICES = (
    'local RS = game:GetService("ReplicatedStorage")\n'
    'local SSS = game:GetService("ServerScriptService")\n'
    'local SPS = game:GetService("StarterPlayer").StarterPlayerScripts\n'
)


class ArchitectureTest(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.root = self.tmp / "game"
        shutil.copytree(TEMPLATE, self.root, ignore=shutil.ignore_patterns("__pycache__", "Packages", "dist"))
        self.config = tomllib.loads((self.root / "architecture.toml").read_text())

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def write(self, rel, text):
        path = self.root / "src" / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)

    def rules(self):
        return [v.rule for v in checks.run(self.root, self.config)]

    def test_template_is_clean(self):
        self.assertEqual(self.rules(), [])

    def test_a_new_feature_needs_no_project_file_change(self):
        self.write("shared/a/x/Config.luau", "return {}\n")
        self.write("server/a/x/init.luau", SERVICES + "local C = require(RS.Shared.a.x.Config)\nreturn C\n")
        self.write("client/a/x/init.luau", SERVICES + "local C = require(RS.Shared.a.x.Config)\nreturn C\n")
        self.assertEqual(self.rules(), [])

    def test_client_requiring_server_is_rejected(self):
        self.write("server/a/x/init.luau", "return {}\n")
        self.write("client/a/x/init.luau", SERVICES + "local S = require(SSS.Server.a.x)\n")
        self.assertIn("client-never-requires-server", self.rules())

    def test_server_requiring_client_is_rejected(self):
        self.write("client/a/x/init.luau", "return {}\n")
        self.write("server/a/x/init.luau", SERVICES + "local C = require(SPS.Client.a.x)\n")
        self.assertIn("server-never-requires-client", self.rules())

    def test_shared_requiring_a_realm_is_rejected(self):
        self.write("server/a/x/init.luau", "return {}\n")
        self.write("shared/a/x/Config.luau", SERVICES + "local S = require(SSS.Server.a.x)\n")
        self.assertIn("shared-never-requires-realms", self.rules())

    def test_other_features_internals_are_private_but_surface_and_shared_are_open(self):
        self.write("server/a/x/init.luau", "return {}\n")
        self.write("server/a/x/Helper.luau", "return {}\n")
        self.write("shared/a/x/Config.luau", "return {}\n")
        self.write("server/b/y/init.luau", SERVICES + "local ok1 = require(SSS.Server.a.x)\nlocal ok2 = require(RS.Shared.a.x.Config)\n")
        self.assertEqual(self.rules(), [])
        self.write("server/b/y/init.luau", SERVICES + "local bad = require(SSS.Server.a.x.Helper)\n")
        self.assertIn("feature-internals-are-private", self.rules())

    def test_a_feature_may_require_its_own_internals(self):
        self.write("server/a/x/init.luau", "local Helper = require(script.Helper)\nreturn Helper\n")
        self.write("server/a/x/Helper.luau", "return {}\n")
        self.assertEqual(self.rules(), [])

    def test_the_session_bug_is_caught(self):
        # require(script.character...) in a ModuleScript with no children: the Studio error.
        self.write("server/a/x/init.luau", "local S = require(script.character.Stamina)\n")
        self.assertIn("require-unresolved", self.rules())

    def test_siblings_of_a_plain_module_are_script_parent(self):
        self.write("server/a/x/init.luau", "return {}\n")
        self.write("server/a/x/Main.luau", "local S = require(script.Parent.Helper)\nreturn S\n")
        self.write("server/a/x/Helper.luau", "return {}\n")
        self.assertEqual(self.rules(), [])

    def test_children_of_an_init_module_are_script_not_script_parent(self):
        self.write("server/a/x/init.luau", "local S = require(script.Parent.Helper)\nreturn S\n")
        self.write("server/a/x/Helper.luau", "return {}\n")
        self.assertIn("require-unresolved", self.rules())

    def test_dynamic_require_is_rejected(self):
        self.write("server/a/x/init.luau", "local m = require(pick())\n")
        self.assertIn("require-dynamic", self.rules())

    def test_comments_and_strings_do_not_count(self):
        self.write("server/a/x/init.luau", '-- require(script.Missing)\nlocal s = "require(script.Missing)"\n--[[ require(script.Gone) ]]\nreturn s\n')
        self.assertEqual(self.rules(), [])

    def test_alias_and_waitforchild_paths_resolve(self):
        self.write("server/a/x/init.luau", SERVICES + 'local Server = SSS.Server\nlocal C = require(Server.core.characters)\nlocal D = require(SSS:WaitForChild("Server").core.characters)\n')
        self.assertEqual(self.rules(), [])

    def test_files_outside_the_realm_folders_are_reported(self):
        self.write("features/a/x/server/init.luau", "return {}\n")
        self.assertIn("unmapped-file", self.rules())

    def test_shared_must_stay_pure(self):
        self.write("shared/a/x/Config.luau", 'local P = game:GetService("Players")\nreturn {}\n')
        self.assertIn("shared-pure", self.rules())

    def test_module_size_limit(self):
        self.write("server/a/x/init.luau", "local x = 1\n" * 205)
        self.assertIn("max-lines", self.rules())

    def test_feature_cycles_are_rejected(self):
        self.write("server/a/x/init.luau", SERVICES + "local Y = require(SSS.Server.a.y)\n")
        self.write("server/a/y/init.luau", SERVICES + "local X = require(SSS.Server.a.x)\n")
        self.assertIn("no-cycles", self.rules())

    def test_files_directly_in_a_realm_or_family_folder_are_rejected(self):
        self.write("server/Loose.luau", "return {}\n")
        self.write("client/a/Loose.luau", "return {}\n")
        self.assertEqual(self.rules().count("layout"), 2)

    def test_the_two_bootstrap_scripts_are_allowed(self):
        self.assertTrue((self.root / "src/server/init.server.luau").exists())
        self.assertTrue((self.root / "src/client/init.client.luau").exists())
        self.assertNotIn("layout", self.rules())

    def test_server_and_client_features_need_an_entry(self):
        self.write("server/a/x/Helper.luau", "return {}\n")
        self.write("client/a/x/Helper.luau", "return {}\n")
        self.assertEqual(self.rules().count("realm-entry"), 2)


if __name__ == "__main__":
    unittest.main(verbosity=2)
