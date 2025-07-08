#!/usr/bin/fish

# This script safely opens a file in Neovim after cleaning up old swap files.
# It takes the file to open as its first argument.

# Exit if no file path is provided
if test -z "$argv[1]"
    exit 1
end

set target_file $argv[1]

# --- Auto-cleanup orphaned swap files ---
set swap_file (string replace -a '/' '%' -- "$target_file")
set swap_file_path ~/.local/state/nvim/swap/"$swap_file.swp"

if test -f "$swap_file_path"
    rm "$swap_file_path"
end
# --- END Auto-cleanup ---

# Launch Neovim in your preferred terminal (Ghostty)
ghostty -e nvim "$target_file"
