# Radio Player Project

## Minimal, Material UI based, Online Radio Player

###### (Currently in MVP stage)

Unlike other online players, the radio stations directory will not be fetched via public APIs. Instead, it's fetched from explicit database which contains only hand picked radio stations.

#### Planned Tasks

- [x] Initial project structure
- [x] Integrate dependencies
- [x] Basic player UI (play/ pause button & seek bar)
- [x] Play/ Pause functionality with only one (hardcoded) static radio station
- [x] Add list of radio stations (handpicked best stations & hardcoded)
- [x] Switch between radio stations from the list
- [x] Create the DB for storing handpicked radio stations
- [x] Fetch stations from DB
- [x] Enable background play (prevent the os sending app to sleep when the screen is off )
- [x] Added an animated avatar in the background

>**Note**
>
> - Though this app is intended to support both Android and iOS platforms, Currently it's been tested with only android devices.
> - This repo is currently implemented with a private Firebase Realtime Database. You may need to add your own firebase database and add the appropriate firebase configurations to the app so it'll generate and add the correct google-services.json to your project.
