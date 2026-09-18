#!/usr/bin/env bash
# Verify that an installed fzf with an unsupported --zsh mode falls back to
# the packaged zsh integration, without sourcing both integrations.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$here/../../.." && pwd)"
root="$(mktemp -d)"
trap 'rm -rf "$root"' EXIT

mkdir -p "$root/home" "$root/bin" "$root/fzf"
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'if [[ "${1:-}" == "--zsh" ]]; then' \
  '  printf "%s\\n" "typeset -g FZF_FIXTURE_GENERATED=1"' \
  '  exit 42' \
  'fi' \
  'exit 1' > "$root/bin/fzf"
chmod +x "$root/bin/fzf"
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'exit 0' > "$root/bin/stty"
chmod +x "$root/bin/stty"

printf '%s\n' \
  'typeset -g FZF_FIXTURE_COMPLETION=1' > "$root/fzf/completion.zsh"
printf '%s\n' \
  'fzf-file-widget() { :; }' \
  'bindkey "^T" fzf-file-widget' \
  'typeset -g FZF_FIXTURE_KEY_BINDINGS=1' > "$root/fzf/key-bindings.zsh"

HOME="$root/home" \
PATH="$root/bin:/usr/bin:/bin" \
TMUX=fixture \
FZF_PACKAGED_DIR="$root/fzf" \
zsh -fic '
  source "$1"
  [[ "${FZF_FIXTURE_COMPLETION:-}" == 1 ]]
  [[ "${FZF_FIXTURE_KEY_BINDINGS:-}" == 1 ]]
  [[ -z "${FZF_FIXTURE_GENERATED:-}" ]]
  (( $+functions[fzf-file-widget] ))
  [[ "$(bindkey "^T")" == *fzf-file-widget* ]]
' fixture "$repo_root/zshrc_dotfile"

echo "fzf integration check: all OK"
