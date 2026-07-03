#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ankitects/anki.git"
TARGET_DIR="anki"

printf 'Anki development workspace setup\n'
printf 'Repository: %s\n' "$REPO_URL"
printf 'Target: %s\n\n' "$TARGET_DIR"

if [[ -d "$TARGET_DIR/.git" ]]; then
  printf 'Existing Anki clone found.\n'
  git -C "$TARGET_DIR" status --short --branch
elif [[ -e "$TARGET_DIR" ]]; then
  printf 'Error: %s exists but is not a git repository. Move it away or remove it first.\n' "$TARGET_DIR" >&2
  exit 1
else
  git clone "$REPO_URL" "$TARGET_DIR"
fi

printf '\nTool availability:\n'
for tool in git python3 node yarn bazel; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '  [ok]      %s -> %s\n' "$tool" "$(command -v "$tool")"
  else
    printf '  [missing] %s\n' "$tool"
  fi
done

cat <<'NEXT_STEPS'

Next steps:
  cd anki
  git status
  git switch -c my-improvement

Review anki/README.md after cloning for the current build and test workflow.
NEXT_STEPS
