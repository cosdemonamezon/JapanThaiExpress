import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RabbitLine extends StatefulWidget {
  RabbitLine({Key key}) : super(key: key);

  @override
  _RabbitLineState createState() => _RabbitLineState();
}

class _RabbitLineState extends State<RabbitLine> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  String isSandbox = "true";
  String productName = "เติม Wallet";
  String currency = "THB";
  String quantity = "1";
  String imageUrl = "https://japan.logo-design360.com/japanthaiexpress-api-master/public/linepay.png";
  String linepay;
  SharedPreferences prefs;
  String iD;

  @override
  void initState() {
    super.initState();
    //_getID();
  }

  // _getID() async{
  //   prefs = await SharedPreferences.getInstance();
  //   var tokenString = prefs.getString('token');
  //   var token = convert.jsonDecode(tokenString);
  //   //print(token['data']['wallet']);
  //   setState(() {
  //     iD = token['data']['id'].toString();
  //   });
  // }

  _linePay(Map<String, dynamic> values) async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse('https://japan.logo-design360.com/japanthaiexpress-api-master/linepay/sample/request.php');

    var response = await http.post(
      url,
      // headers: {
      //   //'Content-Type': 'application/json',
      //   'Authorization': token['data']['token']
      // },
      body: ({
        'isSandbox': isSandbox,
        'user_id': token['data']['id'].toString(),
        'productName': productName,
        'amount': values['amount'],
        'currency': currency,
        'quantity': quantity,
        'imageUrl': imageUrl,
      })
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> linedata = convert.jsonDecode(response.body);
      if (linedata != null) {
        setState(() {
          linepay = linedata['paymentUrl'];
          var arg = {
            "paymentUrl": linepay,
              
          };
          //MyNavigator.goToWebview(context, arg);
          launch(linepay);
          MyNavigator.goBackUserHome(context);
        });
        
        //print(linepay);
      } else {
      }
      
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Rabbit Line"),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'amount': '',              
            },
            child: Column(
              children: [
                SizedBox(height: 35),
                Center(
                  child: Container(
                    height: 200,
                    width: width*0.7,
                    //color: Colors.blue[50],
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/logo_gateway_line.png"),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ใส่จำนวนเงิน", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'amount',
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context, errorText: 'กรุณากรอกจำนวนเงิน'),
                          // FormBuilderValidators.numeric(context),
                          // FormBuilderValidators.max(context, 70),
                        ]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            //isLoading = true;
                          });
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            //print(_formKey.currentState.value);
                            _linePay(_formKey.currentState.value);
                          } else {
                            print("555555");
                          }  
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
                                spreadRadius: 2
                              )
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xffdd4b39),
                                Color(0xffdd4b39)
                              ]
                            ),
                          ),
                          child: isLoading == true
                          ?Center(child: CircularProgressIndicator())
                          :Text(
                            "ยืนยัน",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}