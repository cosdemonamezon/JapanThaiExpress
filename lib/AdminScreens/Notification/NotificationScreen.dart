import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notification"),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: [
            SizedBox(
              height: 15,
            ),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Notification someting from your customer",
                Icons.notification_important, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.notification_important, "Johney Jone"),
          ],
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }

  Card messageCard(String title, IconData icon, String subtitle) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xffdd4b39),
          size: 40.0,
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
