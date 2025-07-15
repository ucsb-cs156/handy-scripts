#!/bin/bash

# This script can help you resolve merge conflicts manually.
# To use it:
#   1. Type this at the command line (once per bash terminal session)
#        source ./merge-conflict-helper.sh
#      This will define the functions in this script.
#      You can also add this line to your .bashrc or .bash_profile to make it available in all terminal sessions.
#   2. Try rebasing on main, or mering in the main branch
#      If there are conflicts, git status will show those to you. 
#   3. Type this command to bring up the first conflicted file in VS Code:
#      code `first_conflict`
#   4. Resolve the conflict in the file and save it.
#   5. Type this command to mark the file as resolved:
#      git add `first_conflict`
#   6. Repeat steps 3-5 until all conflicts are resolved.
#   7. Continue the rebase or conclude the merge.

generate_temp_file_name() {
    echo "/tmp/merge-conflict-resolver-$(date +%s%N)"
}

get_last_element() {
  echo $1 | grep -oE '[^[:space:]]+$'
}

first_conflicted_file() {
    # Open the first argument as a file
    if [ -z "$1" ]; then
        echo "No file provided."
        return 1
    fi
    if [ ! -f "$1" ]; then
        echo "File does not exist: $1"
        return 1
    fi

    local marker="(use \"git add <file>...\" to mark resolution)"
    local found=0
    while IFS= read -r line; do
        if [[ "$line" == *"$marker"* ]]; then
            # If we found the marker, we want to return the next line
            IFS= read -r line
            echo "$(get_last_element "$line")"
            return 0
        fi
    done <"$1"
    echo "Error: No line found after marker in $1"
    return 1
}

first_conflict() {
    TEMP_FILE="$(generate_temp_file_name)"
    git status >>"$TEMP_FILE"
    CONFLICTED_FILE="$(first_conflicted_file "$TEMP_FILE")"
    echo "$CONFLICTED_FILE"
    rm -f "$TEMP_FILE"
}
