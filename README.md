# react-native-scrolling-screenshot

Take fullscreen screenshot of React Native views including offscreen parts.

It saved into your albums in IOS.

## Installation

```
% npm i https://github.com/0nlyoung7/react-native-scrolling-screenshot.git
```

Add the .m and .h files to library folder in Xcode

## Usage

```
var ScrollingScreenshot = require('react-native-scrolling-screenshot');

var ref = React.findNodeHandle(this.refs.webview);
ScrollingScreenshot.takeScreenshot(ref, (error, result) => {
  if (error) {
    console.log(error);
  } else {
    console.log(result)
  }
});

```

## TODO

* Android support