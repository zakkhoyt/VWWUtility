


Create a new branch from `main`. I want you to convert a python library over to two swift targets

The library is `ds_store`
$HOME/.platformio/penv/lib/python3.11/site-packages/ds_store

I think this is only a Python library so lets:
1. convert/refactor the whole library: `$HOME/.platformio/penv/lib/python3.11/site-packages/ds_store/*.py` (all 4 files) to swift as a new swift target within the current Swift package: `DSStoreTools`. Do not blindly convert each function over to swift, but refactor it so that the code is "Swifty". Take advantage of  enums,  enums with associated values,  structs, classes, actors, namespaces (nesting), async/await, etc... Be sure to convert the python doc-comments over to swift/doc-comments. If tests exist (check the repository, not just local dir) then port those over too. Additionally, add a docc catalog (use `/ios-create-docc` claude skill to create it at the very end). 

Be sure to write logs throughout. If they python code doesn't or is light, then do not follow. I want to see plenty of logs so that I can stream and really see what's happening. Use `import os` `static let logger = os.Logger(subsystem:category:)`


--- 

