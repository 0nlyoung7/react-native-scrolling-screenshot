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
  ReactNative,
  UIManager,
  Image,
  findNodeHandle
} from 'react-native';

import ActionButton from 'react-native-action-button';

import ScrollingScreenshot from 'react-native-scrolling-screenshot';

var HEADER = '#3b5998';
var BGWASH = 'rgba(255,255,255,0.8)';
var DISABLED_WASH = 'rgba(255,255,255,0.25)';

var TEXT_INPUT_REF = 'urlInput';
var WEBVIEW_REF = 'webview';
var NORMALVIEW_REF = 'normalview';
var DEFAULT_URL = 'http://stackoverflow.com/questions/7628048/ios-uiimagewritetosavedphotosalbum';

class Example extends Component {


  constructor(props) {
    super(props);

    this.state = {
      url:DEFAULT_URL,
      scalesPageToFit: true,
      uri:""
    };

    this.takeSnapshot1 = this.takeSnapshot1.bind(this);
    this.takeSnapshot2 = this.takeSnapshot2.bind(this);
  }

  takeSnapshot1(){
    var ref = findNodeHandle(this.refs[NORMALVIEW_REF]);
    // TODO : findNodeHandle bug fix;
    ScrollingScreenshot.takeScreenshot(24, (error, result) => {
      if (error) {
        console.log(error);
      } else {
        console.log(result)
      }
    });
  }

  takeSnapshot2(){

    var ref = findNodeHandle(this.refs[WEBVIEW_REF]);
    ScrollingScreenshot.takeScreenshot(24, (error, result) => {
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
        <View style={styles.layoutContainer} ref={NORMALVIEW_REF}>
          <View style={styles.itemWrapper}>
            <Text >
              title
            </Text>
          </View>
          <View style={styles.itemWrapper}>
            <Text >
              folderNm
            </Text> 
          </View>
          <View style={styles.itemWrapper}>
            <Text >
              memo
            </Text>
          </View>
          <View style={styles.itemWrapper}>
            <Text >
              tag
            </Text>
          </View>
          <View style={styles.itemWrapper}>
            <Text >
              location
            </Text>
          </View>      
        </View>

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
          buttonColor="rgba(59,89,152,1)" 
          onPress={ this.takeSnapshot1 }
          icon={<Text>Normal</Text>}
          offsetX={100}
        />

        <ActionButton 
          buttonColor="rgba(231,76,60,1)" 
          onPress={ this.takeSnapshot2 }
          icon={<Text>Web</Text>}
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
  layoutContainer: {
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
  },
  itemWrapper: {
    height:40,
    borderWidth: 1,
    borderColor: 'black',
    backgroundColor: '#b5c8e6',
    alignSelf: 'stretch',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 10,
    marginTop:5,
    marginBottom:5,
    marginLeft: 10,
    marginRight: 10,
  },
  image: {
    flex: 1,
    height: 300,
    resizeMode: 'contain',
    backgroundColor: 'black',
  },
});

AppRegistry.registerComponent('Example', () => Example);
