import 'dart:async';
import 'dart:ui';

import 'package:delivery_template/model/geolocator.dart';
import 'package:delivery_template/models/delivery.dart'; 
import 'package:delivery_template/ressources/getDeliverBoyApi.dart';
import 'package:delivery_template/ressources/getGeoloc.dart';
import 'package:delivery_template/ressources/getOrdersApi.dart';
import 'package:delivery_template/ressources/localeDB.dart'; 
import 'package:delivery_template/ui/main/orderdetails.dart'; 
import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart'; 
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
 

class AllDeliverCar extends StatefulWidget {
  final Function(String, Map<String, dynamic>) callback;
  final Map<String, dynamic> params;
  AllDeliverCar({this.callback, this.params});

  @override
  _AllDeliverCarState createState() => _AllDeliverCarState();
}

 
class _AllDeliverCarState extends State<AllDeliverCar>
    with TickerProviderStateMixin {
 
  Future<void> scanQR(DeliveryModel _data) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      print(
          'code scanné : ' + barcodeScanRes + ' dc' + _data.order.deliverycode);

      if (barcodeScanRes == _data.order.deliverycode) {
        _delivered(_data.order.id);
        setState(() {
          _myF = getOrder.fetchAll();
        });

        await Fluttertoast.showToast(
            msg: 'Vous venez de livrer la commande',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      } else {
        await Fluttertoast.showToast(
            msg: 'Code de livraison incorrecte',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 5,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  deliverManualy(_data, codeInserted) async {
    if (codeInserted == _data.order.deliverycode) {
      _delivered(_data.order.id);
      setState(() {
        _myF = getOrder.fetchAll();
      });

      await Fluttertoast.showToast(
          msg: 'Vous venez de livrer la commande',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      await Fluttertoast.showToast(
          msg: 'Code de livraison incorrecte',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 5,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  LocalDB db = LocalDB();
  var _myF;
  GetOrder getOrder;
  GetGeoloc geo;
  Location geoloc = Location();

  String idOrder = '0';
  final codeInserted = TextEditingController();
  _delivered(String id) async {
    print('begin execute $id');
    final resp = await getOrder.delivered(id);

    if (resp) {
      setState(() {
        _myF = getOrder.fetchAll();
      });

      await Fluttertoast.showToast(
          msg: 'Vous venez de livrer la commande',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    return;
  }

  _decisionTrue(DeliveryModel _data) async {
    print('begin execute $idOrder');
    var resp = await getOrder.decision(_data, true);

    if (resp) {
      setState(() {
        _myF = getOrder.fetchAll();
      });
      await Fluttertoast.showToast(
          msg:
              'Vous venez d\'accepter la livraison ${idOrder.length > 5 ? idOrder.substring(0, 5) : ''}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    return;
  }

  _shiped(DeliveryModel _data) async {
    print('begin execute $idOrder');

    final resp = await getOrder.shiped(_data);

    if (resp) {
      setState(() {
        _myF = getOrder.fetchAll();
      });
      await Fluttertoast.showToast(
          msg: 'Vous venez d\'embarquer la marchandise',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    return;
  }

  _decisionFalse(DeliveryModel _data) async {
    print('begin execute $idOrder');
    var resp = await getOrder.decision(_data, false);

    if (resp) {
      setState(() {
        _myF = getOrder.fetchAll();
      });
      await Fluttertoast.showToast(
          msg:
              'Vous venez de refuser la livraison ${idOrder.length > 5 ? idOrder.substring(0, 5) : ''}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    return;
  }

 
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  TabController _tabController;
  final editController = TextEditingController();
  double _show = 0;
  var _dialogBody = Container();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    
    getOrder = GetOrder();
   
    _myF = getOrder.fetchAll();
    super.initState();
    

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        //  _showNotificationItemDialog();
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        //_navigateToNotificationDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        //_navigateToNotificationDetail(message);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      //print('Settings registered: $settings');
    });

    //subscribtopic();
  }

  void subscribtopic() {
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      print('deliverboy token orders : ' + token);
      var deliverboyID = '';

      final getdeliverboy = GetDeliverBoy();

      await getdeliverboy.getDeliverBoyID().then((value) {
        setState(() {
          deliverboyID = value;
        });

        print('deliverboy ID orders : ' + deliverboyID);

        _firebaseMessaging.subscribeToTopic(deliverboyID);
      });
    });
  }

  Widget _buildDialog(BuildContext context) {
    //, NotificationItem item
    return AlertDialog(
      title: Row(children: <Widget>[
        Icon(Icons.notifications_active, color: Colors.red, size: 30),
        Text('Notification',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black)),
      ]),
      content: Text(
        'Vous avez une nouvelle livraison!',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        overflow: TextOverflow.visible,
      ),
      actions: <Widget>[
        FlatButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(40.0),
          ),
          textColor: Colors.black,
          color: Colors.white,
          child: Text(
            'D\'accord',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();

            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AllDeliverCar()));
          },
        ),
      ],
    );
  }

  void _showNotificationItemDialog() {
    //, Map<String,dynamic> message
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context), //, _itemForMessage(message)
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        //  _navigateToNotificationDetail( );//(message);
      }
    });
  }

  showDialogCustom(BuildContext context, _data) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.delivery_dining, color: Colors.red, size: 30),
              Text('Code de Livraison',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.black))
            ],
          ),
          content: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Card(
                child: Row(
                  children: <Widget>[
                    Text('  code  ',
                        style: TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.w700)),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        controller: codeInserted,
                        autofocus: false,
                        keyboardType: TextInputType.phone,
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
          actions: <Widget>[
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              textColor: Colors.white,
              color: Colors.teal,
              child: Text(
                'Valider',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deliverManualy(_data, codeInserted.text);
              },
            ),
            OutlineButton(
              child: Text(
                'Annuler',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // editController.dispose();
    // _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _myF = getOrder.fetchAll();

    Timer(Duration(seconds: 150), () {
      //     _updateLocation();
    });

    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return  
        Scaffold(
            body: FutureBuilder(
          future: _myF,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.done) {
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black12,
                  ),
                );
              }
            }

            if (snapshot.connectionState == ConnectionState.done) {
              List<DeliveryModel> orderList;
              if (snapshot.data != null) {
                orderList = snapshot.data;

                return Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 90),
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        Container(
                          child: _body(context,'pending', orderList),
                        ),
                        Container(
                          child: _body(context,'shiped', orderList),
                          //  child: _body(1),
                        ),
                        Container(
                          child: _body(context,'delivered', orderList),
                          //  child: _body(2),
                        ),
                      ],
                    ));
              } else {
                // return Center(
                // child: Text(
                // 'Something wrong with message: ${snapshot.error.toString()}'),
                // );

                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text((strings.get(50)), // 'Not Have Orders',
                        overflow: TextOverflow.clip,
                        style: theme.text16bold),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ));
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black12,
                ),
              );
            }
          },
        )) ;
  }

  _body(BuildContext context,String status, List<DeliveryModel> orderPPC) {
    int size = 0;
    String tr = 'value : ';

    if (orderPPC.length == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          UnconstrainedBox(
              child: Container(
                  height: windowHeight / 3,
                  width: windowWidth / 2,
                  child: Container(
                    child: Image.asset(
                      'assets/nonotify.png',
                      fit: BoxFit.contain,
                    ),
                  ))),
          SizedBox(
            height: 10,
          ),
          Text((strings.get(50)), // 'Not Have Orders',
              overflow: TextOverflow.clip,
              style: theme.text16bold),
          SizedBox(
            height: 15,
          ),
        ],
      ));
    } else {
      return ListView(
        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
        children: _body2(context,status, orderPPC),
      );
    }
  }

  _body2(BuildContext context,String status, List<DeliveryModel> orderPPC) {
    var list = <Widget>[];

    if (status == 'pending') {
      for (var _data in orderPPC) {
        if (_data.order.status == 'pending' ||
            _data.order.status == 'accepted') {
          //orderppc = _data;
          list.add(cardOrder(context,_data));
        }
      }
    } else if (status == 'shiped') {
      for (var _data in orderPPC) {
        if (_data.accepted == true && _data.order.status == 'shiped') {
          //orderppc = _data;
          list.add(cardOrder(context, _data));
        }
      }
    } else if (status == 'delivered') {
      for (var _data in orderPPC) {
        if (_data.accepted == true &&
            (_data.order.status == 'issue' ||
                _data.order.status == 'delivered' ||
                _data.order.status == 'deliverydenied' ||
                _data.order.status == 'canceled')) {
          //orderppc = _data;
          list.add(cardOrder(context,_data));
        }
      }
    }

    return list;
  }

  Widget cardOrder(BuildContext context, DeliveryModel _data) {
    //  print(_data.order.id);
    var statusaccepted = '';

    if (_data.accepted == true) {
      statusaccepted = 'Vous avez accepté la livraison';
    } else if (_data.accepted == false) {
      statusaccepted = 'Vous avez refusé la livraison';
    } else {
      statusaccepted = 'Vous n\'avez pas encore repondu la livraison';
    }
    return ListTile(
      title: Padding(
          padding: EdgeInsets.only(bottom: 9, top: 8),
          child: Card(
            elevation: 5,
            // color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: [
                        Icon(
                          Icons.stacked_line_chart,
                          color: Colors.red,
                          size: 40,
                        ),
                        Text(
                          ' #Commande ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        )
                      ]),
                      SizedBox(
                        height: 7,
                      ),
                      Text('  ' + _data.orderId.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400))
                    ]),
                SizedBox(
                  height: 8,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  Adresse de Livraison : ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + _data.order.shippingAdress,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400))
                    ]),
                SizedBox(
                  height: 8,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  Shop : ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + _data.shop.name,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400))
                    ]),
                SizedBox(
                  height: 8,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  Adresse du Shop :',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + _data.shop.address,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400))
                    ]),
                SizedBox(
                  height: 8,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  Statut:',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + _data.order.status,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400))
                    ]),
                SizedBox(
                  height: 8,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  Feedback :',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + statusaccepted,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400))
                    ]),
                (_data.order.status == 'shiped')
                    ? Padding(
                        padding: EdgeInsets.only(left: 9, top: 8),
                        child: OutlineButton(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.indigo[900],
                            style: BorderStyle.solid,
                          ),
                          onPressed: () {
                            print(
                                'delivery code : ' + _data.order.deliverycode);
                            // scanQR(_data);
                            showDialogCustom(context, _data);
                          },
                          child: Text(
                            'Inserer le code',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.indigo[900]),
                          ),
                          // style: ButtonStyle(

                          //     backgroundColor: MaterialStateProperty.all<Color>(
                          //         Colors.lightBlue)),
                        ))
                    : Container(),
                (_data.order.status == 'shiped')
                    ? Padding(
                        padding: EdgeInsets.only(left: 9, top: 8),
                        child: OutlineButton(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.indigo[900],
                            style: BorderStyle.solid,
                          ),
                          onPressed: () {
                            print(
                                'delivery code : ' + _data.order.deliverycode);
                            scanQR(_data);
                          },
                          child: Text(
                            'Scanner QR Code',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.indigo[900]),
                          ),
                          // style: ButtonStyle(

                          //     backgroundColor: MaterialStateProperty.all<Color>(
                          //         Colors.lightBlue)),
                        ))
                    : Container(),
                (_data.order.status == 'pending' ||
                        _data.order.status == 'accepted')
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Visibility(
                              visible: (_data.accepted == true) ? false : true,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: OutlineButton(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.teal,
                                      style: BorderStyle.solid,
                                    ),
                                    onPressed: () {
                                      _decisionTrue(_data);
                                    },
                                    child: Text('Accepter',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.teal)),
                                    // style: ButtonStyle(
                                    //     // shape: MaterialStateProperty.all<OutlinedBorder>(),
                                    //     backgroundColor:
                                    //         MaterialStateProperty.all<Color>(
                                    //             Colors.teal)),
                                  )),
                            ),
                            Visibility(
                              visible: (_data.accepted == true) ? true : false,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: OutlineButton(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.teal,
                                      style: BorderStyle.solid,
                                    ),
                                    onPressed: () {
                                      _shiped(_data);
                                    },
                                    child: Text('Embarquer',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.teal)),
                                    // style: ButtonStyle(
                                    //     // shape: MaterialStateProperty.all<OutlinedBorder>(),
                                    //     backgroundColor:
                                    //         MaterialStateProperty.all<Color>(
                                    //             Colors.teal)),
                                  )),
                            ),
                            Visibility(
                                visible:
                                    (_data.accepted == false) ? false : true,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: OutlineButton(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.red,
                                      style: BorderStyle.solid,
                                    ),
                                    onPressed: () {
                                      _decisionFalse(_data);
                                    },
                                    child: Text('Rejeter',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.red)),
                                    // style: ButtonStyle(
                                    //     backgroundColor:
                                    //         MaterialStateProperty.all<Color>(
                                    //             Colors.red)),
                                  ),
                                ))
                          ])
                    : Container(),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => OrdersDetailsScreen(delivery: _data)));
      },
    );
  }
}
