import 'package:JapanThaiExpress/UserScreens/Products/details/components/add_to_cart.dart';
import 'package:JapanThaiExpress/UserScreens/Products/details/components/color_and_size.dart';
import 'package:JapanThaiExpress/UserScreens/Products/details/components/counter_with_fav_btn.dart';
import 'package:JapanThaiExpress/UserScreens/Products/details/components/description.dart';
import 'package:JapanThaiExpress/UserScreens/Products/details/components/product_title_with_image.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Body extends StatelessWidget {
  final Product product;

  const Body({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.39),
                  padding: EdgeInsets.only(
                    top: size.height * 0.13,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  //height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget> [
                      ColorAndSize(product: product),
                      SizedBox(height: kDefaultPaddin),
                      Description(product: product),
                      SizedBox(height: kDefaultPaddin),
                      CounterWithFavBtn(),                      
                      AddToCart(product: product),
                    ],
                  ),
                ),
                ProductTitleWithImage(product: product),
              ],
            ),
          ),
        ]
      ),
    );
  }
}












