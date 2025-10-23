#!/bin/bash

# --- Live Photo MOV -> JPEG frame sequence (macOS) ---
# v5: robust path handling, auto-pair .HEIC -> .MOV, VFR-safe extraction

set -e

echo "

 ██████╗ ██████╗ ███╗   ██╗██╗   ██╗███████╗██████╗ ███████╗██╗ ██████╗ ███╗   ██╗
██╔════╝██╔═══██╗████╗  ██║██║   ██║██╔════╝██╔══██╗██╔════╝██║██╔═══██╗████╗  ██║
██║     ██║   ██║██╔██╗ ██║██║   ██║█████╗  ██████╔╝███████╗██║██║   ██║██╔██╗ ██║
██║     ██║   ██║██║╚██╗██║╚██╗ ██╔╝██╔══╝  ██╔══██╗╚════██║██║██║   ██║██║╚██╗██║
╚██████╗╚██████╔╝██║ ╚████║ ╚████╔╝ ███████╗██║  ██║███████║██║╚██████╔╝██║ ╚████║
 ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                                                                                                       
"

# 1) Ensure Homebrew (optional but handy)
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Installing…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed. Skipping."
fi

# 2) Ensure ffmpeg
if ! command -v ffmpeg &> /dev/null; then
  echo "FFmpeg not found. Installing with Homebrew…"
  brew install ffmpeg
else
  echo "FFmpeg is already installed. Skipping."
fi

echo ""
echo "################################################################"
echo "Drag & drop your Live Photo video (.MOV) OR the .HEIC partner, then press Enter:"
read -r input_path_raw

# 3) Clean & normalize dragged path
#   - strip surrounding quotes from drag & drop
#   - trim leading/trailing spaces
input_path="${input_path_raw% }"
input_path="${input_path#"${input_path%%[![:space:]]*}"}"
input_path="${input_path//\'/}"
input_path="${input_path//\"/}"

if [ -z "$input_path" ] || [ ! -f "$input_path" ]; then
  echo "Error: File not found. Aborting."
  exit 1
fi

# 4) If the user dropped a .HEIC, try to find the paired .MOV next to it
ext_lower="$(echo "${input_path##*.}" | tr '[:upper:]' '[:lower:]')"
mov_file="$input_path"

if [ "$ext_lower" = "heic" ]; then
  dir="$(dirname "$input_path")"
  base="$(basename "$input_path")"
  stem="${base%.*}"
  # Try common partner names: same stem with .MOV/.mov
  if [ -f "$dir/$stem.MOV" ]; then
    mov_file="$dir/$stem.MOV"
  elif [ -f "$dir/$stem.mov" ]; then
    mov_file="$dir/$stem.mov"
  else
    echo "You provided a .HEIC still. Live Photos store motion in a separate .MOV."
    echo "Tip: In Photos.app, export **Unmodified Originals** to get both files."
    echo "Couldn’t find a paired MOV next to: $input_path"
    exit 1
  fi
fi

# 5) Build output dir next to input
input_dir="$(dirname "$mov_file")"
filename="$(basename "$mov_file")"
stem="${filename%.*}"
output_dir="$input_dir/${stem}_frames"

echo "Creating output directory at: $output_dir"
mkdir -p "$output_dir"

echo "Converting… (this can take a moment)"
# 6) Frame extraction (key fix):
#    - Do NOT force a constant fps; use the source timestamps via -vsync vfr
#    - Do NOT ignore edit lists here
#    - Map the first video stream explicitly
#    - Name frames by PTS to guarantee unique ordering even on weird timelines
#    - Use -qscale:v 2 for high quality JPEGs (lower is better, 2~3 is good)
ffmpeg -hide_banner -y \
  -i "$mov_file" \
  -map 0:v:0 -vsync vfr -frame_pts 1 \
  -qscale:v 2 \
  "$output_dir/frame_%010d.jpg"

echo ""
echo "Ⓓⓞⓝⓔ! Ⓕⓡⓐⓜⓔⓢ ⓢⓐⓥⓔⓓ ⓣⓞ:"
echo "$output_dir"
echo "################################################################"
