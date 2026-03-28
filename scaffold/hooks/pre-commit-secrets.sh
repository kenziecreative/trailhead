#!/bin/bash
# Pre-commit secrets hook: checks staged files for common secret patterns
# Registered as PreToolUse hook on the Bash matcher — fires on any Bash tool use, checks staged files
# No-op in non-git projects (exits early via is_git_project check).

source "$(dirname "$0")/hook-utils.sh"
trap 'log_error "pre-commit-secrets" "$BASH_COMMAND failed (line $LINENO)"; exit 0' ERR

# PROJECT_DIR is set by hook-utils.sh

# This hook checks staged files which requires git. No-op in non-git projects.
is_git_project || exit 0

STAGED_FILES=$(git -C "$PROJECT_DIR" diff --cached --name-only 2>/dev/null)
[ -z "$STAGED_FILES" ] && exit 0

FOUND_SECRETS=0

while IFS= read -r file; do
  # Skip binary files
  file_path="$PROJECT_DIR/$file"
  [ ! -f "$file_path" ] && continue
  file -b --mime-type "$file_path" 2>/dev/null | grep -q '^text/' || continue

  # Check for common secret patterns
  if grep -qE '(sk_live_|sk_test_|AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{36}|glpat-[a-zA-Z0-9\-]{20}|xox[bpoas]-[a-zA-Z0-9\-]+|-----BEGIN (RSA |EC |DSA )?PRIVATE KEY-----|eyJ[a-zA-Z0-9_-]*\.eyJ[a-zA-Z0-9_-]*\.)' "$file_path" 2>/dev/null; then
    echo "SECRETS CHECK: Potential secret detected in $file" >&2
    FOUND_SECRETS=1
  fi
done <<< "$STAGED_FILES"

if [ "$FOUND_SECRETS" -eq 1 ]; then
  echo "SECRETS CHECK FAILED: Review flagged files before committing. Remove secrets or add to .gitignore." >&2
  exit 2
fi
exit 0
