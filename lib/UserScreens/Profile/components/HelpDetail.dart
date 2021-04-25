import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:flutter/material.dart';

class HelpDetail extends StatefulWidget {
  HelpDetail({Key key}) : super(key: key);

  @override
  _HelpDetailState createState() => _HelpDetailState();
}

class _HelpDetailState extends State<HelpDetail> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Map data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(data['title']),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(data['subtitle']),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }
}