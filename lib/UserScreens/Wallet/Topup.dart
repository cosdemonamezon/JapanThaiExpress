import 'package:JapanThaiExpress/UserScreens/WidgetsUser/NavigationBar.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/constants.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io' as Io;
import 'dart:convert';



class Topup extends StatefulWidget {
  Topup({Key key}) : super(key: key);

  @override
  _TopupState createState() => _TopupState();
}

class _TopupState extends State<Topup> {
  final _formKey = GlobalKey<FormBuilderState>();
  SharedPreferences prefs;
  bool isLoading = false;
  Map<String, dynamic> qrcode = {};
  Map<String, dynamic> upqrcode = {};
  Map<String, dynamic> setting = {};
  bool qr = false;
  String imgUrl;
  Io.File _image;
  String img64;
  final picker = ImagePicker();
  int iD;

  @override
  void initState() {
    super.initState();
    _getSettingApp();
  }

  _getSettingApp() async{
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/setting_app');
    var response = await http.get(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },        
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> settingdata = convert.jsonDecode(response.body);
      setState(() {
        setting = settingdata['data'];
        //isLoading = true;
      });
    } else {
      setState(() {
        //isLoading = true;
      });
      print('error from backend ${response.statusCode}');
    }
  }

  _genQRcode(Map<String, dynamic> values)async {
    //print(values);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/app/gen_qrcode');
    var response = await http.post(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
      body: ({
        'price_total': values['amount'],        
      })
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> qrdata = convert.jsonDecode(response.body);
      if (qrdata['code'] == 200) {
        print(qrdata['message']);
        print(qrdata['data']['qrcode']);
        setState(() {
          qrcode = qrdata['data'];          
          qr = true;
          iD = qrdata['data']['id'];
          isLoading = false;
        });
      } else {
        final Map<String, dynamic> qrdata = convert.jsonDecode(response.body);
        print(qrdata['message']);
      }
    } else {
    }
  }

  _uploadQRcode() async{
    print(img64);
    print(iD);
    prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString('token');
    var token = convert.jsonDecode(tokenString);
    var url = Uri.parse(pathAPI + 'api/app/upload_qrcode/'+iD.toString());
    var response = await http.post(
      url,
      headers: {
        //'Content-Type': 'application/json',
        'Authorization': token['data']['token']
      },
      body: ({
        'slip': "data:image/png;base64,"+img64,
      })
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> upqrdata = convert.jsonDecode(response.body);
      if (upqrdata['code']==200) {
        setState(() {
          isLoading = false;
        });
        String picSuccess = "assets/success.png";
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alertService(
            upqrdata['message'],            
            picSuccess,
            context,
          ),
        );
      } else {
        //MyNavigator.goToService(context);
      }
    } else {
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

  _saveGif(String imgUrl) async {
    print(imgUrl);
    var appDocDir = await getTemporaryDirectory();
    print(appDocDir.path);
    String savePath = appDocDir.path + "/temp.png";
    print(savePath);
    String fileUrl = imgUrl;
    await Dio().download(fileUrl, savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);
    print("555555+++++");
    
  }
  

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("เติมเงิน"),
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'amount': '',              
            },
            child: qr == false 
            ?Column(
              children: [
                SizedBox(height: 20,),
                Center(
                  child: Container(
                    height: 180,
                    width: width*0.9,
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Text(
                                "ชื่อบัญชี :", style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(width: 20,),
                              setting['jt_account'] == null ? Text(".")
                              :Text(
                                "${setting['jt_account']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "เลขที่บัญชี :", style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              setting['jt_promptpay'] == null ? Text(".")
                              :Text(
                                "${setting['jt_promptpay']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 22),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "ธนาคาร :", style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(width: 20,),
                              setting['jt_bank'] == null ? Text(".")
                              :Text(
                                "${setting['jt_bank']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "สาขา :",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(width: 40,),
                              setting['jt_branch'] == null ? Text(".")
                              :Text(
                                "${setting['jt_branch']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                ),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("จำนวนเงิน", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'amount',
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context, errorText: 'กรุณากรอกจำนวนเงิน'),
                          // FormBuilderValidators.numeric(context),
                          // FormBuilderValidators.max(context, 70),
                        ]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {                          
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() {
                              isLoading = true;
                            });
                            //print(_formKey.currentState.value);
                            _genQRcode(_formKey.currentState.value);
                          } else {
                            print("555555");
                          }  
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
                                spreadRadius: 2
                              )
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xffdd4b39),
                                Color(0xffdd4b39)
                              ]
                            ),
                          ),
                          child: isLoading == true
                          ?Center(child: CircularProgressIndicator())
                          :Text(
                            "ยืนยัน",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            )
            :Column(
              children: [
                SizedBox(height: 20,),
                Center(
                  child: Container(
                    height: height*0.09,
                    width: width*0.45,
                    //color: Colors.red,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/pp.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),                
                Center(
                  child: Container(
                    height: height*0.34,
                    width: width*0.68,
                    //color: Colors.blue,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: qrcode['qrcode'] != null 
                        ?NetworkImage(qrcode['qrcode'])
                        :NetworkImage("https://picsum.photos/200/300"),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                // Center(
                //   child: GestureDetector(
                //     onTap: (){
                //       setState(() {
                //         imgUrl = qrcode['qrcode'];
                //         _saveGif(imgUrl);
                //       });
                      
                //     },
                //     child: Container(
                //       width: MediaQuery.of(context).size.width,
                //       padding: EdgeInsets.symmetric(vertical: 15),
                //       alignment: Alignment.center,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.all(Radius.circular(5)),
                //         boxShadow: <BoxShadow>[
                //           BoxShadow(
                //             color: Colors.grey.shade200,
                //             offset: Offset(2, 4),
                //             blurRadius: 5,
                //             spreadRadius: 2
                //           )
                //         ],
                //         gradient: LinearGradient(
                //           begin: Alignment.centerLeft,
                //           end: Alignment.centerRight,
                //           colors: [
                //             Color(0xffdd4b39),
                //             Color(0xffdd4b39)
                //           ]
                //         ),
                //       ),
                //       child: Text(
                //         "Save img",
                //         style: TextStyle(fontSize: 20, color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 5,),
                Center(
                  child: qrcode['qrcode'] != null
                  ?Text("${qrcode['amount']} บาท", style: TextStyle(fontSize: 25),)
                  :Text("840 บาท", style: TextStyle(fontSize: 25),)
                ),
                SizedBox(height: 8,),
                Center(
                  child: Text("วันที่ 2021-04-21T08:08:56.000000Z"),
                ),
                SizedBox(height: 20,),
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
                SizedBox(height: 5,),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        isLoading = true;
                      });
                      _uploadQRcode();                
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
                            spreadRadius: 2
                          )
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xffdd4b39),
                            Color(0xffdd4b39)
                          ]
                        ),
                      ),
                      child: isLoading == true
                      ?Center(child: CircularProgressIndicator())
                      :Text(
                        "อัปโหลดรูปสลิบ",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );    
  }

  alertService(String title, String img, context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 4,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                    //color: kButtonColor,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kInputSearchColor),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 33,
                ),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kPrimaryColor,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      MyNavigator.goToWallet(context);
                    },
                    child: Text(
                      "ตกลง",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kTextButtonColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}