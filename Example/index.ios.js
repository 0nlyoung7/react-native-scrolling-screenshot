'use strict';

import React, {Component} from 'react';

import {
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
  WebView,
  AppRegistry,
  ReactNative
} from 'react-native';

import ActionButton from 'react-native-action-button';

import findNodeHandle from 'findNodeHandle';
import ScrollingScreenshot from 'react-native-scrolling-screenshot';

var HEADER = '#3b5998';
var BGWASH = 'rgba(255,255,255,0.8)';
var DISABLED_WASH = 'rgba(255,255,255,0.25)';

var TEXT_INPUT_REF = 'urlInput';
var WEBVIEW_REF = 'webview';
var DEFAULT_URL = 'http://stackoverflow.com/questions/7628048/ios-uiimagewritetosavedphotosalbum';

class Example extends Component {


  constructor(props) {
    super(props);

    this.state = {
      url:DEFAULT_URL,
      scalesPageToFit: true
    };

    this.takeSnapshot = this.takeSnapshot.bind(this);
  }

  takeSnapshot(){

    var ref = findNodeHandle(this.refs[WEBVIEW_REF]);
    ScrollingScreenshot.takeScreenshot(ref, (error, result) => {
      if (error) {
        console.log(error);
      } else {
        console.log(result)
      }
    });

  }

  render() {
    this.inputText = this.state.url;

    return (
      <View style={[styles.container]}>
        <WebView
          ref={WEBVIEW_REF}
          automaticallyAdjustContentInsets={false}
          style={styles.webView}
          source={{uri: this.state.url}}
          javaScriptEnabled={true}
          domStorageEnabled={true}
          decelerationRate="normal"
          startInLoadingState={true}
          scalesPageToFit={this.state.scalesPageToFit}
        />

        <ActionButton 
          buttonColor="rgba(231,76,60,1)" 
          onPress={ this.takeSnapshot }
          offsetY={60}
        />
      </View>
    );
  }
}

var styles = StyleSheet.create({
  container: {
    flex: 1,
    marginTop: 20,
    backgroundColor: HEADER,
  },
  webView: {
    backgroundColor: BGWASH,
    height: 350,
  },
  statusBar: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingLeft: 5,
    height: 22,
  },
  statusBarText: {
    color: 'white',
    fontSize: 13,
  },
  spinner: {
    width: 20,
    marginRight: 6,
  },
});

AppRegistry.registerComponent('Example', () => Example);
