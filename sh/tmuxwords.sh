#!/bin/sh

# Usage: Get a list of all currently visible words:
#     sh tmuxwords.sh '' -a
#
# Get all visible words beginning with `foo`:
#     sh tmuxwords.sh ^foo -a
#
# Get all visible lines beginning with `foo`:
#     sh tmuxwords.sh -l ^foo -a ''

if [ -z "$TMUX_PANE" ]; then
    echo "Not running inside tmux!" 1>&2
    exit 1
fi

[ "$1" = "-l" ] && PAT="$2" LIST="$3" CAPT="$4" || PAT="$1" LIST="$2" CAPT="$3"

capturepane() {
    if [ tmux capture-pane -p &> /dev/null ]; then
        # tmux capture-pane understands -p -> use it
        xargs -n1 tmux capture-pane $1 -p -t
    else
        # tmux capture-pane doesn't understand -p (like version 1.6)
        # -> capture to paste-buffer, echo it, then delete it
        xargs -n1 -I{} sh -c "tmux capture-pane $1 -t {} && tmux show-buffer && tmux delete-buffer"
    fi
}

splitwords() {
    # copy lines and split words
    sed -e 'p;s/[^a-zA-Z0-9_]/ /g' |
    # split on spaces
    tr -s '[:space:]' '\n' |
    # remove surrounding non-word characters
    grep -o "\\w.*\\w"
}

splitlines() {
    # remove surrounding whitespace
    grep -o "\\S.*\\S"
}

# list all panes
tmux list-panes $LIST -F '#{pane_active}#{window_active}-#{session_id} #{pane_id}' |
# filter out current pane (use -F to match $ in session id)
grep -v -F "$(tmux display-message -p '11-#{session_id} ')" |
# take the pane id
cut -d' ' -f2 |
# capture panes
capturepane "$CAPT" |
# split words unless -l is specified
( [ "$1" = "-l" ] && splitlines || splitwords ) |
# filter out words not beginning with pattern
grep "$PAT" |
# sort and remove duplicates
sort -u
