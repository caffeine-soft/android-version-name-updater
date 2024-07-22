# Update Android Version Name

This GitHub Action updates the `versionName` in the `build.gradle` file for an Android project.

## Inputs

### `project_name`

**Required** The name of the Android project directory containing the `build.gradle` file. Default is `app`.

### `project_version`

**Required** The new version name to set in the `build.gradle` file.

### `github_token`

**Required** The GitHub token for authentication.

## Example Usage

```yaml
name: Update Version Code

on:
  push:
    branches:
      - master

jobs:
  update-version-code:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Update version code
        uses: your-username/android-version-name-updater@v1
        with:
          project_name: 'app'
          project_version: '1.0.0'
          github_token: ${{ secrets.GITHUB_TOKEN }}
```