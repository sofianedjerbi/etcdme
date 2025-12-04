#!/usr/bin/env bash
# Decrypt talos credentials for local development
# New devs run this after getting the age key

set -euo pipefail

SECRETS_DIR="${XDG_RUNTIME_DIR:-$HOME/.cache}/homelab-secrets"
REPO_ROOT="$(git rev-parse --show-toplevel)"

# Check for age key
if [ -z "${SOPS_AGE_KEY_FILE:-}" ] && [ ! -f "$HOME/.config/sops/age/keys.txt" ]; then
  echo "Error: No age key found"
  echo ""
  echo "Get the age private key from a team member and either:"
  echo "  1. Set SOPS_AGE_KEY_FILE=/path/to/key.txt"
  echo "  2. Place it in ~/.config/sops/age/keys.txt"
  exit 1
fi

# Check for encrypted files
if [ ! -f "$REPO_ROOT/talos/talosconfig" ] || [ ! -f "$REPO_ROOT/talos/kubeconfig" ]; then
  echo "Error: Encrypted credentials not found in talos/"
  echo "The cluster may not be deployed yet, or you need to pull latest."
  exit 1
fi

mkdir -p "$SECRETS_DIR" && chmod 700 "$SECRETS_DIR"

echo "Decrypting credentials..."

sops -d "$REPO_ROOT/talos/talosconfig" > "$SECRETS_DIR/talosconfig"
sops -d "$REPO_ROOT/talos/kubeconfig" > "$SECRETS_DIR/kubeconfig"

echo "✓ Credentials decrypted to $SECRETS_DIR"
echo ""
echo "Add to your shell profile:"
echo "  export KUBECONFIG=\"$SECRETS_DIR/kubeconfig\""
echo "  export TALOSCONFIG=\"$SECRETS_DIR/talosconfig\""
