#!/usr/bin/env -S osascript

# # #!/usr/bin/osascript

set indent to "  "
set urlBase to "x-apple.systempreferences:"

-- on mapListToOutline(prefix, listItems)
-- 	set outlineList to {}
-- 	repeat with i from 1 to count of listItems
-- 		set anchor to item i of listItems
-- 		set newAnchor to prefix & anchor & ""
-- 		set end of outlineList to newAnchor
-- 	end repeat
-- 	return outlineList
-- end mapListToOutline

on mapListToSwiftEnums(enumName, linePrefix, urlPrefix, listItems)
	set swiftCases to {}

	-- TODO: zakkhoyt - CamelCase for enumName. Maybe we can use bash / Terminal?
	set lineCaseBegin to linePrefix & "enum " & enumName & ": String {"
	set end of swiftCases to lineCaseBegin


	repeat with i from 1 to count of listItems
		set listItem to item i of listItems
		set line10 to linePrefix & "/// Shell command: `open \"" & urlPrefix & "&" & listItem & "\"; echo $?`" & "\n"
		set line20 to linePrefix & "case " & listItem & " = " & "\"" & urlPrefix & "&" & listItem & "\""
		set line30 to ""
		set swiftCase to line10 & line20 & line30
		-- set swiftCase to line10 & "\n" & line20 & "\n"
		set end of swiftCases to swiftCase
	end repeat
	set lineCaseEnd to linePrefix & "}\n"
	set end of swiftCases to lineCaseEnd
	return swiftCases
end mapListToSwiftEnums

on mapListToShellCommands(enumName, linePrefix, urlPrefix, listItems)
	set shellCommands to {}
	repeat with i from 1 to count of listItems
		set listItem to item i of listItems
		set line10 to linePrefix & "# " & listItem & " under " & enumName & " Settings Panel"
		set line20 to linePrefix & "open \"" & urlPrefix & "&" & listItem & "\""		
		set line30 to ""
		set shellCommand to line10 & "\n" & line20 & "\n" & line30
		set end of shellCommands to shellCommand
	end repeat
	return shellCommands
end mapListToShellCommands

tell application "System Settings"
-- tell application "Simulator"
	set AppleScript's text item delimiters to "
"

	set allPanesIDs to get the id of every pane
	log "allPanesIDs: \n" & (allPanesIDs as string)
	set allPanesNames to get the name of every pane
	log "allPanesNames: \n" & (allPanesNames as string)

	log " ---- Feching properties of every pane"
	set allPanesProperties to get the properties of every pane
	repeat with i from 1 to count of allPanesProperties
		-- log "[" & i & "]"
		
		set currentPane to item i of allPanesProperties
		set currentPaneName to the name of currentPane
		set currentPaneID to the id of currentPane
		log "/// * index: " & i & ""
		log "/// * name: " & "'" & currentPaneName & "'"
		log "/// * id: " & "'" & currentPaneID & "'"
		log "/// ```sh"
		log "/// open "\(rawValue)"; echo $?"
		log "/// ```"
			-- `open "x-apple.systempreferences:com.apple.Network-Settings.extension&6to4"; echo $?`
		set anchorNames to get the name of every anchor of pane id currentPaneID
		
		-- set swiftEnums to my mapListToSwiftEnums(currentPaneName, indent & indent, urlBase & currentPaneID, anchorNames)
		-- set linePrefix to indent & indent
		set linePrefix to ""
		set swiftEnums to my mapListToSwiftEnums(currentPaneName, linePrefix, urlBase & currentPaneID, anchorNames)
		-- log indent & "swift enums: \n" & swiftEnums
		-- log swiftEnums

		repeat with i from 1 to count of swiftEnums
			set swiftEnum to item i of swiftEnums
			log swiftEnum
			-- set line10 to linePrefix & "\n" & "/// Shell command: `open \"" & urlPrefix & "&" & swiftEnums & "\"; echo $?`"
			-- -- set line10 to "/// Shell command: `open \"" & urlPrefix & "&" & swiftEnums & "\"; echo $?`"
			-- set line20 to linePrefix & "case " & swiftEnums & " = " & "\"" & urlPrefix & "&" & swiftEnums & "\""
			-- set line30 to ""
			-- -- set swiftCase to line10 & "\n" & line20 & "\n" & line30
			-- set swiftCase to line10 & "\n" & line20 & "\n"
			-- -- set end of swiftCases to swiftCase
		end repeat
		
		-- set shellCommands to my mapListToShellCommands(currentPaneName, indent & indent, urlBase & currentPaneID, anchorNames)
		-- log indent & "shellCommands: \n" & shellCommands
	end repeat
end tell