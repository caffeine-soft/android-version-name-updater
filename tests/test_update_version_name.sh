#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
UPDATE_SCRIPT="$SCRIPT_DIR/../update_version_name.sh"
DUMMY_DIR="$SCRIPT_DIR/dummy_project"

cleanup() {
  rm -rf "$DUMMY_DIR"
}

trap cleanup EXIT

# -------------------------------------------------------------------------
# Test 1: Standard Groovy DSL
# -------------------------------------------------------------------------
echo "Testing Standard Groovy DSL..."
mkdir -p "$DUMMY_DIR"
cat << 'EOF' > "$DUMMY_DIR/build.gradle"
android {
    defaultConfig {
        applicationId "com.example.app"
        minSdk 24
        targetSdk 33
        versionCode 1
        versionName "1.0"
    }
}
EOF

bash "$UPDATE_SCRIPT" "tests/dummy_project" "v1.5.0" "dummy_token"

if ! grep -q 'versionName "1.5.0"' "$DUMMY_DIR/build.gradle"; then
  echo "❌ Test 1 Failed: versionName was not updated to 1.5.0"
  exit 1
fi
if ! grep -q 'versionCode 2' "$DUMMY_DIR/build.gradle"; then
  echo "❌ Test 1 Failed: versionCode was not updated to 2"
  exit 1
fi
echo "✅ Test 1 Passed"
cleanup

# -------------------------------------------------------------------------
# Test 2: Modern Groovy DSL
# -------------------------------------------------------------------------
echo "Testing Modern Groovy DSL..."
mkdir -p "$DUMMY_DIR"
cat << 'EOF' > "$DUMMY_DIR/build.gradle"
android {
    defaultConfig {
        applicationId "com.example.app"
        minSdk 24
        targetSdk 33
        versionCode = 1
        versionName = "1.0"
    }
}
EOF

bash "$UPDATE_SCRIPT" "tests/dummy_project" "v1.6.0" "dummy_token"

if ! grep -q 'versionName = "1.6.0"' "$DUMMY_DIR/build.gradle"; then
  echo "❌ Test 2 Failed: versionName was not updated to 1.6.0"
  exit 1
fi
if ! grep -q 'versionCode = 2' "$DUMMY_DIR/build.gradle"; then
  echo "❌ Test 2 Failed: versionCode was not updated to 2"
  exit 1
fi
echo "✅ Test 2 Passed"
cleanup

# -------------------------------------------------------------------------
# Test 3: Kotlin DSL
# -------------------------------------------------------------------------
echo "Testing Kotlin DSL..."
mkdir -p "$DUMMY_DIR"
cat << 'EOF' > "$DUMMY_DIR/build.gradle.kts"
android {
    defaultConfig {
        applicationId = "com.example.app"
        minSdk = 24
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }
}
EOF

bash "$UPDATE_SCRIPT" "tests/dummy_project" "v2.0.0" "dummy_token"

if ! grep -q 'versionName = "2.0.0"' "$DUMMY_DIR/build.gradle.kts"; then
  echo "❌ Test 3 Failed: versionName was not updated to 2.0.0"
  exit 1
fi
if ! grep -q 'versionCode = 2' "$DUMMY_DIR/build.gradle.kts"; then
  echo "❌ Test 3 Failed: versionCode was not updated to 2"
  exit 1
fi
echo "✅ Test 3 Passed"

echo "🎉 All tests passed successfully!"
