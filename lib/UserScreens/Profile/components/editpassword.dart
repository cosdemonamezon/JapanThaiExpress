import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editpassword extends StatefulWidget {
  Editpassword({Key key}) : super(key: key);

  @override
  _EditpasswordState createState() => _EditpasswordState();
}

class _EditpasswordState extends State<Editpassword> {
  String password;
  String confirmpassword;
  bool isLoading = false;
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey1 = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;

  _createAddmem(Map<String, dynamic> values) async {
    print(values);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/create_add_mem');
    var response = await http.post(url,
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': token['data']['token']
        },
        body: ({
          'name': values['name'],
          'address': values['description'],
          'tel': values['tel'],
        }));
    if (response.statusCode == 201) {
      final Map<String, dynamic> creatdata = convert.jsonDecode(response.body);
      if (creatdata['code'] == 201) {
        setState(() {
          isLoading = false;
        });
        String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertAddmember(
            creatdata['message'],
            picSuccess,
            context,
          ),
        );
      } else {
        var feedback = convert.jsonDecode(response.body);
        Flushbar(
          title: '${feedback['message']}',
          message: 'รหัสข้อผิดพลาด : ${feedback['code']}',
          backgroundColor: Colors.redAccent,
          icon: Icon(
            Icons.error,
            size: 28.0,
            color: Colors.white,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      }
    } else {
      var feedback = convert.jsonDecode(response.body);
      Flushbar(
        title: '${feedback['message']}',
        message: 'รหัสข้อผิดพลาด : ${feedback['code']}',
        backgroundColor: Colors.redAccent,
        icon: Icon(
          Icons.error,
          size: 28.0,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขรหัสผ่าน"),
      ),
      body: Container(
        height: height,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                SizedBox(height: height * .01),
                FormBuilder(
                  key: _formKey,
                  initialValue: {
                    
                    'oldpassword': '',
                    'newpassword': '',
                    'confirmpassword': '',
                  },
              
              child:Container(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  
               

              SizedBox(height: 20),
              Text(
                "รหัสผ่านปัจจุบัน",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 10),
              FormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  obscuringCharacter: "•",
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'รหัสผ่านปัจจุบัน',
                      //border: InputBorder.none,
                      border: OutlineInputBorder(),
                      fillColor: Color(0xfff3f3f4),
                      filled: true),
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: 'กรุณากรอกรหัสผ่าน'),
                    FormBuilderValidators.minLength(context, 8,
                        errorText: 'กรุณากรอกรหัสอย่างน้อย 8 ตัว')
                  ])),
              SizedBox(height: 10),
              Text(
                "รหัสผ่านใหม่",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 10),
              FormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  obscuringCharacter: "•",
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'รหัสผ่านใหม่',
                      //border: InputBorder.none,
                      border: OutlineInputBorder(),
                      fillColor: Color(0xfff3f3f4),
                      filled: true),
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: 'กรุณากรอกรหัสผ่าน'),
                    FormBuilderValidators.minLength(context, 8,
                        errorText: 'กรุณากรอกรหัสอย่างน้อย 8 ตัว')
                  ])),
              SizedBox(height: 10),
              Text(
                "ยืนยันรหัสผ่าน",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 10),
              FormBuilderTextField(
                  name: 'confirmpassword',
                  obscureText: true,
                  obscuringCharacter: "•",
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'ยืนยันรหัสผ่าน',
                      //border: InputBorder.none,
                      border: OutlineInputBorder(),
                      fillColor: Color(0xfff3f3f4),
                      filled: true),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: 'กรุณากรอกรหัสผ่าน'),
                    (val) {
                      if (val != password) {
                        return 'รหัสผ่านไม่ตรงกัน';
                      } else {
                        return null;
                      }
                    }
                  ])),
                  SizedBox(height: 25),
              
              
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState.saveAndValidate()) {
                    String picSuccess = "assets/success.png";
                                showDialog(
                                  barrierDismissible: false,
                                   context: context,
                                  builder: (context) => alerteditpassword(
                                    'ดำเนินการสำเร็จ',
                                    picSuccess,
                                    context,
                                  ),
                                 );
                    setState(() {
                      isLoading = true;
                    });
                   // _formKey.currentState.save();
                    //_createAddmem(_formKey.currentState.value);
                  } else {}
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(2, 4),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xffdd4b39), Color(0xffdd4b39)]),
                  ),
                  child: isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          "ยืนยัน",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                ),
              ),
              SizedBox(height: 10),
               ]),
            ),
                
              ),],
        ),
      ),
    ),
      ),
    );


  }
}
