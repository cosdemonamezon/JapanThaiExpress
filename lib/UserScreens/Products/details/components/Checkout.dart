import 'package:JapanThaiExpress/UserScreens/Products/details/components/Payment.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  Checkout({Key key}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Check out"),
      ),
      body: Container(
        height: height,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 50,),
            Center(
              child: Text("Totals"),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.shade200,
                            offset: Offset(2, 4),
                            //blurRadius: 1,
                            spreadRadius: 4)
                      ],
                ),
                child: Text("100,000", style: TextStyle(fontSize: 20, color: Colors.black),),
              ),
            ),
            SizedBox(height: 20,),
            Container(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Detail", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ],
                    ),
                  ),
            SizedBox(height: 20,),
            buildCard(
                    "A Material Design raised button. A raised button consists of a rectangular piece of material that hovers over the interface. Documentation. Input and selections",
                    "assets/o2.jpg",
                  ),
                  buildCard(
                    "Implementing an icon-only toggle button. The following example shows a toggle button with three buttons that have icons",
                    "assets/o3.jpg",
                  ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Payment())
                      );
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
            ),
          ],
        ),
      ),
    );
  }
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
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.purple,
                ),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blueAccent,
                ),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                ),
              ],
            ),
            MaterialButton(
              onPressed: (){},
              color: Colors.green,
              child: Text(
                "Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

Card messageCard(String title, IconData icon, String subtitle) {
  return Card(
    child: ListTile(
      leading: Icon(icon, color: Colors.blue,size: 40.0,),
      title: Text(
        title ,style: TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: Text(subtitle),
    ),
  );
}