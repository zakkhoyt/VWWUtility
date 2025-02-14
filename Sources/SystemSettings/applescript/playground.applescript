--
--	Created by: MyName
--	Created on: 2024-09-30
--




use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions


use framework "Foundation"


set indent to "  "
set urlBase to "x-apple.systempreferences:"

tell application "System Settings"
	--	-- set currentPane to the current pane
	--	-- set currentPane to get pane whose id is "com.apple.Accessibility-Settings.extension"
	--	get pane where id is "com.apple.Accessibility-Settings.extension"
	set currentPane to pane id "com.apple.Accessibility-Settings.extension"
	--	set targetAnchor to anchor id "AX_feature.zoom"
	--set currentPane to reveal currentPane
	set currentAnchor anchor (in currentPane) id "AX_feature.zoom" 
	reveal currentPane
	reveal anchor "AX_feature.zoom"
	set currentPaneName to the name of currentPane
	set currentPaneID to the id of currentPane
	set currentPaneURL to urlBase & currentPaneID
	log currentPaneName & "
	  ------" & currentPaneID & "
	  " & currentPaneURL
end tell
