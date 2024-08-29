#!/usr/bin/osascript
on mapAnchors(prefix, anchors)
	set newList to {}
	repeat with i from 1 to count of anchors
		set anchor to item i of anchors
		set newAnchor to "case " & anchor & " = " & "\"" & prefix & "&" & anchor & "\""
		set end of newList to newAnchor
	end repeat
	return newList
end mapAnchors

tell application "System Settings"
	set AppleScript's text item delimiters to ", "
	set CurrentPane to the id of the current pane
	display dialog CurrentPane
	-- log (CurrentPane)
	-- do shell script "echo The value: " & CurrentPane
	get the name of every anchor of pane id CurrentPane
	set CurrentAnchors to get the name of every anchor of pane id CurrentPane
	set prefix to "x-apple.systempreferences:" & CurrentPane
	set CurrentAnchors to my mapAnchors(prefix, CurrentAnchors)
	set the clipboard to prefix & "
" & CurrentAnchors
	display dialog "Current Pane ID: " & CurrentPane & return & return & "Pane ID has been copied to the clipboard." & return & return & "Current Anchors: " & return & (CurrentAnchors as string)
end tell