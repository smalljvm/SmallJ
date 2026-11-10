#!/usr/bin/env bash
# Start SmallJ, opening the System Browser. Output is written to smallj.log.
#
# Usage: ./start.sh [ image file name ]
# Default image file name: image.sjim

set -euo pipefail

imageFileName="${1:-image.sjim}"

# Run from the Smalltalk folder, because source file names in the image are relative to it.
cd "$( dirname "${BASH_SOURCE[0]}" )"

if [ ! -f "$imageFileName" ]; then
	echo "Image file not found: $imageFileName" >&2
	exit 1
fi

# Run in the background, like 'start javaw' in the former SmallJ.cmd, so the terminal stays free.
java --enable-preview -jar smallj.jar "$imageFileName" > smallj.log 2>&1 &
echo "SmallJ started with image: $imageFileName (output in smallj.log)"
