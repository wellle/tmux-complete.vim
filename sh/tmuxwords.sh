#!/bin/sh

# Usage: Get a list of all currently visible words:
#     sh panewords
#
# Get all visible words beginning with `foo`:
#     sh panewords foo

if [[ -z "$TMUX_PANE" ]]; then
    echo "Not running inside tmux!" 1>&2
    exit 1
fi

allwords() {
    for pane in $(tmux list-panes -F '#P'); do
        for long in $(tmux capture-pane -J -p -t $pane); do
            for short in $(echo $long | sed -e 's/[^a-zA-Z0-9_]/ /g'); do
                echo $short
            done
            echo $long
        done
    done
}

# take all pane words
# filter by first argument
# sort ard remove duplicates

allwords          \
    | grep "^$1." \
    | sort -u
