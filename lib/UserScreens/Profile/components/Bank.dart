import 'package:JapanThaiExpress/UserScreens/Profile/components/AddBank.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter/material.dart';

class Bank extends StatefulWidget {
  Bank({Key key}) : super(key: key);

  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("จัดการบัญชี"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: height*0.6,
            //color: Colors.red,
            child: ListView(
              children: [
                Column(                  
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: bankCard(
                        "assets/kbank.jpg",
                        "ธนาคารกสิกรไทย",
                        "3214560987"
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: bankCard(
                        "assets/kbank.jpg",
                        "ธนาคารกสิกรไทย",
                        "3214560987"
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: bankCard(
                        "assets/kbank.jpg",
                        "ธนาคารกสิกรไทย",
                        "3214560987"
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: bankCard(
                        "assets/kbank.jpg",
                        "ธนาคารกสิกรไทย",
                        "3214560987"
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: bankCard(
                        "assets/kbank.jpg",
                        "ธนาคารกสิกรไทย",
                        "3214560987"
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: bankCard(
                        "assets/kbank.jpg",
                        "ธนาคารกสิกรไทย",
                        "3214560987"
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: bankCard(
                        "assets/kbank.jpg",
                        "ธนาคารกสิกรไทย",
                        "3214560987"
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: bankCard(
                        "assets/kbank.jpg",
                        "ธนาคารกสิกรไทย",
                        "3214560987"
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.amber,
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

  Card bankCard(String img, String title, String subtitle) {
    return Card(
      color: kBackgroundColor,
      child: ListTile(
        leading: Container(
          child: Image.asset(
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
        subtitle: Text(
          subtitle,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: kFontPrimaryColor),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete), 
          onPressed: (){}
        ),
      ),
    );
  }
}