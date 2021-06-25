import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/constants.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({Key key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("นโยบายความเป็นส่วนตัว"),
        leading: IconButton(
            onPressed: () {
              MyNavigator.goToProfileScreen(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
            )),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  "นโยบายความเป็นส่วนตัว",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: primaryColor, // Set border color
                        width: 3.0), // Set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0)), // Set rounded corner radius
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(1, 3))
                    ] // Make rounded corner of border
                    ),
                child: Text(
                    '_\tบริษัท บริษัท เจที ขนส่ง จำกัด ("บริษัทฯ", "เรา" หรือ "ของเรา")เล็งเห็นถึงความสำคัญของการคุ้มครองสิทธิของท่านในข้อมูลใดๆ ที่เกี่ยวข้องกับบุคคลธรรมดาซึ่งถูกระบุหรือสามารถถูกระบุได้ ("ข้อมูลส่วนบุคคล") จากผลิตภัณฑ์และบริการของบริษัทฯ บริษัทฯ ทราบดีว่าท่านต้องการที่จะได้รับการคุ้มครองตามมาตรฐานที่ระบุโดยกฎหมายไทยที่เกี่ยวข้องกับการคุ้มครองข้อมูลส่วนบุคคลในส่วนของวิธีการที่บริษัทฯ เก็บรวบรวม ใช้ เปิดเผย และ/หรือ โอนข้อมูลของท่านไปยังต่างประเทศ ข้อมูลที่ท่านให้กับบริษัทฯ นั้นทำให้บริษัทฯ สามารถมอบผลิตภัณฑ์และให้บริการที่ตรงกับความต้องการเฉพาะสำหรับท่านอย่างเหมาะสม บริษัทฯ มีมาตรการการคุ้มครองข้อมูลส่วนบุคคลซึ่งรวมถึงการคุ้มครองมิให้ข้อมูลส่วนบุคคลของท่านถูกใช้โดยมิได้รับความยินยอมจากท่านก่อน'),
              ),
            ],
          )),
    );
  }
}
