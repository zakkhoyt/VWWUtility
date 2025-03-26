#!/usr/bin/osascript

set indent to "  "
set urlBase to "x-apple.systempreferences:"

tell application "System Settings"
	set currentPane to the current pane
	set currentPaneName to the name of currentPane
	set currentPaneID to the id of currentPane
	set currentPaneURL to urlBase & currentPaneID 
	log currentPaneName & "\n" & currentPaneID & "\n" & currentPaneURL
end tell