#!/usr/bin/env bash
# Asks the OS to open a link, the way tapping it in another app would.
#
#   tool/open_link.sh android "navexample://open/product/42?color=blue"
#   tool/open_link.sh ios     "https://nav.example.com/user/nam"
#
# Custom-scheme links always reach the app. https links reach it only once the
# domain is verified (see tool/link_server/server.dart); until then the OS
# opens them in the browser.
set -euo pipefail

platform="${1:?usage: open_link.sh android|ios <link>}"
link="${2:?usage: open_link.sh android|ios <link>}"

case "$platform" in
  android)
    adb shell am start -W -a android.intent.action.VIEW \
      -c android.intent.category.BROWSABLE -d "\"$link\"" com.example.example ;;
  ios)
    xcrun simctl openurl booted "$link" ;;
  *)
    echo "unknown platform: $platform (expected android or ios)" >&2; exit 64 ;;
esac
