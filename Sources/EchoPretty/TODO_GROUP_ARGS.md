

```zsh
#!/usr/bin/env zsh

# ============================================================================
# DEVELOPER-FOCUSED COMPOUNDS
# ============================================================================

echo_pretty "--comment - Generic code comment styling
    syntax: " --bold "--comment" --default "
    example: " --faint --8-bit 128 --italic "# Generic comment text" --default

echo_pretty "--comment-zsh / --comment-bash - Shell script comments
    syntax: " --bold "--comment-zsh" --default "
    example: " --8-bit 244 --italic "# Shell comment text" --default

echo_pretty "--comment-swift / --comment-cpp - C-style comments
    syntax: " --bold "--comment-swift" --default "
    example: " --8-bit 100 --italic --faint "// Swift or C++ comment" --default

echo_pretty "--string - String literal styling
    syntax: " --bold "--string" --default "
    example: " --green --faint "\"Hello, World!\"" --default

echo_pretty "--keyword - Programming language keywords
    syntax: " --bold "--keyword" --default "
    example: " --magenta --bold "func class if return" --default

echo_pretty "--function - Function/method names
    syntax: " --bold "--function" --default "
    example: " --blue --bold "calculateTotal()" --default

echo_pretty "--variable - Variable names
    syntax: " --bold "--variable" --default "
    example: " --cyan "userName" --default

echo_pretty "--type - Type/class names
    syntax: " --bold "--type" --default "
    example: " --yellow --italic "String Int Array" --default

echo_pretty "--json-key - JSON property names
    syntax: " --bold "--json-key" --default "
    example: " --blue "\"userId\"" --default

echo_pretty "--json-string - JSON string values
    syntax: " --bold "--json-string" --default "
    example: " --green "\"John Doe\"" --default

echo_pretty "--depreciated - Deprecated code/features
    syntax: " --bold "--depreciated" --default "
    example: " --strikeout --8-bit 240 "oldFunction()" --default

# ============================================================================
# STATUS & MESSAGING COMPOUNDS
# ============================================================================

echo_pretty "--success - Success messages
    syntax: " --bold "--success" --default "
    example: " --green --bold "✓ Build succeeded" --default

echo_pretty "--warning - Warning messages
    syntax: " --bold "--warning" --default "
    example: " --yellow --bold "⚠ Warning: Deprecated API" --default

echo_pretty "--error - Error messages (already exists as --code)
    syntax: " --bold "--error" --default "
    example: " --red --bold "✗ Error: File not found" --default

echo_pretty "--info - Informational messages
    syntax: " --bold "--info" --default "
    example: " --cyan "ℹ Info: Processing 42 files" --default

echo_pretty "--debug - Debug output styling
    syntax: " --bold "--debug" --default "
    example: " --8-bit 240 --faint "[DEBUG] Variable state: initialized" --default

# ============================================================================
# INTERNET & COMMUNICATION COMPOUNDS
# ============================================================================

echo_pretty "--spoiler - Spoiler text (like Discord/Reddit)
    syntax: " --bold "--spoiler" --default "
    example: " --hide --BLACK "Hidden spoiler content" --default

echo_pretty "--quote - Block quote styling
    syntax: " --bold "--quote" --default "
    example: " --8-bit 244 --italic "> This is a quoted message" --default

echo_pretty "--highlight - Highlighted/marked text
    syntax: " --bold "--highlight" --default "
    example: " --black --YELLOW "Important highlighted text" --default

echo_pretty "--mention / --at-mention - @username mentions
    syntax: " --bold "--mention" --default "
    example: " --cyan --bold "@username" --default

echo_pretty "--hashtag - #hashtag styling
    syntax: " --bold "--hashtag" --default "
    example: " --blue --bold "#trending" --default

echo_pretty "--clickable - Generic clickable/interactive element
    syntax: " --bold "--clickable" --default "
    example: " --cyan --underline "Click here" --default

echo_pretty "--emoji-text - Text that accompanies emojis
    syntax: " --bold "--emoji-text" --default "
    example: " --bold --white "Exciting news!" --default

echo_pretty "--timestamp - Time/date stamps
    syntax: " --bold "--timestamp" --default "
    example: " --8-bit 244 --faint "[2025-11-01 14:32:15]" --default

echo_pretty "--username - Username/handle display
    syntax: " --bold "--username" --default "
    example: " --bold --white "JohnDoe42" --default

echo_pretty "--badge / --label - Badge or label text
    syntax: " --bold "--badge" --default "
    example: " --black --GREEN --bold " NEW " --default

echo_pretty "--muted - De-emphasized/muted text
    syntax: " --bold "--muted" --default "
    example: " --8-bit 240 --faint "Secondary information" --default

echo_pretty "--emphasis / --em - Emphasized text
    syntax: " --bold "--emphasis" --default "
    example: " --italic "emphasized text" --default

echo_pretty "--strong - Strong emphasis
    syntax: " --bold "--strong" --default "
    example: " --bold "strong text" --default

echo_pretty "--deleted / --strikethrough - Crossed out text
    syntax: " --bold "--deleted" --default "
    example: " --strikeout --8-bit 240 "deleted text" --default

echo_pretty "--inline-code - Inline code snippets
    syntax: " --bold "--inline-code" --default "
    example: " --RED --faint "\`code\`" --default

echo_pretty "--reaction - Reaction/status indicator
    syntax: " --bold "--reaction" --default "
    example: " --bold --magenta "+1 👍" --default

echo_pretty "--notification - Notification text
    syntax: " --bold "--notification" --default "
    example: " --red --bold --blink "🔔 New message!" --default

echo_pretty "--caption - Image/media captions
    syntax: " --bold "--caption" --default "
    example: " --8-bit 248 --italic --faint "Figure 1: System architecture" --default

# ============================================================================
# DOCUMENT STRUCTURE COMPOUNDS
# ============================================================================

echo_pretty "--heading / --title - Section headers
    syntax: " --bold "--heading" --default "
    example: " --bold --underline --white "Chapter 1: Introduction" --default

echo_pretty "--path - File/directory paths
    syntax: " --bold "--path" --default "
    example: " --cyan --underline "/usr/local/bin/echo_pretty" --default

echo_pretty "--number - Numeric values
    syntax: " --bold "--number" --default "
    example: " --magenta "42" --default
```