#!/bin/bash

if [[ -z "$1" ]]; then
  _logp_se "Expected filepath to URL list argument for $1"
  return 1
fi


# urls=(
#   'x-apple.systempreferences:com.apple.Accessibility-Settings.extension'
#   'x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ALT_MOUSE_BUTTONS'
#   'x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ALT_MOUSE_ENABLE_SOUNDS'
#   'x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ALT_MOUSE_ENABLE_VISUALS'
#   'x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ANIMATED_IMAGES'
#   'x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_BACKGROUND_SOUNDS'
#   'x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_BACKGROUND_SOUNDS_LOCK_SCREEN'
# )


# shellcheck disable=SC2207
urls=($(cat "$1"))
echo_pretty "urls.count: ${#urls[@]}"




TAB='  '
for (( i=0; i<"${#urls[@]}"; i++)); do
  url="${urls[$i]}"

  URL_COMMAND="open $url"
  echo_pretty "urls[$i]: " --code "$URL_COMMAND" --default
  URL_OUTPUT="$(open "$url")"
  # URL_OUTPUT="$(eval "$URL_COMMAND")"
  # URL_OUTPUT="$($URL_COMMAND)"
  RVAL_URL_OUTPUT=$?
  if [[ $RVAL_URL_OUTPUT -ne 0 ]]; then
    echo_pretty --red "${TAB}[$RVAL_URL_OUTPUT] URL_OUTPUT: $URL_OUTPUT" --default
  else 
    echo_pretty --green "${TAB}[$RVAL_URL_OUTPUT] URL_OUTPUT: $URL_OUTPUT" --default


    CURRENT_PANE_OUTPUT="$(current_pane.applescript)"    
    echo "$CURRENT_PANE"
    # if [[ "$CURRENT_PANE" -ne 0 ]]; then
    # else 
    # fi

  fi
done



# getCurrentPane() {
#   CURRENT_PANE="$(current_pane.applescript)"
#   echo "$CURRENT_PANE"
# }



# set indent to "  "
# set urlBase to "x-apple.systempreferences:"
# tell application "System Settings"
# 		set currentPane to the current pane
# 		set currentPaneName to the name of currentPane
# 		set currentPaneID to the id of currentPane
    
#     log "currentPane"
# 		log indent & "name: " & currentPaneName
# 		log indent & "id: " & currentPaneID
# end tell

# }
