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


---


```zsh
swift run zbterms report 
  --dir $HOME/conductor/workspaces/VWWUtility/sarajevo/.gitignored/test \
  | jq '.unique_terms[] | (.term, .count)'
```



```zsh
swift build \
  --arch x86_64 --arch arm64 \
  --configuration release \
  --product zbterms
  # --package-path ${PACKAGE_DIR}
```



---


## Testing




```zsh
zbterms report 
  --dir $HOME/conductor/workspaces/VWWUtility/sarajevo/.gitignored/test \
  | jq '.unique_terms[] | (.term, .count)'
```








## 

```zsh
# present as a list of file
zbterms report | jq '.term_usages[].path_item.path'
```
