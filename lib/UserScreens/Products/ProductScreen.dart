import 'package:JapanThaiExpress/UserScreens/Products/components/body.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ProductScreen extends StatefulWidget {
  ProductScreen({Key key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: buildAppBar(),
        body: Body(),
        bottomNavigationBar: NavigationBar(),
      ),
    );
  }
  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: Color(0xFFd73925),
        elevation: 0,
        leading: 
          IconButton(icon: SvgPicture.asset("assets/icons/back.svg"), 
          onPressed: (){
            MyNavigator.goBackUserHome(context);
          },
        ),
        title: Text("Products"),
        actions: <Widget>[
          IconButton(icon: SvgPicture.asset(
            "assets/icons/search.svg",
            // icon default color is white
            color: kTextColor,
          ),
          onPressed: (){
            
          },
          ),
          IconButton(icon: SvgPicture.asset(
            "assets/icons/cart.svg",
            // icon default color is white
            color: kTextColor,
          ),
          onPressed: (){},
          ),
          SizedBox(width: kDefaultPaddin / 2)
        ],
      );
  }
}