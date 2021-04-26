import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
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
        centerTitle: true,
        title: Text('หน้าชำระเงิน'),
      ),
      body: WebView(
        initialUrl: data['paymentUrl'],
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}