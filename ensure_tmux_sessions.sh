#!/usr/bin/env bash
set -euo pipefail

REGISTRY="${1:-$HOME/.config/tmux/session_registry.conf}"

command -v tmux >/dev/null 2>&1 || {
  echo "ensure-tmux-sessions: tmux introuvable" >&2
  exit 1
}

[[ -f "$REGISTRY" ]] || {
  echo "ensure-tmux-sessions: registre introuvable: $REGISTRY" >&2
  exit 1
}

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

while IFS= read -r line || [[ -n "$line" ]]; do
  line="$(trim "$line")"

  [[ -z "$line" ]] && continue
  [[ "$line" == \#* ]] && continue

  session="${line%%:*}"
  path=""

  if [[ "$line" == *:* ]]; then
    path="${line#*:}"
  fi

  session="$(trim "$session")"
  path="$(trim "$path")"

  [[ -n "$session" ]] || continue

  if ! tmux has-session -t "$session" 2>/dev/null; then
    if [[ -z "$path" ]]; then
      tmux new-session -d -s "$session" -n main
    elif [[ -d "$path" ]]; then
      tmux new-session -d -s "$session" -c "$path" -n main
    elif [[ -f "$path" && -x "$path" ]]; then
      "$path" "$session"
    else
      echo "ensure-tmux-sessions: chemin invalide pour '$session': $path" >&2
      exit 1
    fi
  fi
done <"$REGISTRY"
