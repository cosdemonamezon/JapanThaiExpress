import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({Key key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
     final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
       title: Text("นโยบายความเป็นส่วนตัว"),
        leading: IconButton(
            onPressed: () {
              MyNavigator.goToProfileScreen(context);
              
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
            )),
    ),
    body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [

              SizedBox(height: 20),
              Center(
              child:Text(
                  "นโยบายความเป็นส่วนตัว",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
                  SizedBox(height: 20),
                
            ],)
          
        ),
     
    );
    
  }
}