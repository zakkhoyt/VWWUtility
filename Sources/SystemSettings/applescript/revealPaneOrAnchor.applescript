#!/usr/bin/osascript

tell application "System Settings"
    -- reveal pane with name "Keyboard"
    -- set targetPane to get pane with id = "com.apple.Accessibility-Settings.extension"
    set targetPane to get pane with name = "Keyboard"
    log "found targetPane with id: com.apple.Accessibility-Settings.extension " & targetPane.name
    -- reveal pane with id "com.apple.Accessibility-Settings.extension"
    
    -- set theResult to reveal pane or anchor
    set theResult to reveal 
    
    log "theResult: TODO"
end tell
