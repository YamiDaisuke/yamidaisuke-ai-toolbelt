#!/bin/bash
# Usage: curl -fsSL <raw-url> | bash -s -- <project-name>
# - Clones the bootstrap repo to a temp directory
# - Copies .bootstrap/ into the current directory
# - Creates docs/REQUIREMENTS.md, docs/ARCHITECTURE.md from templates
# - Creates docs/specs/ directory
# - Writes CLAUDE.md from template
# - Initializes git if not already a repo
# - Cleans up temp files on exit

set -e

if [ -z "$1" ]; then
  echo "Error: project name required"
  echo "Usage: curl -fsSL <raw-url> | bash -s -- <project-name>"
  exit 1
fi

PROJECT_NAME="$1"
REPO_URL="https://github.com/YamiDaisuke/yamidaisuke-ai-toolbelt"
TEMP_DIR=$(mktemp -d)

trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Downloading bootstrap..."
git clone --depth=1 --quiet "$REPO_URL" "$TEMP_DIR/repo"

BOOTSTRAP_SRC="$TEMP_DIR/repo/.bootstrap"

[ ! -d ".git" ] && git init

cp -r "$BOOTSTRAP_SRC" .bootstrap
mkdir -p docs/specs .claude/agents .claude/commands

TODAY=$(date +%Y-%m-%d)
sed "s/{DATE}/$TODAY/g" .bootstrap/templates/REQUIREMENTS.md > docs/REQUIREMENTS.md
sed "s/{DATE}/$TODAY/g" .bootstrap/templates/ARCHITECTURE.md > docs/ARCHITECTURE.md

cp .bootstrap/agents/*.md .claude/agents/
cp .bootstrap/skills/*.md .claude/commands/

sed "s|{PROJECT_NAME}|$PROJECT_NAME|g" .bootstrap/CLAUDE.md > CLAUDE.md

echo "Bootstrapped: $PROJECT_NAME"
echo "  .bootstrap/"
echo "  .claude/agents/"
echo "  .claude/commands/"
echo "  docs/REQUIREMENTS.md"
echo "  docs/ARCHITECTURE.md"
echo "  docs/specs/"
echo "  CLAUDE.md"
