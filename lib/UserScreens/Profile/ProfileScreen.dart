import 'package:JapanThaiExpress/UserScreens/Profile/components/body.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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