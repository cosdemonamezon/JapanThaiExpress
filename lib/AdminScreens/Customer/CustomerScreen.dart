import 'package:JapanThaiExpress/AdminScreens/Customer/Person.dart';
import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatefulWidget {
  CustomerScreen({Key key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  TextEditingController editingController = TextEditingController();

  List<Person> persons = [
    Person(
        name: 'ธวัชชัย มุ้งภูเขียว',
        profileImg:
            'https://scontent.fbkk22-6.fna.fbcdn.net/v/t31.18172-8/170037_103317113078424_7910952_o.jpg?_nc_cat=102&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=jq4Aka_E47kAX8bzhi5&_nc_ht=scontent.fbkk22-6.fna&oh=15ce27b68da3a41ea3d1d0c0ac8135dc&oe=60935BE0',
        bio: "Tel : 094826462"),
    Person(
        name: 'ผาณิต ปิ่นทอง',
        profileImg:
            'https://scontent.fbkk22-3.fna.fbcdn.net/v/t1.6435-9/164603254_10208575861031918_4402544809188298525_n.jpg?_nc_cat=111&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=HUUbZKro7ZUAX9BWCDU&_nc_ht=scontent.fbkk22-3.fna&oh=dd2b97db7f33e16ce484f72d3415d321&oe=60924092',
        bio: "Tel : 094725253"),
    Person(
        name: 'นิวัฒน์ พุ่มกลิ่น',
        profileImg:
            'https://scontent.fbkk22-3.fna.fbcdn.net/v/t1.18169-1/p200x200/14670814_1160375137357037_2111500651625118280_n.jpg?_nc_cat=110&ccb=1-3&_nc_sid=7206a8&_nc_ohc=TReZBgAN8IkAX_nzeuq&_nc_ht=scontent.fbkk22-3.fna&tp=6&oh=b6e7314bf199e781176e2063d3581593&oe=60947C7A',
        bio: "Tel : 094725111"),
    Person(
        name: 'ภานุวัฒน์ ชุรี',
        profileImg:
            'https://scontent.fbkk22-1.fna.fbcdn.net/v/t1.6435-9/84330606_3054240611293119_7461998935083581440_n.jpg?_nc_cat=101&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=qAPgv2YrfHwAX_92UC5&_nc_oc=AQmlnEcvgiyqDULnLG_G0v3_MLAzRtbGRj1QEofqJCb8flFDhc6Nf3zoaA0DCXUwqiWiR9tAzGtmKzX0xu5yI1pm&_nc_ht=scontent.fbkk22-1.fna&oh=a083379341a5cc85e1c52637b81deb56&oe=609398CB',
        bio: "Tel : 094725054"),
    Person(
        name: 'พงศกร วิชัยยุทธ',
        profileImg:
            'https://scontent.fbkk22-1.fna.fbcdn.net/v/t1.6435-9/86350932_2807434042637336_6205288068300144640_n.jpg?_nc_cat=101&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=-IU3JNbbmi4AX8LNhk8&_nc_ht=scontent.fbkk22-1.fna&oh=72f398cd426e78eabbaceaf3b224b2b7&oe=609261FC',
        bio: "Tel : 094725302"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Customers"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              ),
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              children: [
                Column(
                    children: persons.map((p) {
                  return personDetailCard(p);
                }).toList())
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}

Widget personDetailCard(Person) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Card(
      // color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(Person.profileImg)))),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Person.name,
                  style: TextStyle(color: Color(0xffdd4b39), fontSize: 18),
                ),
                Text(
                  Person.bio,
                  style: TextStyle(color: Color(0xffdd4b39), fontSize: 12),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
