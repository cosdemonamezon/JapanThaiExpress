import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';

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
              child:Text(
                  "นโยบายความเป็นส่วนตัว",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
                  SizedBox(height: 20),
                  Container( color:Colors.green,
                  child :
                  Text('_\tบริษัท ทรู ไอคอนสยาม จำกัด ("บริษัทฯ", "เรา" หรือ "ของเรา")เล็งเห็นถึงความสำคัญของการคุ้มครองสิทธิของท่านในข้อมูลใดๆ ที่เกี่ยวข้องกับบุคคลธรรมดาซึ่งถูกระบุหรือสามารถถูกระบุได้ ("ข้อมูลส่วนบุคคล") จากผลิตภัณฑ์และบริการของบริษัทฯ บริษัทฯ ทราบดีว่าท่านต้องการที่จะได้รับการคุ้มครองตามมาตรฐานที่ระบุโดยกฎหมายไทยที่เกี่ยวข้องกับการคุ้มครองข้อมูลส่วนบุคคลในส่วนของวิธีการที่บริษัทฯ เก็บรวบรวม ใช้ เปิดเผย และ/หรือ โอนข้อมูลของท่านไปยังต่างประเทศ ข้อมูลที่ท่านให้กับบริษัทฯ นั้นทำให้บริษัทฯ สามารถมอบผลิตภัณฑ์และให้บริการที่ตรงกับความต้องการเฉพาะสำหรับท่านอย่างเหมาะสม ทั้งจากบริษัทฯ และบริษัทในเครือและบริษัทย่อยที่อยู่ในกลุ่มบริษัทสยามพิวรรธน์ ("กลุ่มบริษัทสยามพิวรรธน์") บริษัทฯ มีมาตรการการคุ้มครองข้อมูลส่วนบุคคลซึ่งรวมถึงการคุ้มครองมิให้ข้อมูลส่วนบุคคลของท่านถูกใช้โดยมิได้รับความยินยอมจากท่านก่อน')
                    

                  
                  ),
            ],)
          
        ),
     
    );
    
  }
}