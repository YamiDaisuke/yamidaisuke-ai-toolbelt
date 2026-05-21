#!/bin/bash
# Install ym — bootstrap spec-driven development projects with AI agent roles
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/YamiDaisuke/yamidaisuke-ai-toolbelt/main/install.sh | bash
#
# To install to a custom directory:
#   curl -fsSL .../install.sh | YM_INSTALL_DIR=~/.local/bin bash

set -e

REPO_URL="https://github.com/YamiDaisuke/yamidaisuke-ai-toolbelt"
INSTALL_DIR="${YM_INSTALL_DIR:-/usr/local/bin}"
TEMP_DIR=$(mktemp -d)

trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Installing ym..."
git clone --depth=1 --quiet "$REPO_URL" "$TEMP_DIR/repo" || {
  echo "Error: failed to clone from $REPO_URL" >&2
  exit 1
}

mkdir -p "$INSTALL_DIR"
cp "$TEMP_DIR/repo/bin/ym" "$INSTALL_DIR/ym"
chmod +x "$INSTALL_DIR/ym"

echo "Installed: $INSTALL_DIR/ym"
echo ""
"$INSTALL_DIR/ym" --version
echo ""
echo "Usage:"
echo "  mkdir my-project && cd my-project && ym bootstrap my-project"
