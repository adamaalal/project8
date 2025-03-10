#!/bin/bash

# Define the trash directory
TRASH_DIR="$HOME/.utrash"

# Ensure the trash directory exists
mkdir -p "$TRASH_DIR"

# Function to move files or directories to trash
move_to_trash() {
    local target="$1"

    if [[ -z "$target" ]]; then
        echo "Error: No file or directory specified."
        return 1
    fi

    if [[ ! -e "$target" ]]; then
        echo "Error: $target does not exist."
        return 1
    fi

    # Prevent deleting symbolic links
    if [[ -L "$target" ]]; then
        echo "Error: $target is a symbolic link and cannot be moved to trash."
        return 1
    fi

    # Move file or directory to trash
    mv "$target" "$TRASH_DIR/"
    echo "Moved $target to trash."
}

# Function to list trashed files and directories
list_trash() {
    if [[ -z "$(ls -A "$TRASH_DIR")" ]]; then
        echo "Trash is empty."
    else
        ls -l "$TRASH_DIR"
    fi
}

# Function to restore a file or directory from trash
restore_file() {
    local target="$1"

    if [[ -z "$target" ]]; then
        echo "Error: No file or directory specified for undo."
        return 1
    fi

    if [[ ! -e "$TRASH_DIR/$target" ]]; then
        echo "Error: $target not found in trash."
        return 1
    fi

    mv "$TRASH_DIR/$target" "$PWD/"
    echo "Restored $target to $PWD."
}

# Function to empty the trash
empty_trash() {
    if [[ -z "$(ls -A "$TRASH_DIR")" ]]; then
        echo "Trash is already empty."
    else
        rm -rf "$TRASH_DIR"/*
        echo "Trash emptied."
    fi
}

# Main script logic
case "$1" in
    rm)
        move_to_trash "$2"
        ;;
    ls)
        list_trash
        ;;
    undo)
        restore_file "$2"
        ;;
    dump)
        empty_trash
        ;;
    *)
        echo "Usage: $0 {rm file_name | ls | undo file_name | dump}"
        ;;
esac

