#!/usr/bin/fish

# Define the directory and create it if it doesn't exist
set quick_note_dir ~/Notes/GENERAL
mkdir -p "$quick_note_dir"

# Create the filename and title based on the current date
set note_date (date +%Y-%m-%d)
set filename "$note_date.md"
set full_path "$quick_note_dir/$filename"

# Auto-cleanup orphaned swap files to prevent errors
set swap_file (string replace -a '/' '%' -- "$full_path")
set swap_file_path ~/.local/state/nvim/swap/"$swap_file.swp"
if test -f "$swap_file_path"
    rm "$swap_file_path"
end

# Check if a note for today already exists
if test -f "$full_path"
    # If the file exists, launch Ghostty and open nvim in insert mode
    ghostty -e nvim -c 'startinsert' "$full_path"
else
    # If the file does not exist, create it with the template
    printf '-------------------------------------------------\nDate: %s\nTitle: %s\n-------------------------------------------------\n\n' (date +%x) $note_date > "$full_path"

    # Launch Ghostty and open nvim at the end of the file in insert mode
    ghostty -e nvim -c 'normal! GA' "$full_path"
end
