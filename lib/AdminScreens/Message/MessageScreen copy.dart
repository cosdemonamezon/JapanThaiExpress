import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Message"),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: [
            SizedBox(
              height: 15,
            ),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
            messageCard("Message someting from your customer",
                Icons.message_outlined, "Johney Jone"),
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
