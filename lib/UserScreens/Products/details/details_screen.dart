import 'package:JapanThaiExpress/UserScreens/Products/details/components/body.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      // each product have color
      backgroundColor: product.color,
      appBar: buildAppBar(context),
      body: Body(product: product),
    );
    return scaffold;
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: product.color,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          "assets/icons/back.svg",
          color: Colors.white,
        ), 
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"), 
          onPressed: () {

          },
        ),
        IconButton(
          icon: SvgPicture.asset("assets/icons/cart.svg"), 
          onPressed: () {

          },
        ),
        SizedBox(width: kDefaultPaddin / 2),
      ],
    );
  }
}