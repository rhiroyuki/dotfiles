#!/usr/bin/env python3
"""Parse JSONC files without adding a runtime dependency."""

from __future__ import annotations

import json
import sys


def strip_jsonc(text: str) -> str:
    out: list[str] = []
    i = 0
    in_string = False
    escaped = False
    while i < len(text):
        char = text[i]
        if in_string:
            out.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            i += 1
            continue

        if char == '"':
            in_string = True
            out.append(char)
            i += 1
        elif text.startswith("//", i):
            newline = text.find("\n", i)
            if newline == -1:
                break
            out.append("\n")
            i = newline + 1
        elif text.startswith("/*", i):
            end = text.find("*/", i + 2)
            if end == -1:
                raise ValueError("unterminated block comment")
            out.extend("\n" if c == "\n" else " " for c in text[i : end + 2])
            i = end + 2
        else:
            out.append(char)
            i += 1

    # JSONC permits trailing commas. Remove only commas outside strings.
    cleaned = "".join(out)
    result: list[str] = []
    in_string = False
    escaped = False
    i = 0
    while i < len(cleaned):
        char = cleaned[i]
        if in_string:
            result.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            i += 1
            continue
        if char == '"':
            in_string = True
            result.append(char)
            i += 1
        elif char == ',':
            rest = cleaned[i + 1 :].lstrip()
            if rest.startswith('}') or rest.startswith(']'):
                i += 1
            else:
                result.append(char)
                i += 1
        else:
            result.append(char)
            i += 1
    return "".join(result)


def main() -> int:
    failed = False
    for filename in sys.argv[1:]:
        try:
            with open(filename, encoding="utf-8") as stream:
                json.loads(strip_jsonc(stream.read()))
        except (OSError, ValueError, json.JSONDecodeError) as error:
            print(f"{filename}: invalid JSONC: {error}", file=sys.stderr)
            failed = True
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
