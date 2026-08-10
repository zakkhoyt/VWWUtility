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


# Release Build / Archive

```zsh
swift build \
  --arch x86_64 --arch arm64 \
  --configuration release \
  --product zbterms
  # --package-path ${PACKAGE_DIR}
```

# Use Cases

## Unique Terms
```zsh
zbterms report \
  --dir <path> \
  | jq '.unique_terms[] | (.term, .count)'
```


## Term Uses
```zsh
# present as a list of files
zbterms report \
  --dir <path> \ 
  | jq '.term_usages[].path_item.path'
```
