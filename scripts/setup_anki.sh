#!/usr/bin/env bash
set -euo pipefail

DEFAULT_REPO_URL="https://github.com/ankitects/anki.git"
TARGET_DIR="${ANKI_TARGET_DIR:-anki}"
REPO_URLS="${ANKI_REPO_URLS:-$DEFAULT_REPO_URL}"

printf 'Anki development workspace setup\n'
printf 'Target: %s\n' "$TARGET_DIR"
printf 'Repository candidates:\n'
for repo_url in $REPO_URLS; do
  printf '  - %s\n' "$repo_url"
done
printf '\n'

print_network_context() {
  printf '\nNetwork context:\n'
  for name in HTTPS_PROXY HTTP_PROXY https_proxy http_proxy NO_PROXY no_proxy; do
    if [[ -n "${!name:-}" ]]; then
      printf '  %s=%s\n' "$name" "${!name}"
    fi
  done
}

clone_anki() {
  local repo_url
  local last_log
  last_log="$(mktemp)"

  for repo_url in $REPO_URLS; do
    printf 'Cloning from %s ...\n' "$repo_url"
    if git clone "$repo_url" "$TARGET_DIR" 2>"$last_log"; then
      rm -f "$last_log"
      return 0
    fi

    printf 'Clone failed for %s:\n' "$repo_url" >&2
    sed 's/^/  /' "$last_log" >&2
    rm -rf "$TARGET_DIR"
  done

  print_network_context >&2
  cat >&2 <<'HELP'

All clone attempts failed. If you see "CONNECT tunnel failed, response 403",
the configured proxy rejected the outbound GitHub connection. Run this script on a
network that allows GitHub access, or pass a reachable mirror with ANKI_REPO_URLS.
HELP
  rm -f "$last_log"
  return 1
}

if [[ -d "$TARGET_DIR/.git" ]]; then
  printf 'Existing Anki clone found.\n'
  git -C "$TARGET_DIR" status --short --branch
elif [[ -e "$TARGET_DIR" ]]; then
  printf 'Error: %s exists but is not a git repository. Move it away or remove it first.\n' "$TARGET_DIR" >&2
  exit 1
else
  clone_anki
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
