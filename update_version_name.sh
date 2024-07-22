#!/bin/bash
set -e

PROJECT_NAME=$1
PROJECT_VERSION=$2
GITHUB_TOKEN=$3

if [ -z "$PROJECT_NAME" ]; then
  echo "Project name is required"
  exit 1
fi

if [ -z "$PROJECT_VERSION" ]; then
  echo "Project version is required"
  exit 1
fi

if [ -z "$GITHUB_TOKEN" ]; then
  echo "GITHUB_TOKEN is required"
  exit 1
fi

BUILD_GRADLE_FILE="$PROJECT_NAME/build.gradle"

if [ ! -f "$BUILD_GRADLE_FILE" ]; then
  echo "build.gradle file not found in $PROJECT_NAME directory"
  exit 1
fi

# Update the build.gradle file with the new version name
sed -i "s/versionName \"[^\"]\+\"/versionName \"${PROJECT_VERSION#v}\"/" "$BUILD_GRADLE_FILE"
echo "Updated version name in $BUILD_GRADLE_FILE"

# Commit and push the new version code
git add "$BUILD_GRADLE_FILE"
git commit -m "Bump version name to ${PROJECT_VERSION}"

# Use the GITHUB_TOKEN for authentication
REPO_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git push "${REPO_URL}"