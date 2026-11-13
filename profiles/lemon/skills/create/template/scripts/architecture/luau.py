"""Small Luau helpers: blank out comments and strings, and find require calls.

Both helpers keep every character offset, so a match in the scrubbed text maps
to the same line in the original file.
"""

import re

_LONG_OPEN = re.compile(r"\[(=*)\[")
_REQUIRE = re.compile(r"(?<![\w.:])require\s*\(")


def scrub(text: str, keep_strings: bool) -> str:
    """Return `text` with comments (and, unless kept, strings) turned into spaces."""
    out = []
    i, n = 0, len(text)

    def blank(chunk: str) -> str:
        return "".join(c if c == "\n" else " " for c in chunk)

    while i < n:
        two = text[i : i + 2]
        if two == "--":
            long = _LONG_OPEN.match(text, i + 2)
            if long:
                close = "]" + long.group(1) + "]"
                end = text.find(close, long.end())
                end = n if end == -1 else end + len(close)
            else:
                end = text.find("\n", i)
                end = n if end == -1 else end
            out.append(blank(text[i:end]))
            i = end
        elif text[i] in "\"'`":
            quote, j = text[i], i + 1
            while j < n and text[j] != quote and (quote == "`" or text[j] != "\n"):
                j += 2 if text[j] == "\\" else 1
            chunk = text[i : j + 1]
            out.append(chunk if keep_strings else blank(chunk))
            i = j + 1
        elif text[i] == "[" and _LONG_OPEN.match(text, i):
            long = _LONG_OPEN.match(text, i)
            close = "]" + long.group(1) + "]"
            end = text.find(close, long.end())
            end = n if end == -1 else end + len(close)
            chunk = text[i:end]
            out.append(chunk if keep_strings else blank(chunk))
            i = end
        else:
            out.append(text[i])
            i += 1
    return "".join(out)


def line_of(text: str, offset: int) -> int:
    return text.count("\n", 0, offset) + 1


def find_requires(code: str, plain: str):
    """Yield (line, argument_text) for each real `require(...)` call.

    `plain` is the same text with comments and strings blanked, so a require inside a
    comment or a string is never found and parentheses inside strings never confuse the
    matching. `code` keeps the strings, so the argument text is read from there.
    """
    for match in _REQUIRE.finditer(plain):
        depth, i = 1, match.end()
        while i < len(plain) and depth:
            if plain[i] == "(":
                depth += 1
            elif plain[i] == ")":
                depth -= 1
            i += 1
        yield line_of(plain, match.start()), code[match.end() : i - 1].strip()
