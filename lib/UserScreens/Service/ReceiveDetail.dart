import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter/material.dart';

class ReceiveDetail extends StatefulWidget {
  ReceiveDetail({Key key}) : super(key: key);

  @override
  _ReceiveDetailState createState() => _ReceiveDetailState();
}

class _ReceiveDetailState extends State<ReceiveDetail> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "ดำเนินการสำเร็จ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kInputSearchColor),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "25 มี.ค. 64 18:16 น.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: kInputSearchColor),
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(
              height: 20,
              thickness: 5,
              // indent: 20,
              // endIndent: 20,
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Icon(Icons.person_pin_rounded, size: 80,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "นาย ธวัชชัย มุ้งภูเขียว",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kInputSearchColor),
                    ),
                    Text(
                      "ธนาคาร Osaka",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kInputSearchColor),
                    ),
                    Text(
                      "xxxx-x-x4567-x",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kInputSearchColor),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "เลขที่รายการ:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kInputSearchColor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "1234567890987654321",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: kInputSearchColor),
                  ),
                ),
              ],
            ),
            Divider(
              height: 20,
              thickness: 5,
              // indent: 20,
              // endIndent: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "จำนวน:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kInputSearchColor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "3000.00 บาท",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: kInputSearchColor),
                  ),
                ),
              ],
            ),
            Divider(
              height: 20,
              thickness: 5,
              // indent: 20,
              // endIndent: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "ค่าธรรมเนียม:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kInputSearchColor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "300 บาท",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: kInputSearchColor),
                  ),
                ),
              ],
            ),
            Divider(
              height: 20,
              thickness: 5,
              // indent: 20,
              // endIndent: 20,
            ),
          ],
        ),
      ),
    );
  }
}