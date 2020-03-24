# distance

Simulate the positive effect of social distance on the spread of the corona epidemic.

This simulation uses the flame-engine and the embedded Box2d.

## Getting Started

Prepare for local run and build:
```
flutter channel master
flutter upgrade
flutter config --enable-web
```

Run in Chrome:
`flutter run -d Chrome`

Build for deployment:
`flutter build web`

Deploy to web server: copy contents of folder build/web:

The doc-folder contains the contents of such a build for web and is published as github pages.
You find it [here](https://schilken.github.io/distance).
Do a refresh of the page to start the simulation.

<img src="images_for_readme/distance-low-small.gif"/>


The three smiley images were exported from the Mac application of icons8.com