'use strict';

var React = require('react-native');
var {
  NativeModules
} = React;

var NativeScrollingScreenshot = NativeModules.ScrollingScreenshot;

var ScrollingScreenshot = {
  takeScreenshot: NativeScrollingScreenshot.takeScreenshot
};

module.exports = ScrollingScreenshot;