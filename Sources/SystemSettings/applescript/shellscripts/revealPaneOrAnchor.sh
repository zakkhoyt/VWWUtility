#!/bin/bash

if [[ -z "$1" ]]; then
  _logp_se "Expected filepath to URL list argument for $1"
  return 1
fi


SCRIPT="
tell application \"System Settings\"
    log \"revealing $1\"
    to reveal $1
end tell
"

echo "SCRIPT: $SCRIPT"


# osascript -e "$SCRIPT"