import 'package:JapanThaiExpress/UserScreens/Profile/components/AddBank.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Bank extends StatefulWidget {
  Bank({Key key}) : super(key: key);

  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  bool isLoading = true;
  List<dynamic> bank = [];
  String tokendata = "";
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _getBank();
  }

  _getBank() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      //isLoading = true;
      tokendata = token['data']['token'];
    });

    var url = pathAPI + 'api/bank';
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      }
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> bankdata = convert.jsonDecode(response.body);
      if (bankdata['code']== 200) {
        setState(() {
          isLoading = false;
          bank = bankdata['data'];
        });
      } else {
      }
    } else {
    }

  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("จัดการบัญชี"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isLoading == true ?
          Center(
            child: CircularProgressIndicator(),
          ) 
          :Container(
            height: height*0.6,
            //color: Colors.red,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: bank.length,
              itemBuilder: (BuildContext context, int index){
                return Column(                  
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: bankCard(
                        bank[index]['icon']==null?'https://picsum.photos/200/300' :bank[index]['icon'],
                        bank[index]['name'],
                        bank[index]['id'],
                      ),
                    ),
                    
                  ],
                );
              }
              
            ),
          ),
          Container(
            //color: Colors.amber,
            height: 50,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.only(bottom: 10.0, top: 10),
            child: FlatButton(
              color: Color.fromRGBO(161, 108, 164, 1.0),
              child: Text('เพิ่มบัญชีธนาคาร', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddBank()));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  Card bankCard(String img, String title, int id) {
    return Card(
      color: kBackgroundColor,
      child: ListTile(
        leading: Container(
          child: Image.network(
            img,
            height: 50,
            width: 50,
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: kFontPrimaryColor),
        ),
        // subtitle: Text(
        //   subtitle,
        //   style: TextStyle(
        //       fontWeight: FontWeight.w400,
        //       fontSize: 16,
        //       color: kFontPrimaryColor),
        // ),
        trailing: IconButton(
          icon: Icon(Icons.delete), 
          onPressed: (){}
        ),
      ),
    );
  }
}