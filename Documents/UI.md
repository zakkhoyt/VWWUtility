
Make a new package for UI elements

# Views


# Menus
## Mac Menus
* [Article](https://troz.net/post/2021/swiftui_mac_menus/)

Add this property to the main `WindowGroup` in the app's `scene`
```swift
.commands {
  CommandMenu("Config") {
      Button(action: {
          print("Menu Button selected")
      }, label: {
          Text("Menu Button")
      })
      Button(action: {}, label: {
          Image(systemName: "clock")
          Text("Date & Time")
      })
      .keyboardShortcut(KeyEquivalent("p"), modifiers: [.command, .shift])
  }
}
```

## Mac menu bar icon (and drop menu)
* [Article](https://sarunw.com/posts/swiftui-menu-bar-app/) 

Add this to the `scene` as a sibling to `WindowGroup`
```swift
MenuBarExtra(currentNumber, systemImage: "\(currentNumber).circle") {
    // 3
    Button("One") {
        currentNumber = "1"
    }
    Button("Two") {
        currentNumber = "2"
    }
    Button("Three") {
        currentNumber = "3"
    }
}

```