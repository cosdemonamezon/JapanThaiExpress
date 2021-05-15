import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(home: QRViewExample()));

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  SharedPreferences prefs;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text("แสกนพัสดุ"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    // controller.scannedDataStream.listen((scanData) async {
    //   setState(() {
    //     result = scanData;
    //   });
      // prefs = await SharedPreferences.getInstance();
      // var tokenString = prefs.getString('token');
      // var token = convert.jsonDecode(tokenString);

      // var url = Uri.parse(pathAPI + 'api/scan_track');
      // var response = await http.post(url,
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Authorization': token['data']['token']
      //     },
      //     body: convert.jsonEncode({
      //       'track_jp': this.result.code
      //       //'token': token['token']
      //     }));
      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> mac = convert.jsonDecode(response.body);
      //   if (mac['code'] == 200) {
      //     var arg = {
      //       "code": mac['data']['code'].toString(),
      //       "url": mac['data']['url'].toString(),
      //       "name": mac['data']["name"].toString(),
      //       "description": mac['data']["description"].toString(),
      //       "image": mac['data']["image"].toString(),
      //       "qty": mac['data']["qty"].toString(),
      //       "rate": mac['data']["rate"].toString(),
      //       "price": mac['data']["price"].toString(),
      //       "fee": mac['data']["fee"].toString(),
      //       "order_jp": mac['data']["order_jp"].toString(),
      //       "track_jp": mac['data']["track_jp"].toString(),
      //       "cost_jp": mac['data']["cost_jp"].toString(),
      //       "japan_to_thai": mac['data']["japan_to_thai"].toString(),
      //       "track_th": mac['data']["track_th"].toString(),
      //       "cost_th": mac['data']["cost_th"].toString(),
      //       "weight": mac['data']["weight"].toString(),
      //       "total": mac['data']["total"].toString(),
      //       "overdue": mac['data']["overdue"].toString(),
      //       "ship_name": mac['data']["ship_name"].toString(),
      //       "ship_address": mac['data']["ship_address"].toString(),
      //       "ship_tel": mac['data']["ship_tel"].toString(),
      //       "type": mac['data']["type"].toString(),
      //       "step": mac['data']["step"].toString(),
      //       "status": mac['data']["status"].toString(),
      //       "note": mac['data']["note"].toString(),
      //       "created_at": mac['data']["created_at"].toString(),
      //       "updated_at": mac['data']["updated_at"].toString(),
      //       "deleted_at": mac['data']["deleted_at"].toString(),
      //       "service_name": mac['data']["service_name"].toString(),
      //     };
      //     Navigator.pushNamed(context, '/qrcodepreview', arguments: arg);
      //   }
      // } else if (response.statusCode == 404) {
      //   Flushbar(
      //       title: 'ไม่พบข้อมูล',
      //       message: 'ไม่พบหมายเลขพัสดุ',
      //       backgroundColor: Colors.redAccent,
      //       icon: Icon(
      //         Icons.error,
      //         size: 28.0,
      //         color: Colors.white,
      //       ),
      //       duration: Duration(seconds: 3),
      //       leftBarIndicatorColor: Colors.blue[300],
      //     )..show(context);
      //   // MyNavigator.goToMain(context);
      // } else if (response.statusCode == 500) {

      // }
    // });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
