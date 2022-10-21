import 'dart:ui';

import 'package:delivery_template/models/delivery.dart';
// import 'package:delivery_template/models/orderItemPPC.dart'; 
// import 'package:delivery_template/ressources/getGeoloc.dart';
import 'package:delivery_template/ressources/getOrdersApi.dart';
import 'package:delivery_template/ressources/localeDB.dart'; 
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart'; 
import 'package:fluttertoast/fluttertoast.dart';
 
class SignalProblemScreen extends StatefulWidget {
  final DeliveryModel delivery;
  SignalProblemScreen({  this.delivery});

  @override
  _SignalProblemScreenState createState() => _SignalProblemScreenState();
}

int _currentTabIndex = 0;

class _SignalProblemScreenState extends State<SignalProblemScreen>
    with TickerProviderStateMixin {
  // late OrderPPCModel orderppc;
  final qtyController = TextEditingController();
  final commentController = TextEditingController();
  ///////////////////////////////////////////////////////////////////////////////
  LocalDB db = LocalDB();
  // var _myF;
    GetOrder getOrder;

  double windowWidth = 0.0;
  double windowHeight = 0.0;
    TabController _tabController;
  final editController = TextEditingController();
  final _formKeybookstep2 = GlobalKey<FormState>();
  bool visible = false;

  _issued(DeliveryModel _data) async {
    setState(() {
      visible = true;
    });
    print("begin execute $_data.order.id");
    var resp = await getOrder.issue(_data);
        setState(() {
          visible = false;
        });

    if (resp) {
      setState(() {
          visible = false;
        });
       
   await   Fluttertoast.showToast(
          msg: "Le problème a bien été signalé",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      // return;
    }else{
        
     await Fluttertoast.showToast(
          msg: "une erreur s'est produit",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

        setState(() {
          visible = false;
        });

    }
    //return;
  }

  @override
  void initState() {
    getOrder = GetOrder();
    // _myF = getOrder.fetchAllOrderPPCItem(widget.order.id);
    super.initState();
  }

  @override
  void dispose() {
    editController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _fixedPadding = _height * 0.025;

    final validateBtn = Container(
      margin: EdgeInsets.only(top: 15.0, left: 25, right: 25),
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0), color: Colors.white),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _issued(widget.delivery);
        },
        color: Colors.red,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        child: Text(
          'ENVOYER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Colors.white,
          ),
        ),
      ),
    );

    final forminput = Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Form(
        key: _formKeybookstep2,
        child: Column(
          children: <Widget>[
            //textexplain,
            //inputtelField,

            Padding(
                padding: EdgeInsets.only(top: 10.0, left: _fixedPadding),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(' Quantité posant problème',
                        style:
                            TextStyle(color: Colors.black, fontSize: 13.0)))),
            //  PhoneNumber TextFormFields
            Padding(
                padding: EdgeInsets.only(
                    left: _fixedPadding,
                    right: _fixedPadding,
                    bottom: _fixedPadding),
                child: Card(
                  shape: new RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black54),
                      borderRadius: new BorderRadius.circular(40.0)),
                  shadowColor: Colors.black,
                  borderOnForeground: true,
                  child: Row(
                    children: <Widget>[
                      Text("  qté" + " ",
                          style: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.w700)),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: TextFormField(
                          controller: qtyController,
                          //  autofocus: true,
                          keyboardType: TextInputType.number,
                          key: Key('EnterPhone-TextFormField'),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorMaxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

            Padding(
                padding: EdgeInsets.only(top: 10.0, left: _fixedPadding),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(' Commentez le problème',
                        style:
                            TextStyle(color: Colors.black, fontSize: 13.0)))),
            //  PhoneNumber TextFormFields
            Padding(
                padding: EdgeInsets.only(
                    left: _fixedPadding,
                    right: _fixedPadding,
                    bottom: _fixedPadding),
                child:
                    /* PhoneNumberField(
              controller:
              Provider.of<PhoneAuthDataProvider>(context, listen: false).phoneNumberController,
              prefix: countriesProvider.selectedCountry.dialCode ?? "+243",
            ),*/
                    Card(
                  shape: new RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black54),
                      borderRadius: new BorderRadius.circular(40.0)),
                  shadowColor: Colors.black,
                  borderOnForeground: true,
                  child: Row(
                    children: <Widget>[
                      Text(" ",
                          style: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.w700)),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: TextFormField(
                          controller: commentController,
                          //  autofocus: true,
                          keyboardType: TextInputType.text,
                          key: Key('EnterClient-TextFormField'),
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorMaxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            // inputtclientField,
            SizedBox(
              height: 10,
            ),
            Visibility(
                visible: visible,
                child: Center(
                    child: Column(children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Envoie en cours ...",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  )
                ]))),
            validateBtn,
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            // margin: EdgeInsets.only(top: 20),
            child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Signalez un problème",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                      )),
                  forminput
                ],
              
            )));
  }
}
