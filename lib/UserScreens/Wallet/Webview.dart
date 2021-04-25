import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class Webview extends StatefulWidget {
  Webview({Key key}) : super(key: key);

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('https://sandbox-web-pay.line.me/'),
      ),
      body: WebView(
        initialUrl: 'https://www.google.com/',
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
      ),
    );
  }
}