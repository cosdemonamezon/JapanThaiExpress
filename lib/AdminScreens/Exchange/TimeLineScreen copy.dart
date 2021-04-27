// import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert' as convert;
// import 'package:http/http.dart' as http;
// import 'package:JapanThaiExpress/constants.dart';
// import 'package:JapanThaiExpress/utils/japanexpress.dart';
// import 'package:JapanThaiExpress/utils/my_navigator.dart';
// import 'package:timeline_tile/timeline_tile.dart';

// class TimeLineScreen extends StatefulWidget {
//   TimeLineScreen({Key key}) : super(key: key);

//   @override
//   _TimeLineScreenState createState() => _TimeLineScreenState();
// }

// class _TimeLineScreenState extends State<TimeLineScreen> {
//   SharedPreferences prefs;
//   SharedPreferences prefsNoti;
//   bool isLoading = false;
//   Map<String, dynamic> data = {};
//   List<dynamic> notidata = [];
//   Map<String, dynamic> readnotidata = {};
//   Map<String, dynamic> numberNoti = {};

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           centerTitle: true,
//           title: Text("Service Orders"),
//         ),
//         body: Container(
//           width: double.infinity,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               TimelineTile(
//                 alignment: TimelineAlign.manual,
//                 lineXY: 0.1,
//                 isFirst: true,
//                 indicatorStyle: const IndicatorStyle(
//                   width: 20,
//                   color: Colors.purple,
//                 ),
//                 beforeLineStyle: const LineStyle(
//                   color: Colors.purple,
//                   thickness: 6,
//                 ),
//               ),
//               const TimelineDivider(
//                 begin: 0.1,
//                 end: 0.9,
//                 thickness: 6,
//                 color: Colors.purple,
//               ),
//               TimelineTile(
//                 alignment: TimelineAlign.manual,
//                 lineXY: 0.9,
//                 beforeLineStyle: const LineStyle(
//                   color: Colors.purple,
//                   thickness: 6,
//                 ),
//                 afterLineStyle: const LineStyle(
//                   color: Colors.deepOrange,
//                   thickness: 6,
//                 ),
//                 indicatorStyle: const IndicatorStyle(
//                   width: 20,
//                   color: Colors.cyan,
//                 ),
//               ),
//               const TimelineDivider(
//                 begin: 0.1,
//                 end: 0.9,
//                 thickness: 6,
//                 color: Colors.deepOrange,
//               ),
//               TimelineTile(
//                 alignment: TimelineAlign.manual,
//                 lineXY: 0.1,
//                 isLast: true,
//                 beforeLineStyle: const LineStyle(
//                   color: Colors.deepOrange,
//                   thickness: 6,
//                 ),
//                 indicatorStyle: const IndicatorStyle(
//                   width: 20,
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: Navigation(),
//       ),
//     );
//   }
// }
