#!/usr/bin/env bash
# Save talosconfig and kubeconfig from terraform output after apply
# This runs as a terragrunt after_hook from the terraform cache directory

set -euo pipefail

SECRETS_DIR="${XDG_RUNTIME_DIR:-$HOME/.cache}/homelab-secrets"
REPO_ROOT="$(git rev-parse --show-toplevel)"

mkdir -p "$SECRETS_DIR" && chmod 700 "$SECRETS_DIR"
mkdir -p "$REPO_ROOT/talos"

echo "Saving credentials from terraform output..."

# Use tofu output directly (we're in the terraform cache dir)
TALOS_OUTPUT=$(tofu output -raw talosconfig 2>/dev/null || true)
if [ -n "$TALOS_OUTPUT" ]; then
  echo "$TALOS_OUTPUT" > "$SECRETS_DIR/talosconfig"
  echo "$TALOS_OUTPUT" > "$REPO_ROOT/talos/talosconfig"
  sops -e -i "$REPO_ROOT/talos/talosconfig"
  echo "✓ talosconfig saved"
fi

KUBE_OUTPUT=$(tofu output -raw kubeconfig 2>/dev/null || true)
if [ -n "$KUBE_OUTPUT" ]; then
  echo "$KUBE_OUTPUT" > "$SECRETS_DIR/kubeconfig"
  echo "$KUBE_OUTPUT" > "$REPO_ROOT/talos/kubeconfig"
  sops -e -i "$REPO_ROOT/talos/kubeconfig"
  echo "✓ kubeconfig saved"
fi
