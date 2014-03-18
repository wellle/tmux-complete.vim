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

# take all lines
# append copy with replaced non word characters
# split on spaces
# filter by first argument
# sort ard remove duplicates
(
panes_current_window
panes_current_session
panes_all_sessions
) |
xargs -n1 tmux capture-pane -J -p -t |
sed -e 'p;s/[^a-zA-Z0-9_]/ /g' |
tr -s '[:space:]' '\n'|
grep "^$1." |
sort -u
