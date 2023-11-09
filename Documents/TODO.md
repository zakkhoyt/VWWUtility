
# Packages

## Utils
* swiftlint (default vs custom)
* swiftformat (custom plugin)

## Priorities
* [X] ~~*Clean up app to prioritize macOS*~~ [2023-06-25]
* [X] ~~*Render audio buffers to swiftUI for mac app*~~ [2023-06-25]
* [X] ~~*Compute audio framerate*~~ [2023-06-25]
* [ ] Concurrency. Fewer Channels (add/remove at will)
    * Using 
    * [ ] Try with semaphore
    * [ ] Try with dispatch barrier
    * [ ] Try with Tasks/TaskGroups/Actors. 
        * Convert Channel/Effect to actors?
        * Convert Channel/Effect to structs/enums?
* [ ] Audio quality (choppy multithreading problems)
    * [ ] Deleting channels is def part of the blame for crashing (this is where `theta` is stored afterall)
        * [ ] Reusing channels causes clicking when rapidly pressing a key (ADSR interferance)
    * [ ] Need easy to consume API
    * [X] ~~*MemoryLayout refresher*~~ [2023-06-27]
        * [X] ~~*memcpy from Pointer<Double> to [Double]*~~ [2023-06-27]
* [ ] Video render quality
    * [ ] `.drawingGroup`: https://www.hackingwithswift.com/books/ios-swiftui/enabling-high-performance-metal-rendering-with-drawinggroup
    * [ ] SwiftUI canvas
    * [ ] TimelineView(.animation)
    * [X] ~~*Evaluate SwiftUI's answer to `CADisplayLink`*~~ [2023-06-27]
    * [X] ~~*Compute video framerate*~~ [2023-06-27]
* [X] ~~*Compute FFT (modern wrapper)*~~ [2023-06-27]
    * [X] ~~*SwiftUI rendering of FFT*~~ [2023-06-27]
* [ ] Better UI
  * [ ] FFT Stats (# of bands, loudest frequency, etc..)

### NSEvents & Midi
### Keypress Events in SwiftUI (macos 14)
* [Hacking with swift](https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-and-respond-to-key-press-events)



## Synthesizer
* [X] ~~*Xcode 17 / Swift 5.9*~~ [2023-06-18]
* [X] ~~*basic rendering on mac*~~ [2023-06-18]
* [X] ~~*basic rendering on iOS*~~ [2023-06-18]
* [X] ~~*Refactor AudioManager*~~ [2023-06-27]
    * [X] ~~*Fragment into smaller objects*~~ [2023-06-27]
    * [X] ~~*Async/Await/Actor*~~ [2023-06-27]
    * [X] ~~*Modern error handling*~~ [2023-06-27]
    * [X] ~~*protocols inheriting from AnyObject still necessary?*~~ [2023-06-27]
* [ ] Add a way to evaluate effects on a channel

## Keyboard Sequencer
* 


## SwiftUI
* [ ] Param Control
* [ ] Sliders
* [ ] Audio Node Types
  * [ ] mixer (splitter)
  * [ ] mixer (joiner)
  * [ ] freq mod
  * [ ] amplitude mod



## Nodes
* Basic functionality 
  * generic I/O, not just for SPM
    * Spike: Swift 5.9 variadic generics: https://www.hackingwithswift.com/swift/5.9/variadic-generics
  * tests
    * how to test
    * what data to test?
  * programmatic interface
  * UI interface (separate SPM target)
    * UI nodes vs audio render loop
    * In render loop we must do all frequency first, then all amplitude



## Logging
https://developer.apple.com/videos/play/wwdc2020/10168/


## Ideas
* Receive evnents from MIDI interface
    * Working app/driver/framework source code here: https://github.com/krevis/MIDIApps
* Wavetable rendering

## Logic
* FFT
    * Reuse existing buffer to get a higher FPS rendering
    * Falling max FFT values
* Reverse FFT
* HeatMap color spectrums (EX: red -> white )
* ADSR
  * ADHSR
  * Bezier envelopes
    


## Menus
* https://developer.apple.com/documentation/xcode/configuring-a-multiplatform-app-target


* WaveSynth
  * RenderLoop
    * populate & make a copy in the same loop (if there is a delegate)
  * Send copy out to delegate (BufferManager)
* WaveSyntchUI
  * BufferManager
    * append samples to store
      * if oDelegate, send dDelegate frame
      * if fftDelegate, process FFT, send fftDelegate
        * if heatmapDelegate, send heatmapDelegate
