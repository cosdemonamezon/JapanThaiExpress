import 'dart:io' as Io;
import 'dart:convert';
import 'package:JapanThaiExpress/UserScreens/Service/DetailStep.dart';
import 'package:JapanThaiExpress/UserScreens/Service/Service.dart';
import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Deposit extends StatefulWidget {
  Deposit({Key key}) : super(key: key);

  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  List<bool> checked = [false, true, false, false, true];
  String valueChoose;
  bool isLoading = false;
  Io.File _image;
  String img64;
  final picker = ImagePicker();
  List dropdownValue = [];
  List address = [];
  int id;
  String name;
  String add;
  String tel;
  final _formKey = GlobalKey<FormBuilderState>();
  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJsdW1lbi1qd3QiLCJzdWIiOjYsImlhdCI6MTYxNTcxNTA3NCwiZXhwIjoxNjE1ODAxNDc0fQ.qX0GNbwo7PNY8TD4AXYQwGywdrOVmolOYum9wg1sG84";

  @override
  void initState() { 
    super.initState();
    _addressMem();
  }

  _addressMem() async {
    setState(() {
      isLoading = true;
    });

    var url = pathAPI + 'api/address_mem';
    var response = await http.get(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token
      }
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> addressdata = convert.jsonDecode(response.body);
      print(addressdata);
      setState(() {
        address = addressdata['data'];
        id = address[0]['id'];
        name = address[0]['name'];
        add = address[0]['address'];
        tel =  address[0]['tel'];               
                              
                             
      });
    } else {
      print("error");
    }
  }

  _createDepository(Map<String, dynamic> values) async {
    print(values);
    print(id);
    print(img64);
    setState(() {
      isLoading = true;
    });
    var url = pathAPI + 'api/create_depository';
    var response = await http.post(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token
      },
      body: ({
        'add_id': id.toString(),
        'image': "data:image/png;base64,"+img64,
        'description': values['description'],       
        
      })
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> depositdata = convert.jsonDecode(response.body);
      print(depositdata);
      if (depositdata['code'] == 201) {
        print(depositdata['data']['description']);
        //MyNavigator.goToDeposit(context);
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => Deposit()));
        
      } else {
      }
    } else {
      print("error");
    }
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text("รับฝากส่ง"),
              leading: IconButton(
                onPressed: (){
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Service()));
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
                        child: Text("ฝากส่ง"),
                      ),
                    ),
                  ])),
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
                      'add_id': id.toString(),
                      'image': img64,
                      'description': '',
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
                              Text(
                                "ที่อยู่",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              addressCard(                                                            
                                name == null ? "":name,
                                add == null ? "":add,
                                tel == null ? "": tel,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "รายละเอียด",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              FormBuilderTextField(
                                name: 'description',
                                maxLines: 4,
                                decoration: InputDecoration(
                                    //border: InputBorder.none,
                                    border: OutlineInputBorder(),
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
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
                                  _createDepository(_formKey.currentState.value);
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

  Card addressCard(String title, String title1, String subtitle) {
    return Card(
      color: Colors.orange[100],
      child: ListTile(        
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title == null ?
            Text("...")
            :Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: kTextButtonColor),
            ),
            title1 == null ?
            Text("...")
            :Text(
              title1,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: kTextButtonColor),
            ),
          ],
        ),
        subtitle: subtitle == null ?
        Text("...")
        :Text(
          subtitle,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: kTextButtonColor),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, size: 25,), 
          onPressed: (){
            showDialog(
              //barrierDismissible: false,
              context: context,
              builder: (context) => selectdialog(            
                context,
              ),
            );
            //selectdialog();
          }
        ),
      ),
    );
  }

  Card selectCard(String title, String title1, String subtitle, int index) {
    return Card(
      color: kFontPrimaryColor,
      child: ListTile(        
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: kTextButtonColor),
            ),
            Text(
              title1,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: kTextButtonColor),
            ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: kTextButtonColor),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, size: 25,), 
          onPressed: (){
            setState(() {
              id = address[index]['id'];
              name = title;
              add = title1;
              tel = subtitle;
            });
            Navigator.pop(context);
            //selectdialog();
          }
        ),
      ),
    );
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
                onPressed: () {},
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

  selectdialog(context){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 4,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
        margin: EdgeInsets.only(top: Constants.avatarRadius),
        decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: kFontPrimaryColor,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
        child: Container(
          height: 300,
          child: Column(
            children: [
              Text(
                "เลือกที่อยู่",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,)
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: address.length,
                itemBuilder: (BuildContext context, int index){
                  return selectCard(              
                    address[index]['name'],
                    address[index]['address'],
                    address[index]['tel'],
                    index,
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
