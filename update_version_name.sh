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

BUILD_GRADLE_FILE=""
if [ -f "$PROJECT_NAME/build.gradle" ]; then
  BUILD_GRADLE_FILE="$PROJECT_NAME/build.gradle"
elif [ -f "$PROJECT_NAME/build.gradle.kts" ]; then
  BUILD_GRADLE_FILE="$PROJECT_NAME/build.gradle.kts"
else
  echo "Neither build.gradle nor build.gradle.kts found in $PROJECT_NAME directory"
  exit 1
fi

# Unified regex approach for both Groovy and Kotlin DSLs
# Handles both: versionName "1.0" and versionName = "1.0"
sed -i -E "s/(versionName[[:space:]]*=?[[:space:]]*)\"[^\"]+\"/\1\"${PROJECT_VERSION#v}\"/" "$BUILD_GRADLE_FILE"
echo "Updated version name to ${PROJECT_VERSION#v} in $BUILD_GRADLE_FILE"

# Extract old version code safely
old_version_code=$(grep 'versionCode' "$BUILD_GRADLE_FILE" | head -n 1 | sed -E 's/.*versionCode[[:space:]]*=?[[:space:]]*([0-9]+).*/\1/')
if [ ! -z "$old_version_code" ]; then
  new_version_code=$((old_version_code + 1))
  sed -i -E "s/(versionCode[[:space:]]*=?[[:space:]]*)[0-9]+/\1${new_version_code}/" "$BUILD_GRADLE_FILE"
  echo "Updated version code to $new_version_code"
fi

git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

git add "$BUILD_GRADLE_FILE"
git commit -m "Bump version to ${PROJECT_VERSION} [no ci]"

BRANCH_NAME=${GITHUB_REF#refs/heads/}

REPO_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git push "${REPO_URL}" HEAD:"$BRANCH_NAME"
