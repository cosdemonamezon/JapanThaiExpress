import 'package:JapanThaiExpress/UserScreens/Profile/ProfileScreen.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:flutter/material.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:image_picker/image_picker.dart';

class Myaccount extends StatefulWidget {
  Myaccount({Key key}) : super(key: key);

  @override
  _MyaccountState createState() => _MyaccountState();
}

class _MyaccountState extends State<Myaccount> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("My account"),
        leading: IconButton(
            onPressed: () {
              MyNavigator.goToProfileScreen(context);
              //Navigator.push(
              //context, MaterialPageRoute(builder: (context) => Auction()));
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: height * 0.88,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 20),
                    Center(
                        child: Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://image.sistacafe.com/images/uploads/summary/image/41751/3e9fea8de38ad5631fd691a1e9c54c26.jpg"),
                              )),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 0,
                                color: Color(0xFFF5F6F9),
                              ),
                              color: Colors.deepOrange,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Wrap(children: [
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text('Camera'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        //selectImageSource(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_album),
                                      title: Text('Gallery'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        //selectImageSource(ImageSource.gallery);
                                      },
                                    ),
                                  ]),
                                );
                              },
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )),
                    SizedBox(height: 10),
                    Text(
                      "ชื่อ(ภาษาไทย)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //name: 'email',
                      //keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'ชื่อ',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      /*validator: TextFormField.compose([
                                  TextFormField.required(context),
                              ])*/
                    ),
                    SizedBox(height: 10),
                    Text(
                      "นามสกุล(ภาษาไทย)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //name: 'email',
                      //keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'นามสกุล',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      /*validator: TextFormField.compose([
                                  TextFormField.required(context),
                              ])*/
                    ),
                    SizedBox(height: 10),
                    Text(
                      "ชื่อ(ภาษาอังกฤษ)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //name: 'email',
                      //keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Name',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      /*validator: TextFormField.compose([
                                  TextFormField.required(context),
                              ])*/
                    ),
                    SizedBox(height: 10),
                    Text(
                      "นามสกุล(ภาษาอังกฤษ)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //name: 'email',
                      //keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Lastname',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      /*validator: TextFormField.compose([
                                  TextFormField.required(context),
                              ])*/
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Email Address",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      //name: 'email',
                      //keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email Address',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(),
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                      /*validator: TextFormField.compose([
                                  TextFormField.required(context),
                              ])*/
                    ),
                    SizedBox(height: 20),
                    /*Container(
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
                      child: Text(
                        "บันทึก",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        
                      ),
                    ),*/
                    //SizedBox(height: 10),
                    TextButton(
                      child: Text('บันทึก'),
                      style: TextButton.styleFrom(
                        primary: Colors.white, 
                        backgroundColor: Colors.deepOrange[800],
                        onSurface: Colors.grey,
                        textStyle: TextStyle(
                            fontSize: 20,
                            height: 1.8,
                        ),
                       
                      ),
                      onPressed: () {
                         String picSuccess = "assets/success.png";
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => alertProfilescreen(
                                  'ดำเนินการสำเร็จ',
                                  picSuccess,
                                  context,
                                ),
                              );
                              // _formKey.currentState.save();
                              // print(_formKey.currentState.value);
                              //_preorderMem(_formKey.currentState.value);
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*void _showImageSourceActionSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      //context
         // .read<ProfileBloc>()
          //.add(OpenImagePicker(imageSource: imageSource));
    }*/