# About



# Documentation

```zsh
# Generate and check for warnings (no Xcode required)
swift package \
  --disable-sandbox \
  generate-documentation \
  --target SwiftyShell

# Archive is written to:
# .build/plugins/Swift-DocC/outputs/SwiftyShell.doccarchive

# Preview in a browser (serves at localhost:8080)
swift package \
  --disable-sandbox \
  preview-documentation \
  --target SwiftyShell
```




# TODO
* Rename DrawingUI -> Math
  * Package.swift
  * Is there a way to rename packages?. [YES!](https://github.com/apple/swift-package-manager/blob/main/Documentation/ModuleAliasing.md)
  
  
  
* [X] CodableUtils from
   * [ ] Remove intersection with BaseUtility
   * [ ] set up tests
* [ ] RadixUtils from Module
* [ ] ColorUtils from DrawingUI?
* [ ] ShellUtils from TermTools
* [ ] SystemSettings form BaseUtility
* [ ] Swift6

