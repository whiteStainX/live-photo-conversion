#!/bin/bash

# --- JPEG to ASCII Art Converter ---

set -e

echo "
 ______     ______     ______     __     __    
/\  __ \   /\  ___\   /\  ___\   /\ \   /\ \   
\ \  __ \  \ \___  \  \ \ \____  \ \ \  \ \ \  
 \ \_\ \_\  \/\_____\  \ \_____\  \ \_\  \ \_\ 
  \/_/\/_/   \/_____/   \/_____/   \/_/   \/_/ 
                                               
"

# 1) Load configuration
CONFIG_FILE="$(dirname "$0")/ascii.conf"
if [ -f "$CONFIG_FILE" ]; then
  echo "Loading settings from $CONFIG_FILE"
  source "$CONFIG_FILE"
else
  echo "Error: Configuration file not found at $CONFIG_FILE"
  exit 1
fi

echo ""
echo "################################################################"
echo "Drag & drop a folder of images (JPG, PNG) or a single image file, then press Enter:"
read -r input_path_raw

# 2) Clean & normalize dragged path
#   - Strip surrounding quotes from drag & drop
#   - Trim leading/trailing spaces
input_path="${input_path_raw% }"
input_path="${input_path#"${input_path%%[![:space:]]*}"}"
input_path="${input_path//\'/}"
input_path="${input_path//\"/}"

if [ -z "$input_path" ]; then
  echo "Error: No path provided. Aborting."
  exit 1
fi

if [ ! -e "$input_path" ]; then
  echo "Error: File or directory not found at '$input_path'. Aborting."
  exit 1
fi

# 3) Determine output directory
if [ -d "$input_path" ]; then
  # Input is a directory
  input_dir="$input_path"
  folder_name="$(basename "$input_dir")"
  output_dir="$(dirname "$input_dir")/${folder_name}_ascii"
else
  # Input is a file
  input_file="$input_path"
  input_dir="$(dirname "$input_file")"
  filename="$(basename "$input_file")"
  stem="${filename%.*}"
  output_dir="$input_dir/${stem}_ascii"
fi

echo "Creating output directory at: $output_dir"
mkdir -p "$output_dir"

# 4) Process files
echo "Converting..."

if [ -d "$input_path" ]; then
  # Process every image in the directory
  shopt -s nullglob
  for frame in "$input_dir"/*.{jpg,jpeg,png}; do
    if [ -f "$frame" ]; then
      filename=$(basename "$frame")
      stem="${filename%.*}"
      jp2a "$frame" \
        --width="$ASCII_WIDTH" \
        --chars="$ASCII_CHARS" \
        $INVERT_COLORS \
        $COLOR_OUTPUT \
        --output="$output_dir/${stem}.txt"
    fi
  done
else
  # Process the single file
  filename=$(basename "$input_file")
  stem="${filename%.*}"
  jp2a "$input_file" \
    --width="$ASCII_WIDTH" \
    --chars="$ASCII_CHARS" \
    $INVERT_COLORS \
    $COLOR_OUTPUT \
    --output="$output_dir/${stem}.txt"
fi


echo ""
echo "Ⓓⓞⓝⓔ! ⒶⓈⒸⒾⒾ ⓕⓘⓛⓔⓢ ⓢⓐⓥⓔⓓ ⓣⓞ:"
echo "$output_dir"
echo "################################################################"
