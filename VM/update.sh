#!/usr/bin/env bash
# Update the Java libraries in the lib folder to their latest release versions from Maven Central.
# Without -y it only shows which libraries have a newer version. With -y it downloads them,
# checks each download against its published SHA-1 checksum, and replaces the old jar files.
# After an update, rebuild the VM with ../Smalltalk/buildJar.sh and run the unit tests,
# and clean the cache of the VSCode Java extension (see the end of this script).
#
# Usage: ./update.sh [-y]

set -euo pipefail

# The libraries, as Maven group id and artifact id. The jar files are named <artifact id>-<version>.jar.
libraries=(
	"commons-beanutils:commons-beanutils"
	"org.apache.commons:commons-lang3"
	"commons-logging:commons-logging"
)
repositoryUrl="https://repo1.maven.org/maven2"

confirmed=false
if [ $# -eq 1 ] && [ "$1" = "-y" ]; then
	confirmed=true
elif [ $# -ne 0 ]; then
	echo "Usage: $0 [-y]" >&2
	exit 1
fi

# Run from the VM folder.
cd "$( dirname "${BASH_SOURCE[0]}" )"
libDir="lib"
downloadDir="$( mktemp -d )"
trap 'rm -rf "$downloadDir"' EXIT

# Print the latest release version of a library, read from its Maven metadata.
latestVersion()
{
	local groupPath="$1" artifactId="$2"
	curl --fail --silent --show-error "$repositoryUrl/$groupPath/$artifactId/maven-metadata.xml" |
		sed -n 's:.*<release>\(.*\)</release>.*:\1:p'
}

# Print the version of the jar of a library in the lib folder, or nothing if there is none.
currentVersion()
{
	local artifactId="$1" jarFile
	for jarFile in "$libDir/$artifactId"-[0-9]*.jar; do
		[ -f "$jarFile" ] || continue
		jarFile="${jarFile##*/}"
		jarFile="${jarFile#"$artifactId"-}"
		echo "${jarFile%.jar}"
		return
	done
}

# Return success if version $1 is older than version $2.
isOlder()
{
	[ "$1" != "$2" ] && [ "$( printf '%s\n%s\n' "$1" "$2" | sort -V | head -n 1 )" = "$1" ]
}

updates=0
for library in "${libraries[@]}"; do
	groupId="${library%%:*}"
	artifactId="${library##*:}"
	groupPath="${groupId//.//}"

	latest="$( latestVersion "$groupPath" "$artifactId" )"
	if [ -z "$latest" ]; then
		echo "$artifactId: cannot find the latest version" >&2
		exit 1
	fi
	current="$( currentVersion "$artifactId" )"

	if [ -n "$current" ] && ! isOlder "$current" "$latest"; then
		echo "$artifactId: $current is up to date"
		continue
	fi
	updates=$(( updates + 1 ))
	echo "$artifactId: ${current:-none} -> $latest"
	$confirmed || continue

	# Download the new jar and check it before replacing the old one.
	jarName="$artifactId-$latest.jar"
	jarUrl="$repositoryUrl/$groupPath/$artifactId/$latest/$jarName"
	curl --fail --silent --show-error --output "$downloadDir/$jarName" "$jarUrl"
	expectedSha1="$( curl --fail --silent --show-error "$jarUrl.sha1" | cut -c1-40 )"
	actualSha1="$( sha1sum "$downloadDir/$jarName" | cut -c1-40 )"
	if [ "$expectedSha1" != "$actualSha1" ]; then
		echo "$artifactId: checksum mismatch for $jarName, not updated" >&2
		exit 1
	fi

	if [ -n "$current" ]; then
		rm -f "$libDir/$artifactId-$current.jar"
	fi
	mv "$downloadDir/$jarName" "$libDir/$jarName"
	echo "$artifactId: updated to $latest"
done

if [ $updates -eq 0 ]; then
	echo "All libraries are up to date."
elif ! $confirmed; then
	echo "Run with -y to update $updates librar$( [ $updates -eq 1 ] && echo y || echo ies )."
else
	echo "Rebuild the VM with ../Smalltalk/buildJar.sh and run the unit tests."
	echo "In VSCode, run the command 'Java: Clean Java Language Server Workspace', because the Java extension"
	echo "caches the classpath with the old jar file names, which makes Run and Debug fail."
fi
