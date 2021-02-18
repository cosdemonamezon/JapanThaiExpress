import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  Payment({Key key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Method"),
      ),
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottom),
        reverse: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0,12.0,12.0,0),
            child: Column(
              children: [
                Card(
                  child: Stack(
                    children: [
                      Image.asset("assets/images/card_bg.png",fit: BoxFit.fill,),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:16.0, horizontal: 8.0),
                              child: Text(
                                "5698 2365 8965 6543",
                                style: TextStyle(
                                  fontSize: 28.0,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            SizedBox(
                             height: 20.0,
                           ),
                           Row(
                             children: [
                               Column(
                                 children: [
                                   Text("Expiry", style: TextStyle(color: Colors.white, fontSize: 22.0)),
                                   SizedBox(
                                     height: 10.0,
                                   ),
                                   Text(
                                     "MM/YY",
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 18.0,
                                     ),
                                   )
                                 ],
                               ),
                               SizedBox(
                                 width: 50.0,
                               ),
                               Column(
                                 children: <Widget>[
                                   Text(
                                     "CVV",
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 22.0
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10.0,
                                   ),
                                   Text(
                                     "19/32",
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 18.0,
                                     ),
                                   )
                                 ],
                               )
                             ],
                           ),
                           SizedBox(
                             height: 8.0,
                           ),
                           Text(
                             "Card Holder",
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 28.0
                             ),
                             textAlign: TextAlign.end,

                           ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  elevation: 5.0,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  semanticContainer: true,
                  shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(12.0)
                 ),
                ),
                SizedBox(
                  height: 20.0,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: "Credit Card Number",
                          labelStyle: TextStyle(
                            fontSize: 18.0
                          )
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(),
                            ),
                            labelText: "Credit Card Expiry Date",
                            labelStyle: TextStyle(
                                fontSize: 18.0
                            )
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(),
                            ),
                            labelText: "Credit Card Code",
                            labelStyle: TextStyle(
                                fontSize: 18.0
                            )
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(),
                            ),
                            labelText: "Credit Card Hodler Name",
                            labelStyle: TextStyle(
                                fontSize: 18.0
                            )
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FlatButton(
                        color: Color(0xffdd4b39),
                        onPressed: (){},
                        shape: StadiumBorder(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 12.0),
                          child: Text(
                              "Pay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0
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
        ),
      ),
    );
  }
}