import 'package:JapanThaiExpress/UserScreens/Dashboard/DashbordScreen.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/Contact.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NotificationScreen.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  NavigationBar({Key key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(color: Color(0xffdd4b39),),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF343434),
                    //backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.home_filled),
                      onPressed: () {
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => DashbordScreen())
                        );
                      }
                    ),
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF343434),
                    //backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.notification_important),
                      onPressed: () {
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => NotificationScreen())
                        );
                    }),
                  ),
                  Text(
                    "Notification",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF343434),
                    //backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.contact_phone),
                      onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Contact())
                      );
                    }),
                  ),
                  Text(
                    "Contact Us",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF343434),
                    //backgroundImage: AssetImage(pathicon1),
                    radius: 24,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.account_circle),
                      onPressed: () {
                        MyNavigator.goToProfileScreen(context);
                    }),
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}