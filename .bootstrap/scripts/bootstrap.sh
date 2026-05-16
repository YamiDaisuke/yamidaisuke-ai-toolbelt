#!/bin/bash
# Usage: ./bootstrap.sh <project-name>
# - Creates docs/REQUIREMENTS.md, docs/ARCHITECTURE.md from templates
# - Creates docs/specs/ directory
# - Writes CLAUDE.md pointing to docs/
# - Initializes git if not already a repo

set -e

if [ -z "$1" ]; then
  echo "Error: project name required"
  echo "Usage: $0 <project-name>"
  exit 1
fi

PROJECT_NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATES_DIR="$(dirname "$SCRIPT_DIR")/templates"

if [ ! -d "$TEMPLATES_DIR" ]; then
  echo "Error: templates directory not found at $TEMPLATES_DIR"
  exit 1
fi

[ ! -d ".git" ] && git init

mkdir -p docs/specs

cp "$TEMPLATES_DIR/REQUIREMENTS.md" docs/REQUIREMENTS.md
cp "$TEMPLATES_DIR/ARCHITECTURE.md" docs/ARCHITECTURE.md

cat > CLAUDE.md <<EOF
# Project: $PROJECT_NAME

## Roles active in this repo
- Architect: see .bootstrap/agents/architect.md
- Scrum Master: see .bootstrap/agents/scrum-master.md
- Developer: see .bootstrap/agents/developer.md
- Code Reviewer: see .bootstrap/agents/code-reviewer.md
- QA: see .bootstrap/agents/qa.md

## Key documents
- Requirements: docs/REQUIREMENTS.md
- Architecture: docs/ARCHITECTURE.md
- Specs: docs/specs/*.md

## Current phase
<!-- Update this as the project progresses -->
[ ] Requirements
[ ] Architecture
[ ] Spec writing
[ ] Development
[ ] QA

## Conventions (summary)
<!-- Short-form of ARCHITECTURE.md conventions for quick reference -->
EOF

echo "Bootstrapped: $PROJECT_NAME"
echo "  docs/REQUIREMENTS.md"
echo "  docs/ARCHITECTURE.md"
echo "  docs/specs/"
echo "  CLAUDE.md"
