import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

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
  final _formKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  bool isLoading = false;
  Io.File _image;
  final picker = ImagePicker();
  String img64;

  @override
  void initState() {
    super.initState();
    
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = Io.File(pickedFile.path);
        final bytes = Io.File(pickedFile.path).readAsBytesSync();
        // String base64Encode(List<int> bytes) => base64.encode(bytes);
        img64 = base64Encode(bytes);
        print(img64);
      } else {
        print('No image selected.');
      }
    });
  }

  _preorderMem(Map<String, dynamic> values) async{
    print(values);
    print(img64);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/depository_type';
    var response = await http.post(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
      body: ({
        'url': values['url'],
        'name': values['name'],
        'description': values['description'],
        'qty': values['qty'],
        'note': values['note'],
        'image': "data:image/png;base64,",
      })
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> datapreorder = convert.jsonDecode(response.body);
      if (datapreorder['code'] == 201){
        print(datapreorder['message']);
        //MyNavigator.goToService(context);
        String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertPreorder(
            datapreorder['message'],            
            picSuccess,
            context,
          ),
        );
      }
      else {
String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertPreorder(
            "",            
            picSuccess,
            context,
          ),
        );
      }
    } else {
      String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertPreorder(
            "",            
            picSuccess,
            context,
          ),
        );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("รับฝากซื้อสินค้า"),
          leading: IconButton(
            onPressed: (){
              MyNavigator.goToService(context);
              // Navigator.push(
              //   context, MaterialPageRoute(builder: (context) => Service()));
            },
            icon: Icon(Icons.arrow_back_ios_rounded,)
          ),
          bottom: TabBar(
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)),
              color: Colors.white),
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("รายการ"),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("ฝากซื้อสินค้า"),
                ),
              ),
            ])
          ),
        body: TabBarView(
          children: [
            Column(
              children: [
                buildCard(
                  "Hi everyone in this flutter article I am working with flutter button UI Design. Flutter button with image",
                  "assets/o8.jpg",
                ),
                buildCard(
                  "Buttons are the Flutter widgets, which is a part of the material design library. Flutter provides several types of buttons that have different shapes",
                  "assets/o7.jpg",
                ),
              ],
            ),
            //tab 2
            Container(
              height: height,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                    initialValue: {
                      'url': '',
                      'name': '',
                      'description': '',
                      'qty': '',
                      'note': '',
                    },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height * .04),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Product URL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'url',
                              decoration: InputDecoration(
                              //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true
                              ),
                              // validator: FormBuilderValidators.compose([
                              //   FormBuilderValidators.required(context),
                              //   // FormBuilderValidators.numeric(context),
                              //   // FormBuilderValidators.max(context, 70),
                              // ]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'name',
                              decoration: InputDecoration(
                              //border: InputBorder.none,
                                border: OutlineInputBorder(),
                                fillColor: Color(0xfff3f3f4),
                                filled: true
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                // FormBuilderValidators.numeric(context),
                                // FormBuilderValidators.max(context, 70),
                              ]),
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
                            FormBuilderTextField(
                              name: 'description',
                              maxLines: 3,
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
                            FormBuilderTextField(
                              name: 'qty',
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
                            Text("Note", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                            SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'note',
                              maxLines: 3,
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

                      SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: Container(
                              height: 120,
                              width: 120,
                              //color: Colors.red,
                              child: _image == null
                                  ? Image.asset("assets/images/nopic.png")
                                  : Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _formKey.currentState.save();
                                  print(_formKey.currentState.value);
                                  _preorderMem(
                                      _formKey.currentState.value);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
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
                                        colors: [
                                          Color(0xffdd4b39),
                                          Color(0xffdd4b39)
                                        ]),
                                  ),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
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
            ),
          ],
          
        ),
        bottomNavigationBar: NavigationBar(),
      ));
    
  }

  Card buildCard(String title, String image) {
    return Card(
      child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(image),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {
                  MyNavigator.goToTimelineOrders(context);
                },
                color: Colors.green,
                child: Text(
                  "Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}