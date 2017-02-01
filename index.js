'use strict';

var React = require('react-native');
var {
  NativeModules
} = React;

var NativeScrollingScreenshot = NativeModules.RNScrollingScreenshot;

var ScrollingScreenshot = {
  takeScreenshot: NativeScrollingScreenshot.takeScreenshot
};

module.exports = ScrollingScreenshot;