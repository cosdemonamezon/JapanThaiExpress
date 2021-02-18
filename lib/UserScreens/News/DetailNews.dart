import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:flutter/material.dart';

class DetailNews extends StatefulWidget {
  DetailNews({Key key}) : super(key: key);

  @override
  _DetailNewsState createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  String news ="Cookstudio is a cross-platform Android and Ios app full of recipes. With this. template you can create your own recipe application with beautiful design! It is quick, easy and affordable. Cookstudio app has many clever built-in features This template provides you easy way to make your own app. It does not require programming skills. Code is easily configurable and customizable. There is just one config file to setting documented. Create your own app in less than 15 minutes without any special knowledge! It’s easier than you think. Cookstudio app stores recipes in a local SQLite database. You don’t need any server and users can run the app without internet connection. See the full list of features below. We have a lot of experience with developing Flutter apps. Our priority is to create top quality products with beautiful design, write a perfectly clean code and make apps easily configurable and customizable. We are following Design Guidelines and permanently watching new trends.We are always here to help you. Happy customer is the most important thing for us. We offer post-purchase support, free lifetime updates and step-by-step documentation.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail News"),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          Card(
            child: ListTile(
              title: Image.asset("assets/o5.jpg", fit: BoxFit.cover,),
              subtitle: Column(
                children: [
                  Text("A Material Design raised button. "),
                  Text(news),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }
}