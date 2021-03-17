import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';

class ReceiveMoney extends StatefulWidget {
  ReceiveMoney({Key key}) : super(key: key);

  @override
  _ReceiveMoneyState createState() => _ReceiveMoneyState();
}

class _ReceiveMoneyState extends State<ReceiveMoney> {
  List<bool> checked = [false, true, false, false, true];
  bool isLoading = false;
  Map<String, dynamic> datasetting = {};
  String rate = "";
  String fee = "";
  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJsdW1lbi1qd3QiLCJzdWIiOjYsImlhdCI6MTYxNTcyNTk5NSwiZXhwIjoxNjE1ODEyMzk1fQ.-x9FnNRM-KmnA8pd2cWJhk_ebIwYFtCwwUX31MeJ3TI";
  //final _formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController _rate;
  TextEditingController _fee;
  

  @override
  void initState() {
    super.initState();
    _settingApp();
    
  }

  _settingApp() async{
    setState(() {
      isLoading = true;
    });

    var url = pathAPI + 'api/setting_app';
    var response = await http.get(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token
      }
    );
    if (response.statusCode == 200){
      final Map<String, dynamic> settingdata = convert.jsonDecode(response.body);
      print(settingdata);
      if (settingdata['code'] == 200) {
        setState(() {
          datasetting = settingdata['data'];
          // rate = datasetting['exchange_rate'].toString();
          // fee = datasetting['fee'].toString();
          _rate = TextEditingController(text: datasetting['exchange_rate'].toString());
          _fee = TextEditingController(text: datasetting['fee'].toString());
          rate = _rate.text;
          fee = _fee.text;
        });
        print(_rate);
        print(_fee);
      } else {
        print("error");
      }
    }
    else{
      print("error");
    }
  }

  _createExchange(Map<String, dynamic> values) async {
    print(values);
    print(rate);
    print(fee);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/create_exchange';
    var response = await http.post(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token
      },
      body: ({
        'amount': values['amount'],
        'account_no': values['account_no'],
        'account_name': values['account_name'],
        'bank': values['bank'],
        'description': values['description'],
        'rate': rate,
        'fee': fee,
        // 'rate': values['rate'],
        // 'fee': values['fee'],
      })
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> tranfer = convert.jsonDecode(response.body);
      print(tranfer);
      if (tranfer['code'] == 201) {
        String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertdialog(
            tranfer['message'],
            tranfer['data']['code'],
            tranfer['data']['updated_at'],
            picSuccess,
            context,
          ),
        );
      } else {
        print("error");
      }
    } 
    else if (response.statusCode == 400) {
      final Map<String, dynamic> tranfer = convert.jsonDecode(response.body);
      print(tranfer['message']);
    }
    else
    {

    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("รับโอนเงิน"),
        leading: IconButton(
                onPressed: (){
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Service()));
                },
                icon: Icon(Icons.arrow_back_ios_rounded,)
              ),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'account_name': '',
              'account_no': '',
              'bank': '',
              'amount': '',
              'description': '',
              'rate': rate,
              'fee': fee,
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * .03),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ธนาคาร", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'bank',
                        decoration: InputDecoration(
                         //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ชื่อบัญชี", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'account_name',
                        decoration: InputDecoration(
                         //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("เลขที่บัญชี", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        keyboardType: TextInputType.number,
                        name: 'account_no',
                        decoration: InputDecoration(
                         //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  //width: width-80,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("จำนวนเงิน", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        keyboardType: TextInputType.number,
                        name: 'amount',
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.monetization_on_outlined, size: 30,),
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                        ),
                      ),
                    ],
                  ),
                ),  
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("รายละเอียด", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'description',
                        maxLines: 4,
                        decoration: InputDecoration(
                         //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: width * 0.43,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("อัตตราแลกเปลี่ยน", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          SizedBox(height: 10),
                          FormBuilderTextField(
                            enabled: false,
                            name: 'rate',
                            controller: _rate,
                            //initialValue: datasetting['rate'].toString(),
                            decoration: InputDecoration(
                              enabled: false,
                              suffixIcon: Icon(Icons.monetization_on_outlined, size: 30,),
                              //border: InputBorder.none,
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              filled: true
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width * 0.43,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ค่าบริการ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          SizedBox(height: 10),
                          FormBuilderTextField(
                            enabled: false,
                            name: 'fee', 
                            controller: _fee,                          
                            decoration: InputDecoration(
                              enabled: false,
                              suffixIcon: Icon(Icons.monetization_on_outlined, size: 30,),
                              //border: InputBorder.none,
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              filled: true
                            ),
                          ),
                        ],
                      ),
                    ),  
                  ],
                ),  
                
                SizedBox(height: 15),
                // for (var i = 0; i < 1; i += 1)
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Checkbox(
                //       onChanged: i == 4
                //         ? null
                //         : (bool value) {
                //         setState(() {
                //           checked[i] = value;
                //         });
                //       },
                //       tristate: i == 1,
                //       value: checked[i],
                //     ),
                //     Text(
                //       'Confirm Order',
                //       style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 4 ? Colors.black38 : Colors.black),
                //     ),
                //   ],                      
                // ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [                   
                      
                      SizedBox(height: 15),                    
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: (){
                          // Navigator.push(
                          //   context, MaterialPageRoute(builder: (context) => SetPin())
                          // );
                          _formKey.currentState.save();
                          //print(_formKey.currentState.value);
                          _createExchange(_formKey.currentState.value);
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
                              colors: [Color(0xffdd4b39), Color(0xffdd4b39)]
                            ),
                          ),
                          child: Text("Confirm", style: TextStyle(fontSize: 20, color: Colors.white),),
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
      bottomNavigationBar: NavigationBar(),
    );
  }
}
