
# Ideas
* App/Extension where the app can be a midi piano. See [this app](https://apps.apple.com/us/app/easy-midi-turn-your-mac-keyboard-mouse-into-a-midi/id490276037?mt=12)
  * [Send and receive CoreMidi](https://stackoverflow.com/questions/27416435/send-and-receive-midi-with-swift-and-coremidi)
  * [Midi Loopback](https://developer.apple.com/forums/thread/683734)
  * [Getting started with CoreMidi](https://www.reddit.com/r/swift/comments/o4fj4d/how_to_get_started_with_coremidi/)
  * [Midi Listener in Swift](https://itnext.io/midi-listener-in-swift-b6e5fb277406)




# Reference
* [Logic user guide](https://help.apple.com/pdf/logicpromac/en_US/logic-pro-mac-user-guide.pdf)
* [Logic instrument guide](https://help.apple.com/pdf/logicpromac-instruments/en_US/logic-pro-mac-instruments-user-guide.pdf)
* [Logic effects](https://help.apple.com/pdf/logicpromac-effects/en_US/logic-pro-mac-effects-user-guide.pdf)


* [Xcode Template](https://developer.apple.com/documentation/avfaudio/audio_engine/audio_units/creating_an_audio_unit_extension/)
* [Working with Audio](https://developer.apple.com/audio/)
* [Debugging out of process audio units](https://developer.apple.com/documentation/audiounit/debugging_out-of-process_audio_units_on_apple_silicon?language=objc)
Create a new mac app -> AudioUnit extension. 
See the README file in the extension target for a good explaination to get started with. 


* [Audio Unit](https://developer.apple.com/documentation/audiounit/)
  * Developers implementing version 3 audio units should subclass the AUAudioUnit class.
* [WWDC Audio Units](https://developer.apple.com/videos/wwdc2015)



# MIDI
## Create a virtual instrument
See `void handleMIDI2VoiceMessage(const struct MIDIUniversalMessage& message) {`

```swift
// Create (or reuse existing) midi client
public func MIDIClientCreateWithBlock(_ name: CFString, _ outClient: UnsafeMutablePointer<MIDIClientRef>, _ notifyBlock: MIDINotifyBlock?) -> OSStatus
// Then create a source and add to client
public func MIDISourceCreateWithProtocol(_ client: MIDIClientRef, _ name: CFString, _ protocol: MIDIProtocolID, _ outSrc: UnsafeMutablePointer<MIDIEndpointRef>) -> OSStatus
// Create output port and add to client
public func MIDIOutputPortCreate(_ client: MIDIClientRef, _ portName: CFString, _ outPort: UnsafeMutablePointer<MIDIPortRef>) -> OSStatus
// Send events through port to
public func MIDISendEventList(_ port: MIDIPortRef, _ dest: MIDIEndpointRef, _ evtlist: UnsafePointer<MIDIEventList>) -> OSStatus
```
```swift
// Listener must connect to our source
if MIDIPortConnectSource(port, source, nil) != noErr {

```

[Build a Universal MIDI Packet](https://developer.apple.com/documentation/coremidi/midi_services/incorporating_midi_2_into_your_apps). 
* See `Incorporating MIDI 2 into your apps` in dev docs


