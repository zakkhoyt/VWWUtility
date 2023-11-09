# Node 
## Protocol/API

### Input(s) 
1 or more inputs of any type (Int, Double, Color, PixelBuffer, etc...)
* Literal value (unchanging)
    * Initial value defined as part of the node itself
    * These can be defined in the Node itself (no source required)
* Variable value (changing)
    * A feed of values from some source
    * A source is required
    * Probably easiest to have some default value as part of the node vs optionals

### Properties
Nodes can have properties which describe:
* The node itself (`name: String`)
* How the data flows from input to output (`isEnabled: Bool`)  
 
* Defining the type for inputs and outputs (float/vector/color) (enum)
    * Suppose we have an "add" node that could accept scalars or vectors. 
        * We *COULD* make 2 different nodes types, or we could try to make 1 smarter type

 
### Output(s)
1 or more outputs of any (optional) type
* Outputs nil if node is not enabled
* [ ] Disabled node
    * [ ] Shoudl output.value should be optional?
    * [ ] or can we just use the node.isEnabled property when walking?
  

## Concrete/Implementation

### Work
A node is useless if it cannot process input data into output data. 
* Each concrete node should implement `processData()`

# TODO
* [ ] Variadic Generics
[Reference](https://www.hackingwithswift.com/swift/5.9/variadic-generics)
* [ ] Best protocol inheritance description for input/output
