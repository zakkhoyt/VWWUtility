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

on mapForPrint(prefix, panes)
	set newList to {}
	repeat with i from 1 to count of panes
		set anchor to item i of panes
		set newAnchor to prefix & anchor & ""
		set end of newList to newAnchor
	end repeat
	return newList
end mapForPrint

-- on indentItems(prefix, linePrefix, listItems)
-- 	set newList to {}
-- 	-- repeat with i from 1 to count of listItems
-- 	-- 	set anchor to item i of listItems
-- 	-- 	-- set newAnchor to prefix & anchor
-- 	-- 	set newAnchor to anchor
-- 	-- 	set end of newList to newAnchor
-- 	-- end repeat
-- 	return newList
-- end indentItems

tell application "System Settings"
	set AppleScript's text item delimiters to "
"
	set CurrentPane to the id of the current pane
	-- display dialog "CurrentPane: " & (CurrentPane as string) & return
	log "CurrentPane: \n\t" & (CurrentPane as string)

	set AllPanes to get the name of every pane
	-- log "AllPanes: " & (AllPanes as string)

	-- set CurrentAnchors to my mapAnchors(prefix, CurrentAnchors)
	set AllPanesList to my mapForPrint("\t", AllPanes)
	log "AllPanesList: \n" & (AllPanesList as string)


	-- display dialog "AllPanes: " & (AllPanes as string) & return
	-- set AllPanesString to mapForPrint("", AllPanes)
	-- log "AllPanes: " & (AllPanesString as String)
	-- log "AllPanes: " & (indentItems("", "\t", AllPanes) as string)


-- 	set CurrentAnchors to get the name of every anchor of pane id CurrentPane
-- 	display dialog "Current Pane ID: " & CurrentPane & return & return & "Pane ID has been copied to the clipboard." & return & return & "All Panes: " & return & (AllPanes as string)


-- 	set AllPanes to my mapPanes("", AllPanes)
-- 	set the clipboard to prefix & "
-- " & AllPanes
-- 	display dialog "Current Pane ID: " & CurrentPane & return & return & "Pane ID has been copied to the clipboard." & return & return & "All Panes: " & return & (AllPanes as string)

	
-- 	-- display dialog CurrentPane
-- 	-- log (CurrentPane)
-- 	-- do shell script "echo The value: " & CurrentPane
-- 	get the name of every anchor of pane id CurrentPane
-- 	set CurrentAnchors to get the name of every anchor of pane id CurrentPane
-- 	set prefix to "x-apple.systempreferences:" & CurrentPane
-- 	set CurrentAnchors to my mapAnchors(prefix, CurrentAnchors)
-- 	set the clipboard to prefix & "
-- " & CurrentAnchors
-- 	display dialog "Current Pane ID: " & CurrentPane & return & return & "Pane ID has been copied to the clipboard." & return & return & "Current Anchors: " & return & (CurrentAnchors as string)
end tell