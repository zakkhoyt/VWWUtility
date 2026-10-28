


The longer vision is to enable `echo_pretty` to be able to present/render menus to the user. Something like this
```zsh
echo_pretty --picker \
-item "Here is item A" \
-item "Here is item B" \
-item "Here is item C" \
-item "Here is item D"


```
I'd like to add keyboardkeypress detection somwhere under `Sources/HatchTerminalTools/ANSI` 


[This article]( https://www.polpiella.dev/how-to-make-an-interactive-picker-for-a-swift-command-line-tool) has an example for monitoring the arrow keys in a command line app
* The library is here:  [GitHub: ANSITerminal](https://github.com/pakLebah/ANSITerminal)
* A demo app is here: [ansiDemo](https://github.com/pakLebah/ansiDemo)

`import Darwin.unistd`
