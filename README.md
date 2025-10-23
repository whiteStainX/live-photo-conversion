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

## Bonus: Convert Frames to ASCII Art

This project also includes a script to convert any image file (`.jpg`, `.png`) or folder of images into text-based ASCII art.

### How to Use

1.  **Install Dependencies:**
    *   Before you begin, run the command: `./install_dependencies.sh`.
    *   This will ensure `jp2a`, the image-to-ASCII converter, is installed.

2.  **Configure (Optional):**
    *   You can easily change the ASCII output by editing the `ascii.conf` file.
    *   Adjust variables like `ASCII_WIDTH` and `ASCII_CHARS` to experiment with different styles.

3.  **Run the ASCII Converter:**
    *   Run the command: `./convert_to_ascii.sh`.
    *   Drag and drop a folder of images (like the `..._frames` folder) or a single `.jpg`/`.png` file onto the Terminal window and press Enter.

4.  **Done!**
    *   A new folder named `..._ascii` will be created, containing a `.txt` file for each converted image.

## Final Step: Compile ASCII to Go

Finally, you can compile your folder of ASCII `.txt` frames into a single Go file containing a `[]string` slice, perfect for animations in Go applications.

### How to Use

1.  **Run the Go Converter:**
    *   Run the command: `./txt_to_go.sh`.

2.  **Provide Input:**
    *   Drag and drop the folder containing your `.txt` files (e.g., `..._ascii`) onto the Terminal and press Enter.
    *   When prompted, enter a name for your Go variable (like `myAnimation`).

3.  **Done!**
    *   A new `my_animation_frames.go` file will be generated, containing all your frames neatly packed into a Go slice.