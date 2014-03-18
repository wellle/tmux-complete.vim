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
    done
}

# take all lines
# append copy with replaced non word characters
# split on spaces
# filter by first argument
# sort ard remove duplicates
allwords |
sed -e 'p;s/[^a-zA-Z0-9_]/ /g' |
tr -s '[:space:]' '\n'|
grep "^$1." |
sort -u
