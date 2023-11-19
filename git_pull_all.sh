# Define the parent directory
parent_directory="/home/kayttaja/Lataukset/Git"

# Get the total number of directories
total_dirs=$(find "$parent_directory" -maxdepth 1 -type d | wc -l)
completed_dirs=0

# Loop through each subdirectory
for dir in "$parent_directory"/*/; do
    # Check if it's a git directory
    if [ -d "$dir/.git" ]; then
        completion_percentage=$((completed_dirs * 100 / total_dirs))
        echo -ne "$dir\n Progress: $completion_percentage%\r"
        # Go into the git directory, pull, and suppress output
        (cd "$dir" && git pull > /dev/null 2>&1)
        # Increment completed count
        ((completed_dirs++))
        # Calculate percentage completion
        #completion_percentage=$((completed_dirs * 100 / total_dirs))
        #echo -ne "Progress: $completion_percentage%\r"
    else
        skipped_dirs+="$dir"$'\n'
    fi
done

echo "Git pull completed for all Git repositories."

# Print directories that are not Git repositories
if [ -n "$skipped_dirs" ]; then
    echo -e "Skipped directories (Not a Git repository):\n$skipped_dirs"
fi
