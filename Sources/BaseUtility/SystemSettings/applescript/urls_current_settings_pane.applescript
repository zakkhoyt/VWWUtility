#!/usr/bin/osascript

set indent to "  "
set urlBase to "x-apple.systempreferences:"


on mapListToOutline(prefix, listItems)
	set outlineList to {}
	repeat with i from 1 to count of listItems
		set anchor to item i of listItems
		set newAnchor to prefix & anchor & ""
		set end of outlineList to newAnchor
	end repeat
	return outlineList
end mapListToOutline

on mapListToSwiftCases(linePrefix, urlPrefix, listItems)
	set swiftCases to {}
	repeat with i from 1 to count of listItems
		set listItem to item i of listItems
		set newAnchor to linePrefix & "case " & listItem & " = " & "\"" & urlPrefix & "&" & listItem & "\""
		set end of swiftCases to newAnchor
	end repeat
	return swiftCases
end mapListToSwiftCases

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
	-- set CurrentPane to the id of the current pane
	-- display dialog "CurrentPane: " & (CurrentPane as string) & return
	-- log "CurrentPane: \n" & indent & (CurrentPane as string)

	-- set AllPanes to get the name of every pane
	set allPanesIDs to get the id of every pane
	log "allPanesIDs: \n" & (allPanesIDs as string)
	set allPanesNames to get the name of every pane
	log "allPanesNames: \n" & (allPanesNames as string)

	log " ---- Feching properties of every pane"
	set allPanesProperties to get the properties of every pane
	-- log "allPanesProperties: \n" & (allPanesProperties as string)
	-- log "AllPanes: " & (AllPanes as string)

	-- set AllPanesList to my printList(indent, allPanesIDs)
	-- log "AllPanesList: \n" & (AllPanesList as string)

	-- repeat with i from 1 to count of allPanesIDs
	-- 	set currentPaneID to item i of allPanesIDs
	repeat with i from 1 to count of allPanesProperties
		-- log "[" & i & "]"
		
		set currentPane to item i of allPanesProperties
		set currentPaneName to the name of currentPane
		set currentPaneID to the id of currentPane
		log "panes[" & i & "]"
		log indent & "name: " & name
		log indent & "id: " & id


		-- -- get the name of every anchor of pane id CurrentPane
		-- -- set currentPaneName to get the name of (get pane with id currentPaneID)
		-- set currentPaneName to get the pane with id currentPaneID
		-- -- log "PANES[" & i & "]: " & currentPaneID
		-- log "PANES[" & i & "]: " & currentPaneID & " '" & currentPaneName & "'"

        -- -- if the i is equal to 2 then
        if i is equal to 2 then
		-- 	set currentPaneID to the id of the current pane

		-- 	-- set prefix to "x-apple.systempreferences:" & CurrentPane
			-- set CurrentAnchors to get the name of every anchor of pane id CurrentPane
			set paneAnchors to get the name of every anchor of pane id currentPaneID
			-- set paneAnchors to my mapListToSwiftCases(indent & indent, paneAnchors)
			set prefix to indent & indent & urlBase & currentPaneID
			-- on mapListToSwiftCases(linePrefix, urlPrefix, listItems)
			set paneAnchors to my mapListToSwiftCases(indent & indent, urlBase & currentPaneID, paneAnchors)
			log indent & "paneAnchors: 
" & paneAnchors

			-- set paneAnchors to my mapAnchors(indent, paneAnchors)
			-- set paneAnchors to my mapAnchors(prefix, paneAnchors)

			-- log "paneAnchors: " & paneAnchors

        else
			-- skip
        end if

		-- set newAnchor to "case " & pane & " = " & "\"" & prefix & "&" & pane & "\""
		-- set currentPaneName to get the name of currentPane -- every anchor of pane id CurrentPane
		-- log "currentPane: " & currentPane

		-- set end of newList to newAnchor
	end repeat


	-- display dialog "AllPanes: " & (AllPanes as string) & return
	-- set AllPanesString to printList("", AllPanes)
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