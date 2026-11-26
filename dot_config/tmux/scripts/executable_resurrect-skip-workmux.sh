#!/bin/sh
# tmux-resurrect save hook: leaves workmux's sessions out of each save.
#
# Run by tmux-resurrect's save.sh as @resurrect-hook-post-save-layout, after
# it has written the layout and before it points `last` at it, with the save
# file as $1. Every save goes through it, prefix C-s's and continuum's alike.
# Full reference:
# https://github.com/tmux-plugins/tmux-resurrect/blob/master/docs/hooks.md
#
# Kept in sync with ~/.config/tmux/tmux.conf
#   - @resurrect-hook-post-save-layout runs this file.
#
# Kept in sync with ~/.config/workmux/config.yaml
#   - __worktrees/ is workmux's default worktree_dir, <project>__worktrees,
#     which that file leaves unset. Setting worktree_dir means updating the
#     pattern below.

# workmux restores its own sessions (prefix C-w) and skips any already open.
# Brought back by tmux-resurrect, they would hold a plain shell where the agent
# was, and the agent would never restart.
#
# A session is workmux's when its start directory is in a worktree: workmux
# sets it when it creates the session, and neither a pane's `cd` nor a window
# rename changes it. The whole session goes, so no saved window is left
# missing panes. Ordinary sessions stay whole, even with a pane in a worktree.
set -eu

save=$1
tmp=$save.tmp
trap 'rm -f "$tmp"' EXIT

# A failure here exits before the save is touched.
tab=$(printf '\t')
sessions=$(tmux list-sessions -F "#{session_name}$tab#{session_path}")
WORKMUX_SESSIONS=$(printf '%s\n' "$sessions" |
  awk -F '\t' '$2 ~ /__worktrees\// { print $1 }')
[ -n "$WORKMUX_SESSIONS" ] || exit 0
# ENVIRON, unlike awk -v, passes the names without processing backslashes.
export WORKMUX_SESSIONS

# Every line naming a session has it in $2: pane, window, grouped_session
# (original in $3) and state (the client's session, last session in $3).
# restore switches the client to the state line's sessions, so a state line
# naming a workmux session goes too, and the client stays where it is.
awk -F '\t' '
  BEGIN {
    n = split(ENVIRON["WORKMUX_SESSIONS"], names, "\n")
    for (i = 1; i <= n; i++) workmux[names[i]] = 1
  }
  ($1 == "pane" || $1 == "window") && ($2 in workmux) { next }
  ($1 == "grouped_session" || $1 == "state") &&
    (($2 in workmux) || ($3 in workmux)) { next }
  { print }
' "$save" > "$tmp"

# With only workmux's sessions open, there is nothing for prefix C-r to
# restore, and tmux-resurrect, handed an empty save on a fresh tmux, would
# close its only session and stop the server. Removing the save instead
# leaves `last` pointing at nothing, so prefix C-r reports no save found.
if ! grep -q '^pane' "$tmp"; then
  rm -f "$save"
  exit 0
fi
mv "$tmp" "$save"
