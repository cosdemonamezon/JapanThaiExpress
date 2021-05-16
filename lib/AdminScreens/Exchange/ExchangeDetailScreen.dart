import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class ExchangeDetailScreen extends StatefulWidget {
  ExchangeDetailScreen({Key key}) : super(key: key);

  @override
  _ExchangeDetailScreenState createState() => _ExchangeDetailScreenState();
}

class _ExchangeDetailScreenState extends State<ExchangeDetailScreen> {
  List<bool> checked = [true, true, false, false, true];

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("รายละเอียดคำขอโอนเงิน"),
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
                  // child: Image.network(
                  //   data['slip'],
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Expanded(
                              child: RaisedButton(
                            onPressed: () {},
                            child: Text("ยืนยัน"),
                            color: Color(0xffdd4b39),
                            textColor: Colors.white,
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: RaisedButton(
                            onPressed: () {},
                            child: Text("ยกเลิก"),
                            color: Color(0xffdd4b39),
                            textColor: Colors.white,
                          )),
                        ],
                      ),
                    )
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
