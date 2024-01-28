# TODO

## Questions
* [X] ~~*One "host", multiple "clients". Peers show up in each instance's session.connectedPeers.*~~ [2023-12-04] 
* [X] ~~*Mac (MP) <--> iOS*~~ [2023-12-04]
* [ ] Mac (command line) <--> iOS


* struct vs class 

## Options
* Encrypted data
* Auto accept connections
* Payload JSON container
* Booting a peer

## DRY
* [ ] struct/class description (reflection or such)

## Changes, upgrades, improvements, etc...
* [ ] naming conventions
  * [ ] MPEngine.Browser.InvitationState -> MPEngine.Browser.RequestState
    * [ ] rename vars, descriptions, UI, etc..
  * [ ] MPEngine.Advertiser.Invitation -> MPEngine.Advertiser.Request
    * [ ] rename vars, descriptions, UI, etc..
  * [X] ~~*MPEngine.Browser.BrowserState -> MPEngine.Browser.State*~~ [2023-12-04]
  * [X] ~~*MPEngine.Advertiser.AdvertiserState -> MPEngine.Advertiser.State*~~ [2023-12-04]
* [ ] Add closures for:
  * [ ] MPEngine.Browser.State
  * [ ] MPEngine.Advertiser.State
* [X] ~~*instead of removing an invitation, set state (accepted, rejected, noResponse)*~~ [2023-12-04]
* [X] ~~*MPEngine pure data. Add @Observable viewModels*~~ [2023-12-04]
* [ ] Respond to connectedPeers
  * [X] ~~*update count*~~ [2023-12-04]
  * [ ] detect connection drop
  * [ ] boot user 
  * [ ] disconnect from session
* [ ] Design JSON container for sending messages
  * [ ] pre-game
    * [ ] max # of players
    * [ ] peer data (age, color, etc...)
  * [ ] game metadata
    * [ ] players
    * [ ] legal player (who's turn)
  * [ ] game data
* [ ] Once data flow is clear, adopt async/await/actor

## Features
* [ ] auto invite/accept mode
* [ ] Publish data to consumer (IE a game)


## Bugs
* '+GCKSession Something is terribly wrong; no clist for'
  * https://www.kodeco.com/books/modern-concurrency-in-swift/v2.0/chapters/10-actors-in-a-distributed-system