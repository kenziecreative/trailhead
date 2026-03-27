#!/bin/bash
# hook-utils.sh — Shared utility library for all knzinit hooks.
# Source this file at the top of every hook script:
#
#   source "$(dirname "$0")/hook-utils.sh"
#   trap 'log_error "hook-name" "$BASH_COMMAND failed (line $LINENO)"; exit 0' ERR
#
# Do NOT execute this file directly — it is a sourceable library only.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# log_error <hook_name> <error_message>
# Appends a timestamped error entry to .claude/hook-errors.log and emits to stderr.
# Creates .claude/ directory if it does not exist.
log_error() {
  local hook_name="$1"
  local error_message="$2"
  local timestamp
  timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  local log_dir="$PROJECT_DIR/.claude"
  mkdir -p "$log_dir"
  echo "[$timestamp] [$hook_name] $error_message" >> "$log_dir/hook-errors.log"
  echo "HOOK ERROR [$hook_name]: $error_message" >&2
}

# is_git_project
# Returns 0 (true) if $PROJECT_DIR/.git exists, 1 (false) otherwise.
# No output — pure boolean for use in conditionals.
#   if is_git_project; then ... fi
is_git_project() {
  [ -d "$PROJECT_DIR/.git" ]
}

# read_state_field <field_name>
# Reads $PROJECT_DIR/.planning/STATE.md and extracts the content under
# the matching "## field_name" heading up to the next "## " heading (or EOF).
# Outputs extracted lines to stdout (trimmed of leading/trailing blank lines).
# Returns 1 if STATE.md does not exist or the field is not found.
read_state_field() {
  local field_name="$1"
  local state_file="$PROJECT_DIR/.planning/STATE.md"

  if [ ! -f "$state_file" ]; then
    return 1
  fi

  # Extract content between ## field_name and the next ## heading (or EOF),
  # strip the boundary lines themselves, then trim leading/trailing blank lines.
  local content
  content=$(awk -v field="## $field_name" '
    found && /^## / { found=0; next }
    $0 == field { found=1; next }
    found { print }
  ' "$state_file")

  if [ -z "$content" ]; then
    return 1
  fi

  # Trim leading blank lines
  content=$(echo "$content" | sed '/./,$!d')
  # Trim trailing blank lines
  content=$(echo "$content" | sed -e :a -e '/^\n*$/{$d;N;ba}')

  echo "$content"
}

# Usage in hook scripts:
#   source "$(dirname "$0")/hook-utils.sh"
#   trap 'log_error "hook-name" "$BASH_COMMAND failed (line $LINENO)"; exit 0' ERR
