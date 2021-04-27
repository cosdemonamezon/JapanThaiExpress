import 'package:JapanThaiExpress/AdminScreens/Customer/CustomerScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Deposit/DepositDetailScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Deposit/DepositScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Depository/DepositoryScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Exchange/ExchangeScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Maintain/MaintainScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/Message/MessageScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/PreOders/PreoderScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/PurchaseOrders/PrechaseScreen.dart';
import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/AdminScreens/QRCodeScan/QRView.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../PreOders/PreoderScreen.dart';

class HomeServices extends StatefulWidget {
  HomeServices({Key key}) : super(key: key);

  @override
  _HomeServicesState createState() => _HomeServicesState();
}

class _HomeServicesState extends State<HomeServices> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("คำขอบริการ"),
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: Container(
        height: height,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(3.0),
                children: [
                  dashboardItem(
                      "รายการฝากซื้อ", Icons.list_alt_outlined, 1, context),
                  dashboardItem("รายการฝากส่ง", Icons.list_alt, 2, context),
                  dashboardItem("รายการฝากโอน", Icons.money, 3, context),
                  dashboardItem("รายการประมูล", Icons.transform, 4, context),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}

Card dashboardItem(String title, IconData icon, int page, context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    elevation: 5.0,
    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Color(0xFFfafafa),
          //color: Color(0xFF343434),
          //color: Color(0xFFd73925),
        ),
        color: Color(0xFFfafafa),
        //color: Color(0xFFd73925),
        borderRadius: BorderRadius.circular(15),
      ),
      child: new InkWell(
        onTap: () {
          if (page == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PreoderScreen()));
          } else if (page == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DepositoryScreen()));
          } else if (page == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ExchangeScreen()));
          } else if (page == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DepositScreen()));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            SizedBox(height: 20.0),
            Center(
              child: Icon(
                icon,
                size: 60.0,
                color: Color(0xFFd73925),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  title,
                  style:
                      new TextStyle(fontSize: 15.0, color: Color(0xFFd73925)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
