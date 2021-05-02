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
    Map data = ModalRoute.of(context).settings.arguments;
    print(data);

    return Scaffold(
      appBar: AppBar(
        title: Text("รายการโอนเงิน"),
        leading: IconButton(
            onPressed: () {
              //MyNavigator.goToService(context);
              Navigator.pop(context);
              // Navigator.push(
              //   context, MaterialPageRoute(builder: (context) => Service()));
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
            )),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  data['status'] == "approved"
                      ? Text(
                          "ดำเนินการสำเร็จ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kInputSearchColor),
                        )
                      : Text(
                          "รอแอดมินดำเนินการ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kInputSearchColor),
                        ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${data['date']}",
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
                color: Colors.black38,
                // indent: 20,
                // endIndent: 20,
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Icon(
                    Icons.person_pin_rounded,
                    size: 80,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${data['name']}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: kInputSearchColor),
                      ),
                      Text(
                        "ธนาคาร: ${data['bank']}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: kInputSearchColor),
                      ),
                      Text(
                        "${data['account']}",
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
                      "${data['code']}",
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
                color: Colors.black38,
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
                      "${data['total']} บาท",
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
                color: Colors.black38,
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
                      "${data['fee']} บาท",
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
                color: Colors.black38,
                // indent: 20,
                // endIndent: 20,
              ),
              Center(
                child: data['status'] == "approved"
                    ? Text(
                        "รูปสลิป",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: kInputSearchColor),
                      )
                    : Text(
                        "รอดำเนินการ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: kInputSearchColor),
                      ),
              ),
              data['img'] !=
                      "https://japan.logo-design360.com/japanthaiexpress-api-master/public"
                  ? Container(
                      height: 500,
                      width: width,
                      //color: Colors.blue,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data['img']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : Container(
                      height: 500,
                      //width: width,
                      //color: Colors.blue,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/ddd123.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
