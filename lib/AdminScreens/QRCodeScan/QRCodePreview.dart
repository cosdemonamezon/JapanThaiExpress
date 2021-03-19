import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';

class QRCodePreview extends StatefulWidget {
  QRCodePreview({Key key}) : super(key: key);

  @override
  _QRCodePreviewState createState() => _QRCodePreviewState();
}

class _QRCodePreviewState extends State<QRCodePreview> {
  List<bool> checked = [true, true, false, false, true];

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Order Detail"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(),
                  child: Image.network(
                    data['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("code"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.29 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "code",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['code'],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("name"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "name",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['name'],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("QTY"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText:Q'Error message',
                        hintText: "Qty",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['qty'],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Rate"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText:Q'Error message',
                        hintText: "Rate",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['rate'],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Price"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText:Q'Error message',
                        hintText: "Price",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['price'],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Fee"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText:Q'Error message',
                        hintText: "fee",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['fee'],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Track JP No."),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText:Q'Error message',
                        hintText: "Track JPNO.",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['track_jp'],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Order Type"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText:Q'Error message',
                        hintText: "Type",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['type'],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Shiping To"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      maxLines: 5,
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "Address",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: "Ship Name :" +
                          data['ship_name'] +
                          "\n" +
                          "Address :" +
                          data['ship_address'] +
                          "Ship Tel :" +
                          data['ship_tel'],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Note"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      //initialValue: '0.32 / 1 Bath',
                      maxLines: 5,
                      decoration: InputDecoration(
                        //labelText: 'Label text',
                        //errorText: 'Error message',
                        hintText: "detail",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: data['note'],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    for (var i = 0; i < 1; i += 1)
                      Row(
                        children: [
                          Checkbox(
                            activeColor: Color(0xffdd4b39),
                            checkColor: Colors.white,
                            onChanged: i == 4
                                ? null
                                : (bool value) {
                                    setState(() {
                                      checked[i] = value;
                                    });
                                  },
                            tristate: i == 1,
                            value: checked[i],
                          ),
                          Text(
                            'Confirm Order',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                    color:
                                        i == 4 ? Colors.black38 : Colors.black),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(2, 4),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xffdd4b39), Color(0xffdd4b39)]),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          MyNavigator.goToAdmin(context);
                        },
                        child: Text(
                          "Confirm",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}
