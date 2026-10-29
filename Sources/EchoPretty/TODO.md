
  

# Update --help output
* [ ] list demo modes

* [ ] list cursor movement options
* [ ] list other `value=number` type options


# [ ] ANSI Decoration Sets
ANSI codes can be joined to create complex formatting. EX: `--cyan --underline --bold` pretty much describes an unvisited `URL`
* --url: `--cyan --underline`. Maybe `--bold`?
* --visited-url: a purple variant of ^
* --code: yellow or orange like in markdown code fences

# [ ] Support for `\n`, `\t`, etc...
Add support for escape characters (`\n`, `\t`, etc...) using string composition (like `echo`). 
* Should we have users specify `-n`?
  * `echo -n` is also how to mimic `printf` style (no trailing newline).

## Example

```sh
echo -n "\nTITLE\n"
echo_ansi "\nTITLE\n" # relays to `echo`
echo_pretty -n "\nTITLE\n"
```



# Subcommands
Shall we roll the planned `ansi_alert` aka `ansi_menu` aka `ansi_ui` into `echo_pretty`? Or should the remain completely separate? 

[Read the details, pros, cons, and potential in TODO_SUBCOMMANDS.md](TODO_SUBCOMMANDS.md)
