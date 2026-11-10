#!/usr/bin/env bash
# Build a new Smalltalk image from the *.st sources in this folder, without using an existing image.
# Compiles the VM sources (so smallj.jar does not need to be up to date), then runs SmallImageBuilder.
#
# An existing image file is overwritten, but only when the build succeeds.
#
# Usage: ./buildImage.sh [image file name]	(default: image.sjim)
# Example: ./buildImage.sh new.sjim

set -euo pipefail

if [ $# -gt 1 ]; then
	echo "Usage: $0 [image file name]" >&2
	exit 1
fi
imageFileName="${1:-image.sjim}"

# Run from the Smalltalk folder, so source file names in the image are relative to it.
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$scriptDir"

vmDir="../VM"
classesDir="$( mktemp -d )"
trap 'rm -rf "$classesDir"' EXIT

# On Windows (Git Bash / Cygwin), Java needs Windows paths and ';' as classpath separator.
separator=":"
if command -v cygpath > /dev/null; then
	classesDir="$( cygpath -w "$classesDir" )"
	separator=";"
fi
classPath="$classesDir$separator$vmDir/lib/*"

echo "Compiling VM sources..."
javac -nowarn -d "$classesDir" -cp "$vmDir/lib/*" "$vmDir"/src/smallj/core/*.java "$vmDir"/src/smallj/objects/*.java "$vmDir"/src/smallj/compiler/*.java "$vmDir"/src/smallj/image/*.java

# Build into a temporary file first, so a failed build leaves an existing image intact.
echo "Building image: $imageFileName"
tempImageFileName="$imageFileName.tmp"
java -cp "$classPath" SmallImageBuilder . "$tempImageFileName"
mv -f "$tempImageFileName" "$imageFileName"
