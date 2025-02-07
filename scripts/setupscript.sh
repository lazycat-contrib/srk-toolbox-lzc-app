#!/bin/bash

# Define the repository and desired version
REPO="Raka-loah/SRK-Toolbox"
VERSION="v10.19.4"

# Construct the download URL and filename
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$VERSION/SRK_Toolbox_$VERSION.zip"
FILENAME="SRK_Toolbox_$VERSION.zip"
WEB_DIR="../dist"  # Relative path to the dist directory

# Check if wget and unzip are installed
if ! command -v wget &> /dev/null || ! command -v unzip &> /dev/null
then
    echo "wget and/or unzip are not installed.  Please install them to continue."
    echo "On Debian/Ubuntu: sudo apt-get install wget unzip"
    echo "On CentOS/RHEL: sudo yum install wget unzip"
    exit 1
fi

# Create or remove the web directory
if [ -d "$WEB_DIR" ]; then
  echo "Removing existing web directory: $WEB_DIR"
  rm -rf "$WEB_DIR"
fi

echo "Creating web directory: $WEB_DIR"
mkdir -p "$WEB_DIR"

# Check if ZIP file exists for the current version
if [ -f "$FILENAME" ]; then
  echo "ZIP file $FILENAME already exists. Skipping download."
else
  # Remove other versions of the ZIP file
  echo "Removing any other versions of SRK-Toolbox ZIP files..."
  rm -f SRK_Toolbox_*.zip

  # Download the file
  echo "Downloading SRK-Toolbox version $VERSION from $DOWNLOAD_URL..."
  wget -O "$FILENAME" "$DOWNLOAD_URL"

  # Check if the download was successful
  if [ $? -ne 0 ]; then
      echo "Download failed.  Deleting potentially incomplete ZIP file."
      rm -f "$FILENAME"
      echo "Please check the URL and your network connection."
      exit 1
  fi
fi

# Unzip the file into the web directory
echo "Unzipping $FILENAME into $WEB_DIR..."
unzip "$FILENAME" -d "$WEB_DIR"

# Check if the unzip was successful
if [ $? -ne 0 ]; then
    echo "Unzipping failed."
    exit 1
fi

# Rename the HTML file
HTML_FILE="$WEB_DIR/SRK_Toolbox_$VERSION.html"
INDEX_FILE="$WEB_DIR/index.html"

if [ -f "$HTML_FILE" ]; then
  echo "Renaming $HTML_FILE to $INDEX_FILE"
  mv "$HTML_FILE" "$INDEX_FILE"
else
  echo "Error: $HTML_FILE not found.  Unzipping may have failed or the HTML filename is different."
  exit 1
fi

echo "Successfully installed SRK-Toolbox to $WEB_DIR"
echo "The main file is now accessible at $WEB_DIR/index.html"

exit 0
