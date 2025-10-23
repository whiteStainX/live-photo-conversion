#!/bin/bash

# --- ASCII TXT files to Go slice ---

set -e

echo "
    _______  _______  
  //       \/       \\
 //      __/        //
/       / /         / 
\________/\________/  
                                                
"

# 1) Get input directory
echo "################################################################"
echo "Drag & drop the folder containing your ASCII .txt files, then press Enter:"
read -r input_path_raw

# Clean & normalize dragged path
input_path="${input_path_raw% }"
input_path="${input_path#"${input_path%%[![:space:]]*}"}"
input_path="${input_path//\'/}"
input_path="${input_path//\"/}"

if [ -z "$input_path" ] || [ ! -d "$input_path" ]; then
  echo "Error: Directory not found. Aborting."
  exit 1
fi

# 2) Get variable name
echo ""
echo "Enter the name for your Go slice variable (e.g., coinFrames):"
read -r go_var_name

if [ -z "$go_var_name" ]; then
  echo "Error: No variable name provided. Aborting."
  exit 1
fi

# 3) Generate output file name (convert camelCase to snake_case)
go_file_name=$(echo "$go_var_name" | sed -r 's/([A-Z])/\_\L\1/g' | sed 's/^_//')_frames.go
output_file="$(dirname "$input_path")/$go_file_name"

# 4) Start writing the Go file
echo "Creating Go file at: $output_file"
echo "package frames" > "$output_file"
echo "" >> "$output_file"
echo "var $go_var_name = []string{" >> "$output_file"

# 5) Process all .txt files in natural sort order
# Use ls -v to handle numbers in filenames correctly (e.g., frame_10.txt after frame_9.txt)
file_count=0
while IFS= read -r file; do
  if [ -f "$file" ]; then
    echo "Processing $(basename "$file")..."
    # Append the content wrapped in backticks
    echo '`' >> "$output_file"
    cat "$file" >> "$output_file"
    echo '`,' >> "$output_file"
    file_count=$((file_count + 1))
  fi
done < <(ls -v "$input_path"/*.txt)

# 6) Close the Go slice
echo "}" >> "$output_file"

echo ""
echo "Ⓓⓞⓝⓔ! $file_count frames converted into Go slice."
echo "File saved to: $output_file"
echo "################################################################"
