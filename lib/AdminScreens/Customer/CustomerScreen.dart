import 'package:JapanThaiExpress/AdminScreens/Customer/Person.dart';
import 'package:JapanThaiExpress/AdminScreens/WidgetsAdmin/Navigation.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatefulWidget {
  CustomerScreen({Key key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Person> persons = [
     Person(name: 'Bill Will', profileImg: 'assets/pic-1.png', bio: "Software Developer"),
     Person(name: 'Andy Smith', profileImg: 'assets/pic-2.png', bio: "UI Designer"),
     Person(name: 'Creepy Story', profileImg: 'assets/pic-3.png', bio: "Software Tester"),
     Person(name: 'Sam Sony', profileImg: 'assets/pic-4.png', bio: "System Engineer"),
     Person(name: 'Bill Will', profileImg: 'assets/pic-1.png', bio: "Software Developer"),
     Person(name: 'Andy Smith', profileImg: 'assets/pic-2.png', bio: "UI Designer"),
     Person(name: 'Creepy Story', profileImg: 'assets/pic-3.png', bio: "Software Tester"),
     Person(name: 'Sam Sony', profileImg: 'assets/pic-4.png', bio: "System Engineer")
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Customer"),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          children: [
            Column(
              children: persons.map((p) {
                return personDetailCard(p);
              }).toList()
            )
          ],
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}

Widget personDetailCard(Person) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(Person.profileImg)
                )
              )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Person.name,
                  style: TextStyle (
                    color: Colors.white,
                    fontSize: 18
                  ),
                ),
                Text(Person.bio,
                    style: TextStyle (
                    color: Colors.white,
                    fontSize: 12
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}