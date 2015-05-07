Face Off Launch Instructions

These are just a few things to note about running our app.

First, the build target must be "AirHockeyProject" for the project to run. XCode seems to default to SQLite for some reason.

Face Off is an iPad app first, and so should be tested on one of the iPad simulators or on an iPad device. Note that the FPS of the game will be quite low on a simulator,
and effects like lighting will essentially bring the simulator to a stop. This is not an issue with the game-- it is a result of the fact that simulators
are very slow at emulating graphics. Testing the game on a device is highly recommended, but if you test in a simulator just note that severe FPS drops are caused by the 
simulator, and that this is not indicative of how the game performs. 

Other than that, the game should work well on iPhone as well, although that was not our primary goal.

The game is being built for iOS 8.3, which means the most recent version of XCode is required to run the project. 