#!/bin/bash

# This script ensures all necessary dependencies for the project are installed.

set -e

# 1) Ensure Homebrew
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Installing…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# 2) Ensure jp2a
if ! command -v jp2a &> /dev/null; then
  echo "jp2a not found. Installing with Homebrew…"
  brew install jp2a
else
  echo "jp2a is already installed."
fi

echo ""
echo "All dependencies are installed."
