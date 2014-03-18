#!/bin/sh

# Usage: Get a list of all currently visible words:
#     sh panewords.sh
#
# Get all visible words beginning with `foo`:
#     sh panewords.sh foo

if [[ -z "$TMUX_PANE" ]]; then
    echo "Not running inside tmux!" 1>&2
    exit 1
fi

panes_current_window() {
    tmux list-panes -F '#{pane_active} #P' |
    while read active pane; do
        [[ "$active" -eq 0 ]] && echo "$pane"
    done
}

panes_current_session() {
    tmux list-panes -s -F '#{window_active} #I.#P' |
    while read active pane; do
        [[ "$active" -eq 0 ]] && echo "$pane"
    done
}

panes_all_sessions() {
    current=$(tmux display-message -p '#S')
    tmux list-panes -a -F '#S #I.#P' |
    while read session pane; do
        [[ $current != $session ]] && echo "$session:$pane"
    done
}

(
# panes from active window except active pane
panes_current_window
# panes from active session except active window
panes_current_session
# panes from all sessions except active session
panes_all_sessions
) |
# capture lines of those panes
xargs -n1 tmux capture-pane -J -p -t |
# append copy with replaced non-word characters
sed -e 'p;s/[^a-zA-Z0-9_]/ /g' |
# split on spaces
tr -s '[:space:]' '\n' |
# remove words not beginning with first argument
grep "^$1." |
# sort and remove duplicates
sort -u
