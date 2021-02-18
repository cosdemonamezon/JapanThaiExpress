import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:flutter/material.dart';

class Buystuff extends StatefulWidget {
  Buystuff({Key key}) : super(key: key);

  @override
  _BuystuffState createState() => _BuystuffState();
}

class _BuystuffState extends State<Buystuff> {
  List<bool> checked = [false, true, false, false, true];
  String valueChoose;
  List dropdownValue = [
    "Food", "Transport","Personal","Shopping","Medical","Rent","Movie","Salary"
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("รับฝากซื้อสินค้า"),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * .03),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product URL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                       //border: InputBorder.none,
                        border: OutlineInputBorder(),
                        fillColor: Color(0xfff3f3f4),
                        filled: true
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                       //border: InputBorder.none,
                        border: OutlineInputBorder(),
                        fillColor: Color(0xfff3f3f4),
                        filled: true
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Qty", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                       //border: InputBorder.none,
                        border: OutlineInputBorder(),
                        fillColor: Color(0xfff3f3f4),
                        filled: true
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Add atachment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                       //border: InputBorder.none,
                        border: OutlineInputBorder(),
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        suffixIcon: Icon(
                          Icons.file_upload,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Shipping type", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: DropdownButton(
                        //hint: Text("Select Item"),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 40,
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        dropdownColor: Color(0xffdd4b39),
                        value: valueChoose,
                        onChanged: (newValue){
                          setState(() {
                            valueChoose = newValue;
                          });
                        },
                        items: dropdownValue.map((valueItem){
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(), 
                        
                      ),
                    ),
                    SizedBox(height: 15),
                    for (var i = 0; i < 1; i += 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
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
                          style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 4 ? Colors.black38 : Colors.black),
                        ),
                      ],                      
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: (){
                        // Navigator.push(
                        //   context, MaterialPageRoute(builder: (context) => SetPin())
                        // );
                      },
                      child: Container(
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
                            colors: [Color(0xffdd4b39), Color(0xffdd4b39)]
                          ),
                        ),
                        child: Text("Confirm", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }
}