# FFT

Read about FFT in Apple's Accelerate framework: https://developer.apple.com/documentation/accelerate/data_packing_for_fourier_transforms

```swift
/// Fill the buffer with zeros.
vDSP.fill(&buffer, with: 0)
```

[Vector based arithmetic](https://developer.apple.com/documentation/accelerate/using_vdsp_for_vector-based_arithmetic)

```swift
let a: [Float] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let b: [Float] = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
let c: Float = 2
let d = vDSP.multiply(addition: (a, b), c)
```

Resampling with [decimation](https://developer.apple.com/documentation/accelerate/resampling_a_signal_with_decimation)
```swift
let outputSignal = vDSP.downsample(inputSignal,
                                   decimationFactor: decimationFactor,
                                   filter: filter)
```
[Perform FFT (modern)](https://developer.apple.com/documentation/accelerate/finding_the_component_frequencies_in_a_composite_sine_wave#3074131)


[Inverse FFT](https://developer.apple.com/documentation/accelerate/finding_the_component_frequencies_in_a_composite_sine_wave#3403296)

