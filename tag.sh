#!/usr/bin/env bash

# Sync with remote repository
sync_repo() {
    git pull
    git fetch --prune --prune-tags --tags --force
}

# Function to display help text
show_help() {
    echo "Usage: $0 <version>"
    echo ""
    echo "This script syncs the local repository with the remote,"
    echo "ensures all commits are pushed, and tags the repository"
    echo "with a new version based on the given version and the current date."
    echo ""
    echo "Version should be in the format: X.Y.Z (without the 'v' prefix)."
    echo "Example: $0 4.13.1"
    echo ""
    
    # Suggest the latest major version tags
    echo "Latest major version tags found:"
    
    # Get the latest major version for each major version present in tags
    git fetch --tags --force  # Ensure tags are fetched
    major_tags=$(git tag -l | grep -oE '^v[0-9]+' | sort -u)  # Extract unique major version numbers
    
    for major in $major_tags; do
        latest=$(git tag -l "${major}.*" | grep -oE '^v[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)
        if [[ -n $latest ]]; then
            echo " - Latest for major version $major: ${latest#v}"  # Strip 'v' prefix from the tag
        fi
    done
}

# Check for the correct number of arguments
if [[ $# -ne 1 ]]; then
    echo "Error: You must provide exactly one argument for the version."
    show_help
    exit 1
fi

# Extract and validate the version argument
QLC_VERSION="$1"
if [[ ! $QLC_VERSION =~ ^v?([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo "Error: You must provide the QLC+ version"
    show_help
    exit 1
fi
# Strip the 'v' prefix if it's included
QLC_VERSION="${QLC_VERSION#v}"

sync_repo

# Make sure commits are pushed before tagging.
git push

# Build Date
DATE_CODE="$(date '+%y%m%d')"

# Determine the latest build number from existing tags
latest_build=$(git tag -l "v${QLC_VERSION}-b+${DATE_CODE}.*" | sort -V | tail -n 1)

if [[ -n $latest_build ]]; then
    # Extract the build number and increment it
    BUILD_NUMBER=$(echo "$latest_build" | sed -E "s/.*\.([0-9]+)$/\1/")
    BUILD=$((BUILD_NUMBER + 1))
else
    BUILD=1  # Start at 0 if no existing tags are found
fi

# Tag the new version
git tag "v${QLC_VERSION}-b+${DATE_CODE}.${BUILD}"
git push origin --tags

# Start a background process to update the local repo after 15 minutes
(sleep 900 && sync_repo) &
