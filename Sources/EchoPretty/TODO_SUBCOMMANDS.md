
Shall we roll the planned `ansi_alert` aka `ansi_menu` aka `ansi_ui` into `echo_pretty`? Or should the remain completely separate? Merging means a lot more DRY, a lot less code, and an easier to use interface for the user. This really boils down to if it's feasible for `echo_pretty` to use `SwiftArgumentParser`?

# Roadblocks

## `SwiftArgumentParser`
Can `echo_pretty` support SwiftArgumentParser?
* [ ] This might or might not be possible because of the positional nature of the args. 
  * [ ] Can we do positional with --key=value? 
  * [ ] Can we do positional with --key=value1,value2,value3? 


## Keyboard Keypresses (arrow keys)
For menu navigation it would be very nice ot use the arrow keys to navigate vs /'press #1 or 'type "cancel"'. 

* [ ] arrow key presses
* [ ] escape key (for cancel)
* [ ] return/enter or space bar key (for confirm)

# Subcommands

* If we can convert to `SwiftArgumentParser`, then we can merge all together by using subcommands. 

```sh
# Normal echo_pretty syntax
echo_pretty "Here is my " --red "red" --default " text."

# Rename to ansi_ui, add subcommand "echo"
ansi_ui echo "Here is my " --red "red" --default " text."

# Make "echo" be the default command
ansi_ui "Here is my " --red "red" --default " text."

# Add another subcommand `menu` (or `alert` or `action-sheet`, etc...)
ansi_ui menu \
  --title "Visit this repository author's homepage?" \
  --item "Yes" \
  --item "No"
```

## The `menu` Subcommand
Build a shell utility (Based on `echo_pretty`) which is a CLI equivalent for `UIActivityViewController`

Names are hard: `menu`, `alert`, `action`, `aks`, `poll`, `inquiry`


### Simple Brainstorm

The UI will be made up of a collection of named `Item`s where each instance has
* text: String?
* icon: String? (unicode/emoji, not image)

# * title item
# * message item
# * list items
# * cancel item
# * default list item


```sh
ansi_menu \
  --menu-title "Visit the " --url "homepage" --default "?" \
  --menu-item "Yes" \
  --menu-item "No"
```

```sh
# Same as above, but adds icons
ansi_menu \
  --menu-title "Visit the " --url "homepage" --default "?" \
  --menu-message "They would love your traffic." \
  --menu-item-icon "🟢" --menu-item "Yes" \
  --menu-item-icon "🔴" --menu-item "No" \
  --menu-cancel-item-icon "⭕️" --menu-cancel-item "Cancel" \

```

# Global Variables

## UI defaults
```sh
ECHO_PRETTY_MENU_DEFAULT_TITLE_ICON="🤨" 
ECHO_PRETTY_MENU_DEFAULT_TITLE_TEXT="" 
ECHO_PRETTY_MENU_DEFAULT_MESSAGE_ICON="" 
ECHO_PRETTY_MENU_DEFAULT_MESSAGE_TEXT="" 

ECHO_PRETTY_MENU_DEFAULT_ITEM_ICON="🔴" 
ECHO_PRETTY_MENU_DEFAULT_ITEM_TEXT="Cancel" 

ECHO_PRETTY_MENU_DEFAULT_CANCEL_ITEM_ICON="🔴" 
ECHO_PRETTY_MENU_DEFAULT_CANCEL_ITEM_TEXT="Cancel" 

ECHO_PRETTY_MENU_DEFAULT_SELECTED_ITEM_ICON="●" 
ECHO_PRETTY_MENU_DEFAULT_DESELECTED_ITEM_ICON="◌" 

# TODO: zakkhoyt - How to define default selected item? Positional arg? Index? Equatable?
# TODO: zakkhoyt - (deps on above) Can default selected item have a default value?

ECHO_PRETTY_MENU_DEFAULT_SELECTED_ITEM_TEXT="" 
ECHO_PRETTY_MENU_DEFAULT_SELECTED_ITEM_INDEX="" 

```

## Keypresses

```sh
ECHO_PRETTY_MENU_NAVIGATION_KEYS="arrows" # arrows, type index
ECHO_PRETTY_MENU_ACCEPT_KEYS="return" # return, space
ECHO_PRETTY_MENU_CANCEL_KEYS="esc" # esc, c
```



# Update --help



* [ ] list ansi_ui modes (future)