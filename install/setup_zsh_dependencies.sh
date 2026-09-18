#!/usr/bin/env bash
# Install shell extensions used by zshrc_dotfile outside interactive startup.
set -euo pipefail

clone_if_missing() {
  local url="$1" target="$2"
  if [[ ! -d "$target" ]]; then
    mkdir -p "$(dirname "$target")"
    git clone --depth 1 "$url" "$target"
  fi
}

command -v git >/dev/null 2>&1 || { echo "setup_zsh_dependencies: git is required" >&2; exit 1; }
clone_if_missing https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
clone_if_missing https://github.com/felipec/git-completion.git "$HOME/.zsh/git-completion"
if [[ ! -f "$HOME/.local/share/git-completion/zsh/_git" ]]; then
  (cd "$HOME/.zsh/git-completion" && make install)
fi
clone_if_missing https://github.com/zsh-users/zsh-completions.git "$HOME/.zsh/zsh-completions"
clone_if_missing https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
if command -v asdf >/dev/null 2>&1; then
  asdf_data_dir="${ASDF_DATA_DIR:-$HOME/.asdf}"
  mkdir -p "$asdf_data_dir/completions"
  [[ -f "$asdf_data_dir/completions/_asdf" ]] || asdf completion zsh > "$asdf_data_dir/completions/_asdf"
fi
echo "Zsh dependencies installed. Install asdf separately if desired; startup uses it when available."
