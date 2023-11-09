

# Vectors, dot products, projection
https://www.youtube.com/watch?v=DPfxjQ6sqrc

Pythag

Angles

## Dot Product
`DP = V1x * V2x + V1y * V2y`
* Vector vs UnitVector
  * UnitVectors can save a lot of computation

* "Projecting" a vector onto another vector
```swift
theta = icos(v1•v2)
```
```swift
// Projecting v1 onto x axis
cos(theta) = dp / 1 // 1 because UnitVector for x axis. 
theta = acos(dp)
```
