import 'dart:io' as Io;
import 'dart:convert';
import 'package:JapanThaiExpress/UserScreens/Messageuser/Messagesend.dart';
import 'package:JapanThaiExpress/UserScreens/Service/DetailStep.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/my_navigator.dart';
import '../../utils/my_navigator.dart';

class Messagesend extends StatefulWidget {
  Messagesend({Key key}) : super(key: key);

  @override
  _MessagesendState createState() => _MessagesendState();
}
class _MessagesendState extends State<Messagesend> {

   @override
   Widget build(BuildContext context) {
      final height = MediaQuery.of(context).size.height;
      final width = MediaQuery.of(context).size.width;
      return Scaffold(
    appBar: AppBar(
      title: const Text('Floating Action Button Label'),
    ),
    body: Center(
      child: const Text('Press the button with a label below!'),
    ),
    
      );
   }
}