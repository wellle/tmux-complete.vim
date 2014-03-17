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

allwords() {
    tmux list-panes -F '#{pane_active} #P' |
    while read active pane; do
        [[ "$active" -eq 0 ]] && tmux capture-pane -J -p -t "$pane"
    done |
    fmt -1 |
    sed -e 'p;s/[^a-zA-Z0-9_]/ /g' |
    fmt -1 |
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

# take all pane words
# filter by first argument
# sort ard remove duplicates

allwords          \
    | grep "^$1." \
    | sort -u
