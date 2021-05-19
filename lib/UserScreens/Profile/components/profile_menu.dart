import 'package:JapanThaiExpress/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class ProfileMenu extends StatelessWidget {
  final String text; 
  final Icon icon;
  final VoidCallback press;
  
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            IconButton(
              icon: this.icon, 
              color:Colors.deepOrange,
              iconSize: 28,
              onPressed: () {  },
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.keyboard_arrow_right_outlined),
          ],
        ),
      ),
    );
  }
}
