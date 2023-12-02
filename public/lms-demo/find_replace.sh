#!/bin/bash

# Function to recursively find and replace in files
find_replace() {
    local search_query="$1"
    local replace_text="$2"
    local directory="$3"
    local include_subfolders="$4"

    local grep_options=""
    if [ "$include_subfolders" == "n" ]; then
        # Exclude subfolders from the search
        grep_options="-maxdepth 1"
    fi

    # Find files with the search query
    local files_changed=($(find "$directory" $grep_options -type f -exec grep -rl "$search_query" {} +))

    # Iterate through files and replace text
    for file in "${files_changed[@]}"; do
        echo "Searching and replacing in: $file"
        sed -i "s/$search_query/$replace_text/g" "$file"
    done

    # Notify the user about the number of files changed and the list of files
    local num_files_changed=${#files_changed[@]}
    echo "Replacement completed successfully in $num_files_changed file(s)."

    if [ $num_files_changed -gt 0 ]; then
        echo "List of files:"
        printf '%s\n' "${files_changed[@]}"
    fi
}

# Determine the script's directory
script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Input from the user
read -p "Enter the search query: " search_query
read -p "Enter the text for replacement: " replace_text
read -p "Include subfolders? (y/n): " include_subfolders

# Perform find and replace within the script's directory
find_replace "$search_query" "$replace_text" "$script_directory" "$include_subfolders"
