# About


# URL Mining (macOS)
Th `applescript` folder contains a shell script which mines URLs from the preference panes in `System Settings.app`. 

## Collecting URLs
* Open macOS Settings.app
* Navigate to the panel that you want to investigate
* Open a command line instance then execute the script:
  * ```sh
    Sources/BaseUtility/SystemSettings/applescript/settings_preference_panes.applescript

    # # If you receive an error, ensure that the script is executable then try again
    # chmod +x Sources/BaseUtility/SystemSettings/applescript/settings_preference_panes.applescript
    ```

* The Settings app should now display an alert popup that lists the base URL for the pane and a list of query param URLs for each sub pane.
  * <img src="images/alert_panel_urls.png" width="50%">
* The URLs also copies those URLs to your pasteboard in `Swift` enum syntax


## Validating those URLs

Not all of these URLs can be used to open a preference pane. So before integrating them into this Package the should first be vetted. 

You can test them out from command line with `open` command:
```sh
open "x-apple.systempreferences:com.apple.preference.universalaccess?Keyboard"
```

If you receive errors on stderr:
```sh
$ open x-apple.systempreferences:com.apple.Print-Scan-Settings.extension&fax; echo $?
[1] 30641
zsh: permission denied: fax
126
```

```sh
$ open x-apple.systempreferences:com.apple.Print-Scan-Settings.extension; echo $?
0
```


Integrate these URLs in to `Sources/BaseUtility/SystemSettings/macOS/SystemSettings+macOS.swift`



# Navigating to a System Setting from your app

