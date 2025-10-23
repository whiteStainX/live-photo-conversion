# Convert Live Photos to JPEG Sequences

This tool extracts all the individual frames from an Apple Live Photo and saves them as high-quality JPEG images. 

## How It Works

A Live Photo is a combination of a still image (`.HEIC`) and a short video (`.MOV`). This script uses `ffmpeg` to process the `.MOV` file and convert every frame into a separate `.jpg` file.

## Requirements

*   **macOS**
*   **Homebrew** (will be installed automatically if you don't have it)

## How to Use

1.  **Export Your Live Photo:**
    *   In the Photos app, select a Live Photo.
    *   Go to `File` > `Export` > `Export Unmodified Original for 1 Photo...`.
    *   Make sure you export both the `.HEIC` and `.MOV` files.

2.  **Run the Script:**
    *   Navigate to this project's directory.
    *   Run the command: `./convert.sh`. (make sure executable ```chmod +x ./convert.sh```)
    *   Drag and drop either the `.HEIC` or `.MOV` file onto the Terminal window and press Enter.

3.  **Done!**
    *   A new folder named `IMG_1234_frames` will be created, containing all the extracted JPEG frames.

## The Script

The conversion is handled by the `convert.sh` script in this repository. It automatically installs `ffmpeg` (a powerful video tool) if it's not already on your system.

## Next Steps

Considering subsequnt processing (converting to ASCII, in a more subtle way) integration