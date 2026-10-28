The goal of this issue is to update `echo_pretty` and `Sources/HatchTerminalTools/ANSI/*` (probably `Sources/HatchTerminalTools/ANSI/Ansi+Style.swift`) so that it supports several more "composed" styles\x1B[1m

For example (you won't see this in `echo_pretty --help` at this time) but it supports a few already:

```zsh
echo_pretty --url 'https://www.blah.com' --default
echo_pretty --code 'let x = Int(34)' --default
```


The `--url` and `--code` args are parsed in `Sources/EchoPretty/main.swift` and then mapped to compose simpler styles in `Sources/HatchTerminalTools/ANSI/Ansi+Style.swift`\x1B[1m


Here is a script taht expresses the new composed styles  I'd like added. 


```zsh

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

# echo_pretty "--variable - Variable names
#     syntax: " --bold "--variable" --default "
#     example: " --cyan "userName" --default

echo_pretty "--type - Type/class names
    syntax: " --bold "--type" --default "
    example: " --yellow --italic "String Int Array" --default

# echo_pretty "--json-key - JSON property names
#     syntax: " --bold "--json-key" --default "
#     example: " --blue "\"userId\"" --default

# echo_pretty "--json-string - JSON string values
#     syntax: " --bold "--json-string" --default "
#     example: " --green "\"John Doe\"" --default

echo_pretty "--depreciated - Deprecated code/features
    syntax: " --bold "--depreciated" --default "
    example: " --strikeout --8-bit 240 "oldFunction()" --default

# # ============================================================================
# # STATUS & MESSAGING COMPOUNDS
# # ============================================================================

# echo_pretty "--success - Success messages
#     syntax: " --bold "--success" --default "
#     example: " --green --bold "✓ Build succeeded" --default

# echo_pretty "--warning - Warning messages
#     syntax: " --bold "--warning" --default "
#     example: " --yellow --bold "⚠ Warning: Deprecated API" --default

# echo_pretty "--error - Error messages (already exists as --code)
#     syntax: " --bold "--error" --default "
#     example: " --red --bold "✗ Error: File not found" --default

# echo_pretty "--info - Informational messages
#     syntax: " --bold "--info" --default "
#     example: " --cyan --bold "ℹ Info: Processing 42 files" --default

# echo_pretty "--dbg - Debug output styling
#     syntax: " --bold "--dgb" --default "
#     example: " --8-bit 240 --faint "[DEBUG] Variable state: initialized" --default

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



# ============================================================================
# MARKDOWN SYNTAX COMPOUNDS
# ============================================================================

echo_pretty "--md-h1 - Markdown heading level 1
    syntax: " --bold "--md-h1" --default "
    example: " --bold --underline --white "# Main Title" --default

echo_pretty "--md-h2 - Markdown heading level 2
    syntax: " --bold "--md-h2" --default "
    example: " --bold --white "## Section Title" --default

echo_pretty "--md-h3 - Markdown heading level 3
    syntax: " --bold "--md-h3" --default "
    example: " --bold --cyan "### Subsection" --default

echo_pretty "--md-h4 - Markdown heading level 4
    syntax: " --bold "--md-h4" --default "
    example: " --cyan "#### Minor Heading" --default

echo_pretty "--md-bold - Markdown bold (**text**)
    syntax: " --bold "--md-bold" --default "
    example: " --bold "**bold text**" --default

echo_pretty "--md-italic - Markdown italic (*text*)
    syntax: " --bold "--md-italic" --default "
    example: " --italic "*italic text*" --default

echo_pretty "--md-bold-italic - Markdown bold+italic (***text***)
    syntax: " --bold "--md-bold-italic" --default "
    example: " --bold --italic "***bold italic text***" --default

echo_pretty "--md-code - Markdown inline code (\`code\`)
    syntax: " --bold "--md-code" --default "
    example: " --RED --faint "\`inline code\`" --default

echo_pretty "--md-code-block - Markdown code block (\`\`\`code\`\`\`)
    syntax: " --bold "--md-code-block" --default "
    example: " --8-bit 236 --GREEN "  function example() { }" --default

echo_pretty "--md-link - Markdown link [text](url)
    syntax: " --bold "--md-link" --default "
    example: " --cyan --underline "[Link Text](https://example.com)" --default

echo_pretty "--md-link-text - Markdown link text portion
    syntax: " --bold "--md-link-text" --default "
    example: " --cyan --bold "[Link Text]" --default

echo_pretty "--md-link-url - Markdown link URL portion
    syntax: " --bold "--md-link-url" --default "
    example: " --8-bit 244 --faint "(https://example.com)" --default

echo_pretty "--md-image - Markdown image syntax
    syntax: " --bold "--md-image" --default "
    example: " --magenta --underline "![Alt text](image.png)" --default

echo_pretty "--md-blockquote - Markdown blockquote (> text)
    syntax: " --bold "--md-blockquote" --default "
    example: " --8-bit 244 --italic "> Quoted text here" --default

echo_pretty "--md-list-bullet - Markdown bullet list item
    syntax: " --bold "--md-list-bullet" --default "
    example: " --white "- List item" --default

echo_pretty "--md-list-ordered - Markdown ordered list item
    syntax: " --bold "--md-list-ordered" --default "
    example: " --white "1. First item" --default

echo_pretty "--md-checkbox-unchecked - Markdown unchecked checkbox
    syntax: " --bold "--md-checkbox-unchecked" --default "
    example: " --8-bit 244 "- [ ] Todo item" --default

echo_pretty "--md-checkbox-checked - Markdown checked checkbox
    syntax: " --bold "--md-checkbox-checked" --default "
    example: " --green --bold "- [x] Completed item" --default

echo_pretty "--md-hr - Markdown horizontal rule
    syntax: " --bold "--md-hr" --default "
    example: " --8-bit 240 --faint "---" --default

echo_pretty "--md-table-header - Markdown table header
    syntax: " --bold "--md-table-header" --default "
    example: " --bold --underline --white "| Column 1 | Column 2 |" --default

echo_pretty "--md-table-row - Markdown table row
    syntax: " --bold "--md-table-row" --default "
    example: " --white "| Value 1  | Value 2  |" --default

echo_pretty "--md-table-divider - Markdown table divider
    syntax: " --bold "--md-table-divider" --default "
    example: " --8-bit 240 "|----------|----------|" --default

echo_pretty "--md-strikethrough - Markdown strikethrough (~~text~~)
    syntax: " --bold "--md-strikethrough" --default "
    example: " --strikeout --8-bit 240 "~~deleted text~~" --default

echo_pretty "--md-footnote - Markdown footnote reference
    syntax: " --bold "--md-footnote" --default "
    example: " --blue --faint "[^1]" --default

echo_pretty "--md-highlight - Markdown highlight (==text==)
    syntax: " --bold "--md-highlight" --default "
    example: " --black --YELLOW "==highlighted text==" --default

echo_pretty "--md-task - Markdown task/todo item
    syntax: " --bold "--md-task" --default "
    example: " --cyan "- [ ] Task to complete" --default

echo_pretty "--md-frontmatter - Markdown frontmatter (YAML)
    syntax: " --bold "--md-frontmatter" --default "
    example: " --8-bit 244 --faint "---
title: Document
---" --default

echo_pretty "--md-frontmatter - Markdown frontmatter (YAML)
    syntax: " --bold "--md-frontmatter" --default "
    example: " --8-bit 244 --faint "---
title: Document
---" --default

echo_pretty "--md-comment - Markdown HTML comment
    syntax: " --bold "--md-comment" --default "
    example: " --8-bit 240 --italic --faint "<!-- Comment here -->" --default
```

