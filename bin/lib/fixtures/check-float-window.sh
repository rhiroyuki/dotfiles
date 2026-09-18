#!/usr/bin/env bash
# Check that client classes become one correctly quoted Lua string literal.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$here/../../.." && pwd)"

FLOAT_WINDOW_SOURCE_ONLY=1 source "$repo_root/config/hypr/bin/float-window"

[[ "$(lua_literal 'foo.bar')" == '"foo.bar"' ]]
[[ "$(lua_literal 'Firefox (Wayland)')" == '"Firefox (Wayland)"' ]]
[[ "$(lua_literal 'quote\\slash')" == '"quote\\\\slash"' ]]

echo "float-window Lua literal check: all OK"
