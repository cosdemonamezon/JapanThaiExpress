import 'package:JapanThaiExpress/Screens/Register/Numpad.dart';
import 'package:flutter/material.dart';

class SetPin extends StatefulWidget {
  SetPin({Key key}) : super(key: key);

  @override
  _SetPinState createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  int length = 6;
  onChange(String number){
    if(number.length == length){
      if (number == "123456") {
        print("number : "+ number);
      }  
      //print(number);
    }
    else {
      print(number);
    }    
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Pin"),
      ),
      body: Container(
        height: height,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * .10),
                Hero(
                  tag: "hero",
                  child: Container(
                    height: 150,
                    //width: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                      ),
                    ),
                  ),
                ),
                Numpad(length: length, onChange: onChange,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}