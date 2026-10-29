#!/usr/bin/env zsh

# echo "Testing hyperlink formats in iTerm2:\n"

# # Format 1: ESC ] 8 ; ; URL ESC \ text ESC ] 8 ; ; ESC \
# echo "Format 1 (ESC-backslash):"
# echo "\x1B]8;;https://github.com\x1B\\GitHub\x1B]8;;\x1B\x1B[0m"
# echo ""

# # Format 2: ESC ] 8 ; ; URL BEL text ESC ] 8 ; ; BEL
# echo "Format 2 (BEL):"
# echo "\x1B]8;;https://stackoverflow.com\007Stack Overflow\x1B]8;;\007\x1B[0m"
# echo ""

# # Format 3: With parameters (id for caching)
# echo "Format 3 (with id parameter):"
# echo "\x1B]8;id=123;https://apple.com\x1B\\Apple\x1B]8;;\x1B\x1B[0m"
# echo ""

# # With color too
# echo "Format 4 (with color):"
# echo "\x1B[36m\x1B[4m\x1B]8;;https://example.com\x1B\\Colored Link\x1B]8;;\x1B\x1B[0m"
# echo ""

function demo_hyperlinks {
  echo "Testing hyperlink formats in iTerm2:\n"

  # Format 1: ESC ] 8 ; ; URL ESC \ text ESC ] 8 ; ; ESC \
  # * ESC: `\x1B]` 
  # * ]: `]` 
  # * 8: `8` 
  # * ;: `;`
  # * ;: `;`
  # * url: `https://....` 
  # * ESC: `\x1B]` 
  # * title: `Link Title`
  # * ESC: `\x1B]` 
  # * 8: `8` 
  # * ;: `;`
  # * ;: `;`
  # * ESC: `\x1B]` 
  # * \: `\\`

  supported_terminals=(
    'vscode'
    'iTerm.app'
    # 'Apple_Terminal'
  )
  if ! (( ${supported_terminals[(I)$TERM_PROGRAM]} )); then
    echo "The $TERM_PROGRAM terminal does not support hyperlinks."
    return
  fi



  echo "Format 1 (ESC-backslash):"
  echo "\x1B]8;;https://github.com\x1B\\GitHub\x1B]8;;\x1B\\"
  echo ""

  # Format 2: ESC ] 8 ; ; URL BEL text ESC ] 8 ; ; BEL
  echo "Format 2 (BEL):"
  echo "\x1B]8;;https://stackoverflow.com\007Stack Overflow\x1B]8;;\007"
  echo ""

  # Format 3: With parameters (id for caching)
  echo "Format 3 (with id parameter):"
  echo "\x1B]8;id=123;https://apple.com\x1B\\Apple\x1B]8;;\x1B\\"
  echo "\x1B]8;id=123;https://apple.com\x1B\\Apple 1\x1B]8;;\x1B\\"
  echo "\x1B]8;id=123;https://apple.com\x1B\\Apple 2\x1B]8;;\x1B\\"
  echo "\x1B]8;id=123;https://apple.com\x1B\\Apple 3\x1B]8;;\x1B\\"
  echo ""

  # With color too
  echo "Format 4 (with color):"
  echo "\x1B[36m\x1B[4m""\x1B]8;;https://example.com\x1B\\Colored Link\x1B]8;;\x1B\\""\x1B[0m"
  echo ""
}

demo_hyperlinks "$@"

function set_window_title {
  # supported_terminals=(
  #   'vscode'
  #   'iTerm.app'
  #   # 'Apple_Terminal'
  # )
  # if ! (( ${supported_terminals[(I)$TERM_PROGRAM]} )); then
  #   echo "The $TERM_PROGRAM terminal does not support hyperlinks."
  #   return
  # fi


  # Set window title using OSC (Operating System Command) sequences
  # ESC ]0;title BEL  (using BEL as terminator)
  # or
  # ESC ]0;title ST   (using ST as terminator)

  echo "Current window title test\n"

  # Method 1: Using BEL (0x07) as terminator - most compatible
  echo -n "\x1B]0;My Window Title - Method 1\x07"
  echo "Set title using BEL terminator"
  sleep 2

  # Method 2: Using ST (ESC backslash) as terminator
  echo -n "\x1B]0;My Window Title - Method 2\x1B\\"
  echo "Set title using ST terminator"
  sleep 2

  # Method 3: Set title with variable
  WINDOW_TITLE="Dynamic Title: $(date)"
  echo -n "\x1B]0;${WINDOW_TITLE}\x07"
  echo "Set title dynamically: $WINDOW_TITLE"
  sleep 2

  # Method 4: Function for easy reuse
  set_window_title() {
      local title="$1"
      echo -n "\x1B]0;${title}\x07"
  }

  set_window_title "Function-based Title"
  echo "Set title using function"
  sleep 2

  # Reset to default (usually shows the current directory or command)
  set_window_title "${PWD##*/}"
  echo "Reset title to current directory"
}
set_window_title "$@"



