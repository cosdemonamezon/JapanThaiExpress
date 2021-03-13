import 'package:JapanThaiExpress/utils/japanexpress.dart';
import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:JapanThaiExpress/widgets/walkthrough.dart';
import 'package:JapanThaiExpress/constants.dart';
import '../../constants.dart';
import '../../utils/japanexpress.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() {
    return IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: PageView(
              children: <Widget>[
                Walkthrough(
                  title: Japanexpress.wt1,
                  content: Japanexpress.wc1,
                  imageIcon: Icons.mobile_screen_share,
                ),
                Walkthrough(
                  title: Japanexpress.wt2,
                  content: Japanexpress.wc2,
                  imageIcon: Icons.search,
                ),
                Walkthrough(
                  title: Japanexpress.wt3,
                  content: Japanexpress.wc3,
                  imageIcon: Icons.shopping_cart,
                ),
                Walkthrough(
                  title: Japanexpress.wt4,
                  content: Japanexpress.wc4,
                  imageIcon: Icons.verified_user,
                ),
              ],
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(lastPage ? "" : Japanexpress.skip,
                      style: TextStyle(
                          color: kFontPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () =>
                      lastPage ? null : MyNavigator.goToLogin(context),
                ),
                FlatButton(
                  child: Text(lastPage ? Japanexpress.gotIt : Japanexpress.next,
                      style: TextStyle(
                          color: kFontPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () => lastPage
                      ? MyNavigator.goToLogin(context)
                      : controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
