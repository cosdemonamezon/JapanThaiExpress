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
      decoration: BoxDecoration(color: Colors.blue,),
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
                      icon: Icon(Icons.chat),
                      onPressed: () {
                            
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
                      icon: Icon(Icons.chat),
                      onPressed: () {
                            
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
                      icon: Icon(Icons.chat),
                      onPressed: () {
                            
                    }),
                  ),
                  Text(
                    "Contct Us",
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
                      icon: Icon(Icons.chat),
                      onPressed: () {
                            
                    }),
                  ),
                  Text(
                    "Setting",
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