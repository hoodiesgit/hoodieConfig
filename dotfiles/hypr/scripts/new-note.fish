#!/usr/bin/fish

# --- CONFIGURATION ---
set notes_dir ~/Notes
set terminal ghostty
# --- END CONFIGURATION ---

# Ask the user for the note's title
read -P "Enter the title for your note: " title
if test -z "$title"
    echo "Title cannot be empty. Aborting."
    exit 1
end

# Find existing folders and create a dynamic prompt
set existing_folders (find $notes_dir -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | string join ', ')
set prompt_message "Enter folder in Notes (e.g., $existing_folders): "

# Ask the user for the sub-folder, using the new prompt
read -P "$prompt_message" subfolder
if test -z "$subfolder"
    echo "Folder name cannot be empty. Aborting."
    exit 1
end

# Convert entire folder name to uppercase for consistency
set subfolder (string upper -- "$subfolder")

# Construct the full directory path and create it
set full_dir "$notes_dir/$subfolder"
mkdir -p "$full_dir"

# Convert the title to a clean filename
set filename (string lower -- (string replace -r '[^a-zA-Z0-9]+' '-' "$title") | string trim -c '-').md
set full_path "$full_dir/$filename"

# --- NEW: Auto-cleanup orphaned swap files ---
# Construct the expected swap file path by replacing '/' with '%'
set swap_file (string replace -a '/' '%' -- "$full_path")
set swap_file_path ~/.local/state/nvim/swap/"$swap_file.swp"

# Check if an old swap file exists and remove it
if test -f "$swap_file_path"
    rm "$swap_file_path"
end
# --- END NEW ---

# Check if the file already exists
if test -f "$full_path"
    # If the file exists, open it directly and start in insert mode
    echo "Opening existing note: $full_path"
    sleep 1
    exec nvim -c 'startinsert' "$full_path"
else
    # If the file does not exist, create it with the template
    echo "Creating new note at: $full_path"
    sleep 1
    printf '-------------------------------------------------\nDate: %s\nTitle: %s\n-------------------------------------------------\n\n' (date +%x) $title > "$full_path"

    # Launch nvim, go to the last line, and start in insert mode
    exec nvim -c 'normal! GA' "$full_path"
end
