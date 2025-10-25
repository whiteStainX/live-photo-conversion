#!/bin/bash

# --- Live Photo MOV -> Sharable MP4 (macOS) ---
# v1: robust path handling, auto-pair .HEIC -> .MOV, high-quality compression

set -e

echo "

░█░░░▀█▀░█▀▀░█░█░▀█▀░░░█░█░█▀▀░▀█▀░█▀▀░█░█░▀█▀
░█░░░░█░░█░█░█▀█░░█░░░░█▄█░█▀▀░░█░░█░█░█▀█░░█░
░▀▀▀░▀▀▀░▀▀▀░▀░▀░░▀░░░░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░░▀░

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

# 5) Build output file path
input_dir="$(dirname "$mov_file")"
filename="$(basename "$mov_file")"
stem="${filename%.*}"
output_file="$input_dir/${stem}_sharable.mp4"

echo "Converting… (this can take a moment)"

# 6) Conversion to MP4
#    - -vcodec h264: Good quality and widely compatible video codec.
#    - -acodec aac: Standard audio codec for MP4.
#    - -crf 23: Constant Rate Factor for quality. Lower is better, 23 is a good balance.
#    - -preset veryfast: Faster encoding without sacrificing too much quality.
ffmpeg -hide_banner -y \
  -i "$mov_file" \
  -vcodec h264 -acodec aac -crf 23 -preset veryfast \
  "$output_file"

echo ""
echo "Ⓓⓞⓝⓔ! Ⓢⓗⓐⓡⓐⓑⓛⓔ ⓥⓘⓓⓔⓞ ⓢⓐⓥⓔⓓ ⓣⓞ:"
echo "$output_file"
echo "################################################################"
