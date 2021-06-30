import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class QRCodePreview extends StatefulWidget {
  QRCodePreview({Key key}) : super(key: key);

  @override
  _QRCodePreviewState createState() => _QRCodePreviewState();
}

class _QRCodePreviewState extends State<QRCodePreview> {
  List<bool> checked = [true, true, false, false, true];
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("รายละเอียด"),
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
                    data['image'],
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
                    Text(
                      "รหัสสินค้า : ${data['code']}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   //initialValue: '0.29 / 1 Bath',
                    //   decoration: InputDecoration(
                    //     //labelText: 'Label text',
                    //     //errorText: 'Error message',
                    //     hintText: "code",
                    //     border: OutlineInputBorder(),
                    //     enabled: false,
                    //   ),
                    //   initialValue: data['code'],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "ชื่อผู้สั่ง : ${data['name']}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   //initialValue: '0.32 / 1 Bath',
                    //   decoration: InputDecoration(
                    //     //labelText: 'Label text',
                    //     //errorText: 'Error message',
                    //     hintText: "name",
                    //     border: OutlineInputBorder(),
                    //     enabled: false,
                    //   ),
                    //   initialValue: data['name'],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "จำนวน : ${data['qty']}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   //initialValue: '0.32 / 1 Bath',
                    //   decoration: InputDecoration(
                    //     //labelText: 'Label text',
                    //     //errorText:Q'Error message',
                    //     hintText: "Qty",
                    //     border: OutlineInputBorder(),
                    //     enabled: false,
                    //   ),
                    //   initialValue: data['qty'],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "อัตราแลกเปลี่ยน : ${data['rate']}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   //initialValue: '0.32 / 1 Bath',
                    //   decoration: InputDecoration(
                    //     //labelText: 'Label text',
                    //     //errorText:Q'Error message',
                    //     hintText: "Rate",
                    //     border: OutlineInputBorder(),
                    //     enabled: false,
                    //   ),
                    //   initialValue: data['rate'],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "ราคา : ${data['price']}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   //initialValue: '0.32 / 1 Bath',
                    //   decoration: InputDecoration(
                    //     //labelText: 'Label text',
                    //     //errorText:Q'Error message',
                    //     hintText: "Price",
                    //     border: OutlineInputBorder(),
                    //     enabled: false,
                    //   ),
                    //   initialValue: data['price'],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "ค่าบริการ : ${data['fee']}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   //initialValue: '0.32 / 1 Bath',
                    //   decoration: InputDecoration(
                    //     //labelText: 'Label text',
                    //     //errorText:Q'Error message',
                    //     hintText: "fee",
                    //     border: OutlineInputBorder(),
                    //     enabled: false,
                    //   ),
                    //   initialValue: data['fee'],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "เลขพัสดุญี่ปุ่น : ${data['track_jp']}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   //initialValue: '0.32 / 1 Bath',
                    //   decoration: InputDecoration(
                    //     //labelText: 'Label text',
                    //     //errorText:Q'Error message',
                    //     hintText: "Track JPNO.",
                    //     border: OutlineInputBorder(),
                    //     enabled: false,
                    //   ),
                    //   initialValue: data['track_jp'],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "ประเภทบริการ : ${data['type']}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    // TextFormField(
                    //   //initialValue: '0.32 / 1 Bath',
                    //   decoration: InputDecoration(
                    //     //labelText: 'Label text',
                    //     //errorText:Q'Error message',
                    //     hintText: "Type",
                    //     border: OutlineInputBorder(),
                    //     enabled: false,
                    //   ),
                    //   initialValue: data['type'],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ที่อยู่จัดส่ง",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Text(
                          'ชื่อผู้รับ : ${data['ship_name']}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'เบอร์ : ${data['ship_tel']}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'ที่อยู่ : ${data['ship_address']}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        )
                      ],
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   //initialValue: '0.32 / 1 Bath',
                    //   maxLines: 5,
                    //   decoration: InputDecoration(
                    //     //labelText: 'Label text',
                    //     //errorText: 'Error message',
                    //     hintText: "Address",
                    //     border: OutlineInputBorder(),
                    //     enabled: false,
                    //   ),
                    //   initialValue: "Ship Name : " +
                    //       data['ship_name'] +
                    //       "\nAddress : " +
                    //       data['ship_address'] +
                    //       "\nShip Tel : " +
                    //       data['ship_tel'],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "หมายเหตุ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      maxLines: 2,
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "detail",
                        border: OutlineInputBorder(),
                        enabled: false,
                      ),
                      initialValue: data['note'],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "ค่าขนส่ง ญ-ญ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "ค่าขนส่ง ญ-ญ : เยน",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "น้ำหนัก",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "น้ำหนัก : กิโลกรัม",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['weight'],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // for (var i = 0; i < 1; i += 1)
                    //   Row(
                    //     children: [
                    //       Checkbox(
                    //         activeColor: Color(0xffdd4b39),
                    //         checkColor: Colors.white,
                    //         onChanged: i == 4
                    //             ? null
                    //             : (bool value) {
                    //                 setState(() {
                    //                   checked[i] = value;
                    //                 });
                    //               },
                    //         tristate: i == 1,
                    //         value: checked[i],
                    //       ),
                    //       Text(
                    //         'ยืนยันรายการ',
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .subtitle1
                    //             .copyWith(
                    //                 color:
                    //                     i == 4 ? Colors.black38 : Colors.black),
                    //       ),
                    //     ],
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //   ),
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
                          "ยืนยัน",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                          _getDetail();
                        },
                        child: Text(
                          "พิมพ์สติกเกอร์",
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

  _getDetail() async {
    prefs = await SharedPreferences.getInstance();

    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/web/print_sticker/DE21060006');
    var response = await http.get(url, headers: {
      //'Content-Type': 'application/json',
      'Authorization': token['data']['token']
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = convert.jsonDecode(response.body);
      if (data['code'] == 200) {
        var arg = {
          'ship_name': data['data']['ship_name'],
          'ship_address': data['data']['ship_address'],
          'ship_tel': data['data']['ship_tel'],
        };
        MyNavigator.goToQRCodedetail(context, arg);
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
        setState(() {
          // isLoading = false;
        });
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
}
