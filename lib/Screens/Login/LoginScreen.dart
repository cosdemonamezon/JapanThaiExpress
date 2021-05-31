import 'dart:io';

// import 'package:JapanThaiExpress/Screens/Login/LoginPin.dart';
// import 'package:JapanThaiExpress/Screens/Register/RegisterScreen.dart';
// import 'package:JapanThaiExpress/Screens/Login/ForgotScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:device_info/device_info.dart';
import 'dart:convert' as convert;
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:JapanThaiExpress/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:JapanThaiExpress/alert.dart';
import 'package:JapanThaiExpress/utils/japanexpress.dart';
import 'package:JapanThaiExpress/utils/my_navigator.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:JapanThaiExpress/widgets/SocialIcon.dart';
import 'package:JapanThaiExpress/widgets/CustomIcons.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/my_navigator.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormBuilderState>();
  String deviceName;
  String deviceVersion;
  String identifier;

  bool _isSelected = false;

  GoogleSignInAccount _currentUser;
  String _contactText = '';

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<Null> _logOutFacebook() async {
    await facebookSignIn.logOut();
    _showMessage('Logged out.');
  }

  Future<Null> _loginFacebook() async {
    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _showMessage('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${accessToken.token}'));

        final Map<String, dynamic> facebookdata =
            convert.jsonDecode(graphResponse.body);
        _handleSubmittedSocial(
            facebookdata['first_name'],
            facebookdata['last_name'],
            facebookdata['email'],
            facebookdata['id'],
            'facebook',
            facebookdata['picture']['data']['url']);

        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }
  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = "Loading contact info...";
    });

    _handleSubmittedSocial(user.displayName, user.displayName, user.email,
        user.id, 'google', user.photoUrl);

    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _loginGoogle() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void _showMessage(String message) {
    print(message);
  }

  SharedPreferences prefs;
  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _handleSubmitted() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }

      var status = await OneSignal.shared.getPermissionSubscriptionState();
      String playerId = status.subscriptionStatus.userId;

      var url = Uri.parse(pathAPI + 'api/login_mobile');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: convert.jsonEncode({
            'tel': _formKey.currentState.fields['phone'].value,
            'password': _formKey.currentState.fields['password'].value,
            'device': identifier,
            'noti': playerId,
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = convert.jsonDecode(response.body);
        if (body['code'] == 200) {
          await prefs.setString('token', response.body);
          if (body['data']['type'] == "admin")
            MyNavigator.goToAdmin(context);
          else
            MyNavigator.goToMember(context);
          return false;
        } else if (body['code'] == 999) {
          MyNavigator.goToSetPin(context);
          return false;
        } else {
          var feedback = convert.jsonDecode(response.body);
          Flushbar(
            title: '${feedback['message']}',
            message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['code']}',
            backgroundColor: Colors.redAccent,
            icon: Icon(
              Icons.error,
              size: 28.0,
              color: Colors.white,
            ),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Colors.blue[300],
          )..show(context);
        }
      } else {
        var feedback = convert.jsonDecode(response.body);
        Flushbar(
          title: '${feedback['message']}',
          message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['code']}',
          backgroundColor: Colors.redAccent,
          icon: Icon(
            Icons.error,
            size: 28.0,
            color: Colors.white,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  Future<void> _handleSubmittedSocial(String fname, String lname, String email,
      String uid, String provider, String imageurl) async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }

      var status = await OneSignal.shared.getPermissionSubscriptionState();
      String playerId = status.subscriptionStatus.userId;

      var url = Uri.parse(pathAPI + 'api/login_social');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: convert.jsonEncode({
            'userId': uid,
            'fname': fname,
            'lname': lname,
            'email': email,
            'type': provider,
            'device': identifier,
            'noti': playerId,
            'picture': imageurl,
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = convert.jsonDecode(response.body);
        await prefs.setString('token', response.body);
        if (body['code'] == 200) {
          if (body['data']['type'] == "admin")
            MyNavigator.goToAdmin(context);
          else
            MyNavigator.goToMember(context);
          return false;
        } else if (body['code'] == 999) {
          MyNavigator.goToSetPin(context);
          return false;
        } else {
          var feedback = convert.jsonDecode(response.body);
          Flushbar(
            title: '${feedback['message']}',
            message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['code']}',
            backgroundColor: Colors.redAccent,
            icon: Icon(
              Icons.error,
              size: 28.0,
              color: Colors.white,
            ),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Colors.blue[300],
          )..show(context);
        }
      } else {
        var feedback = convert.jsonDecode(response.body);
        Flushbar(
          title: '${feedback['message']}',
          message: 'เกิดข้อผิดพลาดจากระบบ : ${feedback['code']}',
          backgroundColor: Colors.redAccent,
          icon: Icon(
            Icons.error,
            size: 28.0,
            color: Colors.white,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPrefs();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser);
      }
    });
    // _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              // autovalidate: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * .10),
                  Hero(
                    tag: "hero",
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage("assets/logo.png"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "เบอร์โทร",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'phone',
                          decoration: InputDecoration(
                              //border: InputBorder.none,
                              labelText: 'เบอร์โทร',
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                          // valueTransformer: (text) => num.tryParse(text),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'กรุณากรอกเบอร์โทร'),
                            FormBuilderValidators.minLength(context, 10,
                                errorText: 'กรุณากรอกเบอร์โทรให้ถูกต้อง')
                          ]),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "รหัสผ่าน",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'password',
                          obscureText: true,
                          decoration: InputDecoration(
                              //border: InputBorder.none,
                              labelText: 'รหัสผ่าน',
                              border: OutlineInputBorder(),
                              fillColor: Color(0xfff3f3f4),
                              filled: false),
                          // valueTransformer: (text) => num.tryParse(text),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'กรุณากรอกรหัสผ่าน'),
                            FormBuilderValidators.minLength(context, 8,
                                errorText: 'รหัสผ่านอย่างน้อย 8 ตัว'),
                          ]),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState.saveAndValidate()) {
                        _handleSubmitted();
                      }
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => LoginPin()));
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
                            colors: [Color(0xffdd4b39), Color(0xffdd4b39)]),
                      ),
                      child: Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          MyNavigator.goToForgot(context);
                        },
                        child: Text('ลืมรหัสผ่าน ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500))),
                  ),
                  _divider(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocialIcon(
                        colors: [
                          Color(0xFF102397),
                          Color(0xFF187adf),
                          Color(0xFF00eaf8),
                        ],
                        iconData: CustomIcons.facebook,
                        onPressed: () {
                           _loginFacebook();
                        },
                      ),
                      SocialIcon(
                        colors: [
                          Color(0xFFff4f38),
                          Color(0xFFff355d),
                        ],
                        iconData: CustomIcons.googlePlus,
                        onPressed: () {
                          _loginGoogle();
                        },
                      ),
                      // SocialIcon(
                      //   colors: [
                      //     Color(0xFF17ead9),
                      //     Color(0xFF6078ea),
                      //   ],
                      //   iconData: CustomIcons.twitter,
                      //   onPressed: () {},
                      // ),
                      // SocialIcon(
                      //   colors: [
                      //     Color(0xFF00c6fb),
                      //     Color(0xFF005bea),
                      //   ],
                      //   iconData: CustomIcons.linkedin,
                      //   onPressed: () {},
                      // )
                    ],
                  ),
                  // SizedBox(height: height * .045),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('หรือ'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  _createAccountLabel() {
    return InkWell(
      onTap: () {
        MyNavigator.goToRegister(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'สมัครสมาชิก',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
