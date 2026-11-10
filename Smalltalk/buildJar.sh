#!/usr/bin/env bash
# Build smallj.jar, the SmallJ VM, from the Java sources in ../VM/src.
# The jar is self-contained: it also holds the classes of the libraries in ../VM/lib, and runs with:
#     java --enable-preview -jar smallj.jar
# An existing jar file is overwritten, but only when the build succeeds.
#
# Usage: ./buildJar.sh [jar file name]	(default: smallj.jar)

set -euo pipefail

if [ $# -gt 1 ]; then
	echo "Usage: $0 [jar file name]" >&2
	exit 1
fi
jarFileName="${1:-smallj.jar}"

# Run from the Smalltalk folder.
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$scriptDir"

vmDir="../VM"
buildDir="$( mktemp -d )"
trap 'rm -rf "$buildDir"' EXIT
classesDir="$buildDir/classes"
mkdir -p "$classesDir"

# On Windows (Git Bash / Cygwin), Java needs Windows paths.
javaClassesDir="$classesDir"
if command -v cygpath > /dev/null; then
	javaClassesDir="$( cygpath -w "$classesDir" )"
fi

echo "Compiling VM sources..."
javac -nowarn -d "$javaClassesDir" -cp "$vmDir/lib/*" "$vmDir"/src/smallj/core/*.java "$vmDir"/src/smallj/objects/*.java "$vmDir"/src/smallj/compiler/*.java "$vmDir"/src/smallj/image/*.java

# Add the library classes. Their manifests are left out, the jar gets its own manifest.
echo "Adding libraries..."
for libraryJar in "$vmDir"/lib/*.jar; do
	( cd "$classesDir" && unzip -q -o "$scriptDir/$libraryJar" -x 'META-INF/MANIFEST.MF' )
done

# Build into a temporary file first, so a failed build leaves an existing jar intact.
echo "Building jar: $jarFileName"
tempJarFileName="$jarFileName.tmp"
jar --create --file "$tempJarFileName" --main-class SmallJApp -C "$javaClassesDir" .
mv -f "$tempJarFileName" "$jarFileName"
echo "Saved jar: $jarFileName"
