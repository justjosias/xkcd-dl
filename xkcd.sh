#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -s start_comic -e end_comic -d target_directory"
    exit 1
}

# Parse arguments
while getopts ":s:e:d:" opt; do
  case $opt in
    s) start_comic="$OPTARG"
    ;;
    e) end_comic="$OPTARG"
    ;;
    d) target_directory="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
        usage
    ;;
  esac
done

# Check if all parameters are provided
if [ -z "$start_comic" ] || [ -z "$end_comic" ] || [ -z "$target_directory" ]; then
    usage
fi

# Create target directory if not exists
mkdir -p "$target_directory"

# Download comics in the specified range
for (( num=$start_comic; num<=$end_comic; num++ ))
do
    echo "Downloading xkcd comic #$num"
    json_url="https://xkcd.com/$num/info.0.json"
    json_data=$(curl -s "$json_url")

    # Extract image URL
    img_url=$(echo "$json_data" | jq -r '.img')

    # Extract image filename
    img_filename=$(basename "$img_url")

    # Download the image
    curl -s -o "$target_directory/$img_filename" "$img_url"

    if [ $? -eq 0 ]; then
        echo "Downloaded $img_filename"
    else
        echo "Failed to download $img_filename"
    fi
done

echo "Download complete."

