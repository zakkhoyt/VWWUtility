#  Metal

## Apple References
* [Metal Shading Lanuage spec](https://developer.apple.com/metal/Metal-Shading-Language-Specification.pdf)
* [SwiftUI shaders](https://developer.apple.com/documentation/swiftui/shader)
* [Capturing a metal workload in Xcode](https://developer.apple.com/documentation/xcode/capturing-a-metal-workload-in-xcode)
* [Debugging Shaders](https://developer.apple.com/documentation/xcode/debugging-the-shaders-within-a-draw-command-or-compute-dispatch/)


## Tutorials
* [HackingWithSwift SwiftUI Shaders](https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-metal-shaders-to-swiftui-views-using-layer-effects)



## Notes

### Can't use Metal Debugger on SwiftUI Shaders. 
After learning about how to debug Metal (shaders, geometry, GPU, etc...) I can do so on a full metal project (like Apple's Deferred Lighting demo project). However with SwiftUI Shaders (beta in Xcode 15), Metal Debugging doesn't work. 
STR: 
* Set up an new Xcode project with a single SwiftUI Shader (View and the Metal Shader). Ensure you can preview and see the shader function when running the app.
* Set up your Xcode project for Metal Debugging as outlined [here](https://developer.apple.com/documentation/xcode/capturing-a-metal-workload-in-xcode). 
* In Xcode, debug the app
* Tap on the Metal debugger button (the button's tool tip says "Capture GPU Workload")
* When the popup appears select:
    * Scope: frame
    * Count: 1
    * Profile after Replay: false
* Click on "Capture"

### Expect
* Debug Navigator to populate with information, execution to break allowing inspection of the GPU workload, shaders, geometry, etc...

### Actual
* Top Toolbar will say "Capuring GPU Workload" for 2 or 3 seconds (Debug Navigator remains empty)
* Top Toolbar will change to say "Capturing GPU Workload: No capture boundary detected." (Debug Navigator remains empty)
* This goes on and on until you click "Abort" in the popover
* Note, if you try again in the same session (click "Capture" a second time) then the Debug Navigator will rapidly populate / depopulate in a very buggy fashion. 
    
* Specs
    * Sonoma 14.0 Beta (23A5286g) C72N7FN0J3
    * Xcode Version 15.0 beta 3 (15A5195k)
        
