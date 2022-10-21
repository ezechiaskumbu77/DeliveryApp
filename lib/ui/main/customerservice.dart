// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:friends/utils/widgets/common.dart';

class CustomerServicePage extends StatefulWidget {
  @override
  _CustomerServicePageState createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  bool isthereconnection = false;
  var tel = '+243 82 49 33 17 09';
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon( Icons.donut_large, size: 30,   color: Colors.red ),  
            SizedBox(width:10), 
            Text(
              'Service Client ',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 19,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // getCustomerServicePage(notification)
                Text(
                  'Besoin d\'aide? vous avez un problème? ',
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
                SizedBox(
                  height: 15,
                ),
               
                    Text(
                      'Contactez-nous par Whatsapp (uniquement) au :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                     Row(
                  children: <Widget>[
                    Icon(Icons.phone),
                    Text(tel,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),]),
                  
                SizedBox(
                  height: 8,
                ),

                /*Divider(),
                Row(
                  children: <Widget>[
                    Text(
                      'Appel',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('+243 82 7996 11')
                  ],
                ),*/
                Divider(),
              ]),
        ));
  }
}
