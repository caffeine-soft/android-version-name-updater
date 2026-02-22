# Update Android Version Name

This GitHub Action updates the `versionName` and `versionCode` in the `build.gradle` or `build.gradle.kts` file for an Android project.

## Inputs

### `project_name`

**Required** The name of the Android project directory containing the `build.gradle` or `build.gradle.kts` file. Default is `app`.

### `project_version`

**Required** The new version name to set in the `build.gradle` or `build.gradle.kts` file.

### `github_token`

**Required** The GitHub token for authentication.

## Example Usage

```yaml
name: Update Version Name

on:
  push:
    branches:
      - main

jobs:
  update-version-name:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Update version name
        uses: caffeine-soft/android-version-name-updater@v1
        with:
          project_name: 'app'
          project_version: '1.0.0'
          github_token: ${{ secrets.GITHUB_TOKEN }}
```
