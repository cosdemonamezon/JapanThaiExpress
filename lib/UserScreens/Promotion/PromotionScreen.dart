import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class PromotionScreen extends StatefulWidget {
  PromotionScreen({Key key}) : super(key: key);

  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Promotion"),
        leading: IconButton(
          onPressed: (){
            MyNavigator.goBackUserHome(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,)
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        children: [
          SizedBox(height: 15,),
          buildCard(
                    "Square style can be done by changing small code in the Material Button And Icon Button In Flutter !",
                    "assets/o1.jpg",
                  ),
                  buildCard(
                    "A Material Design raised button. A raised button consists of a rectangular piece of material that hovers over the interface. Documentation. Input and selections",
                    "assets/o2.jpg",
                  ),
                  buildCard(
                    "Implementing an icon-only toggle button. The following example shows a toggle button with three buttons that have icons",
                    "assets/o3.jpg",
                  ),
                  buildCard(
                    "a free and open source (MIT license) Material Flutter Button that supports variety of buttons style demands. 08 June 2019",
                    "assets/o4.jpg",
                  ),
                  buildCard(
                    "Here we discuss all paramaters available of the Flutter's MaterialButton Class. ... In Material Design, button's elevation is around 2dp to 8dp",
                    "assets/o5.jpg",
                  ),
        ],
      ),
      bottomNavigationBar: NavigationBar(),
    );
    
  }
}

Card buildCard(String title, String image) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(image),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MaterialButton(
              onPressed: (){},
              color: Colors.green,
              child: Text(
                "Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

Card messageCard(String title, IconData icon, String subtitle) {
  return Card(
    child: ListTile(
      leading: Icon(icon, color: Colors.blue,size: 40.0,),
      title: Text(
        title ,style: TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: Text(subtitle),
    ),
  );
}
