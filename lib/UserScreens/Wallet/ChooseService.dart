import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class ChooseService extends StatefulWidget {
  ChooseService({Key key}) : super(key: key);

  @override
  _ChooseServiceState createState() => _ChooseServiceState();
}

class _ChooseServiceState extends State<ChooseService> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("เลือกบริการ"),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 35),
              newsCard(                
                "assets/logo_gateway_line.png",
                "Rabbit LINE Pay",
                "ชำระเงินผ่านร้านค้า LINE Pay",
                "1",
              ),
              SizedBox(height: 10),
              newsCard(                
                "assets/stock.png",
                "เติมเงิน",
                "อัปโหลดสลิปเติมเงิน",
                "2",
              ),

              
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  Container newsCard(String img, String title, String subtitle, String id) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: GestureDetector(
        onTap: (){
          if (id == "1") {
            MyNavigator.goToLineRabbit(context);
          } else {
            MyNavigator.goToTopup(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  //color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(img),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,),
                      child: Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kTextButtonColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: subtitle.length <= 120 ? Text(
                        subtitle,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: kFontSecondTextColor),
                      )
                      :Text(
                        subtitle.substring(0, 120)+"...",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: kFontSecondTextColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}