#!/usr/bin/env bash
# Exercise keyd replacement behavior without root or systemd.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$here/../../.." && pwd)"
root="$(mktemp -d)"
trap 'rm -rf "$root"' EXIT
mkdir -p "$root/bin" "$root/etc/keyd"

cat > "$root/bin/sudo" <<'EOF'
#!/usr/bin/env bash
exec "$@"
EOF
cat > "$root/bin/systemctl" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
chmod +x "$root/bin/sudo" "$root/bin/systemctl"

service_path="$root/etc/keyd/default.conf"
run_keyd() {
  PATH="$root/bin:$PATH" KEYD_SERVICE_PATH="$service_path" \
    bash "$repo_root/install/install_keyd_service.sh" >/dev/null
}

run_keyd
cmp -s "$repo_root/install/keyd_default_conf" "$service_path"
[[ -z "$(compgen -G "${service_path}_backup_*" || true)" ]]

# Same-content reinstall is a no-op for the file and creates no backup.
run_keyd
[[ -z "$(compgen -G "${service_path}_backup_*" || true)" ]]

printf '%s\n' custom > "$service_path"
run_keyd
cmp -s "$repo_root/install/keyd_default_conf" "$service_path"
backup="$(compgen -G "${service_path}_backup_*" | head -n1)"
[[ -n "$backup" ]]
[[ "$(cat "$backup")" == custom ]]

echo "keyd install check: all OK"
