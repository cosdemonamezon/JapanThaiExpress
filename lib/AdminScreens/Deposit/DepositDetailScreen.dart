import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class DepositDetailScreen extends StatefulWidget {
  DepositDetailScreen({Key key}) : super(key: key);

  @override
  _DepositDetailScreenState createState() => _DepositDetailScreenState();
}

class _DepositDetailScreenState extends State<DepositDetailScreen> {
  List<bool> checked = [true, true, false, false, true];

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("รายละเอียดการเติมเงิน"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(),
                  child: Image.network(
                    data['slip'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ชื่อบัญชี"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.29 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "Account",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['account_name'],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("ยอดเงิน"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "ยอดเงิน",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['amount'],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("หมายเหตุ"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      maxLines: 5,
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "รายละเอียด",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    for (var i = 0; i < 1; i += 1)
                      Row(
                        
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
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
                      child: GestureDetector(
                        onTap: () {
                          MyNavigator.goToAdmin(context);
                        },
                        child: Text(
                          "ยืนยันรายการ",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}
