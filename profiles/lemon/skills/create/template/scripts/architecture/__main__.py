"""Check the project's architecture.

check  report every architecture violation and exit 1 if there are any
"""

import argparse
import sys
import tomllib
from pathlib import Path

import checks


def main(argv):
    parser = argparse.ArgumentParser(prog="architecture", description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("command", choices=("check",))
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[2],
                        help="project root (default: the project this script lives in)")
    args = parser.parse_args(argv)
    root = args.root.resolve()
    config = tomllib.loads((root / "architecture.toml").read_text())
    found = checks.run(root, config)
    for violation in found:
        print(violation)
    print(f"architecture: {len(found)} violation(s)" if found else "architecture: ok")
    return 1 if found else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
