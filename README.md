# react-native-scrolling-screenshot

Take fullscreen screenshot of React Native views including offscreen parts.

It saved into your albums in IOS.

## Installation

```bash
$ npm i https://github.com/0nlyoung7/react-native-scrolling-screenshot.git
```

Add the .m and .h files to library folder in Xcode

Add key in your `Info.plist`

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Save screenshot in PhotoAlbum</string>
```

## Usage

```javascript
import findNodeHandle from 'findNodeHandle';
import ScrollingScreenshot from 'react-native-scrolling-screenshot';

var ref = findNodeHandle(this.refs.webview);
ScrollingScreenshot.takeScreenshot(ref, (error, result) => {
  if (error) {
    console.log(error);
  } else {
  	// And the result in your PhotoAlbum
    console.log(result)
  }
});

```

You can get fullsize screenshot in WebView also, for example [StackOverflow](http://stackoverflow.com/questions/7628048/ios-uiimagewritetosavedphotosalbum)

![optimized](https://pbs.twimg.com/media/Cyfhh7CUkAAZ1dX.jpg)

[Fullsize screenhot here](http://static.stalk.io/images/fullsize_screenshot.JPG)

## Example

```bash
$ cd Example
$ npm install
```

Then, Run in XCODE

## TODO

* Android Support [issue](https://github.com/facebook/react-native/issues/10385)