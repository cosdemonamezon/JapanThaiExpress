import 'package:JapanThaiExpress/UserScreens/Profile/components/body.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Myaccount extends StatefulWidget {
  Myaccount({Key key}) : super(key: key);

  @override
  _Myaccount createState() => _Myaccount();
}

class _Myaccount extends State<Myaccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        leading: IconButton(
          onPressed: (){
            MyNavigator.goBackUserHome(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,)
        ),
      ),
      body: Body(),
    );
  }
}


