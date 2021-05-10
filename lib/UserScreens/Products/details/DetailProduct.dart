import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DetailProduct extends StatefulWidget {
  DetailProduct({Key key}) : super(key: key);

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  String product_id;
  String qty = "1";
  String promotion_code;
  String price;
  String cost_th;
  String total;
  String shipping_option;
  String ship_name;
  String ship_address;
  String ship_tel;
  int numOfItems = 1;
  String qtyproduct;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    Map data = ModalRoute.of(context).settings.arguments;
    //print(data);
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.30),
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                      left: kDefaultPaddin,
                      right: kDefaultPaddin,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        //ColorAndSize(),
                        //SizedBox(height: kDefaultPaddin),
                        //Description(data: data),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddin),
                          child: Text(
                            data['description'],
                            style: TextStyle(height: 1.3),
                          ),
                        ),
                        SizedBox(height: 10),
                        //CounterWithFavBtn(),
                        Column(
                          children: [
                            Center(
                              child: Text(
                                "ราคา " + data['price'] + " บาท",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: Text(
                                "*คงเหลือ " + data['qty'] + " ชิ้น*",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(height:15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                //CartCounter(),
                                Row(
                                  children: <Widget>[
                                    buildOutlineButton(
                                      icon: Icons.remove,
                                      press: () {
                                        if (numOfItems > 1) {
                                          setState(() {
                                            numOfItems--;
                                            qty = numOfItems.toString();
                                          });
                                          //print(qty);
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPaddin / 2),
                                      child: Text(
                                        numOfItems.toString().padLeft(2, "0"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                    buildOutlineButton(
                                      icon: Icons.add,
                                      press: () {
                                        setState(() {
                                          numOfItems++;
                                          qty = numOfItems.toString();
                                        });
                                        //print(qty);
                                      },
                                    ),
                                  ],
                                ),

                               /* Container(
                                  padding: EdgeInsets.all(8),
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF6464),
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                      "assets/icons/heart.svg"),
                                ),*/
                              ],
                            ),
                          ],
                        ),
                        //AddToCart(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddin),
                          child: Row(
                            children: <Widget>[
                              /*Container(
                                margin: EdgeInsets.only(right: kDefaultPaddin),
                                height: 50,
                                width: 58,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: kPrimaryColor)),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/icons/add_to_cart.svg",
                                    color: kPrimaryColor,
                                  ),
                                  onPressed: () {},
                                ),
                              ),*/
                              Expanded(
                                child: SizedBox(
                                  height: 45,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    color: kPrimaryColor,
                                    onPressed: () {
                                      setState(() {
                                        qtyproduct =
                                            data['qty']; // จำนวนสินค้าคงเหลือ
                                        var qtypro = int.parse(qtyproduct);

                                        var orderqty = int.parse(qty);
                                        // print(qtypro);
                                        // print(orderqty);
                                        if (orderqty > qtypro) {
                                          final snackBar = SnackBar(
                                            elevation: 4,
                                            content: Container(
                                                height: 50,
                                                child: Text(
                                                    'จำนวนสินค้ามีไม่พอ !')),
                                            action: SnackBarAction(
                                              label: 'ตกลง',
                                              onPressed: () {
                                                // Some code to undo the change.
                                              },
                                            ),
                                          );

                                          // Find the ScaffoldMessenger in the widget tree
                                          // and use it to show a SnackBar.
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          var arg = {
                                            "id": data['id'],
                                            "price": data['price'],
                                            "name": data['name'],
                                            "img": data['img'],
                                            "qty": qty
                                          };
                                          MyNavigator.goToOrderProduct(
                                              context, arg);
                                        }
                                      });
                                    },
                                    child: Text(
                                      "ซื้อทันที".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPaddin), //รูป
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //SizedBox(width: kDefaultPaddin),
                            Expanded(
                              flex: 1,
                              child: Hero(
                                tag: data['id'],
                                child: Container(
                                  height: height * 0.30,
                                  width: 100,
                                  child: Image.network(
                                    data['img'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: data['name'].length <= 10
                              ? Text(data['name'])
                              : Text(data['name'].substring(0, 22) + "..."),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 38,
      height: 30,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //backgroundColor: product.color,
      elevation: 0,
      title: Text("สินค้า"),
      leading: IconButton(
        icon: Icon(
           Icons.arrow_back_ios_rounded,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      // actions: <Widget>[
      //   IconButton(
      //     icon: SvgPicture.asset("assets/icons/search.svg"),
      //     onPressed: () {

      //     },
      //   ),
      //   IconButton(
      //     icon: SvgPicture.asset("assets/icons/cart.svg"),
      //     onPressed: () {

      //     },
      //   ),
      //   SizedBox(width: kDefaultPaddin / 2),
      // ],
    );
  }
}