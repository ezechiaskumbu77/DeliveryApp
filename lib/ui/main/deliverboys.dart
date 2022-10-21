import 'dart:async';
import 'dart:ui';

import 'package:delivery_template/model/geolocator.dart';
import 'package:delivery_template/models/deliveryboy.dart';
import 'package:delivery_template/ressources/getDeliverBoyApi.dart';
import 'package:delivery_template/ressources/getGeoloc.dart';
import 'package:delivery_template/ressources/localeDB.dart';
import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'deliverboydetails.dart';

class AllDeliverBoyScreen extends StatefulWidget {
  final Function(String, Map<String, dynamic>) callback;
  final Map<String, dynamic> params;
  AllDeliverBoyScreen({this.callback, this.params});

  @override
  _AllDeliverBoyScreenState createState() => _AllDeliverBoyScreenState();
}

class _AllDeliverBoyScreenState extends State<AllDeliverBoyScreen>
    with TickerProviderStateMixin {
  ///////////////////////////////////////////////////////////////////////////////
  //

  get deliverboy => null;

  //
  ///////////////////////////////////////////////////////////////////////////////
  LocalDB db = LocalDB();
  var _myF;
  GetDeliverBoy getDeliverBoy;
  GetGeoloc geo;
  Location geoloc = Location();

  String idOrder = '0';

  _decision(_id, status) async {
    print('begin execute $idOrder');
    var resp = await getDeliverBoy.changeStatus(_id, status);

    if (resp) {
      setState(() {
        _myF = getDeliverBoy.fetchAll();
      });
      await Fluttertoast.showToast(
          msg:
              'effectué',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }else{
     
      await Fluttertoast.showToast(
          msg:
              'non effectué, verifiez votre connexion',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
   
  }

  double windowWidth = 0.0;
  double windowHeight = 0.0;
  TabController _tabController;
  final editController = TextEditingController();
  double _show = 0;
  // var _dialogBody = Container();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    getDeliverBoy = GetDeliverBoy();

    _myF = getDeliverBoy.fetchAll();
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        //_showNotificationItemDialog(message);
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
   // subscribtopic();
  }

  

  @override
  void dispose() {
    editController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _myF = getDeliverBoy.fetchAll();

    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(elevation: 10, title: Text('Mes Livreurs', style:TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.w900 )),),
        body: FutureBuilder(
      future: _myF,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text('Aucun livreur trouvé', // 'Not Have Orders',
                    overflow: TextOverflow.clip,
                    style: theme.text16bold),
                SizedBox(
                  height: 10,
                ),
              ],
            ));
          } else {
            //  print('has data ${snapshot.hasData}');
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black12,
              ),
            );
          }
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<DeliverBoyModel> deliverboyList;
          if (snapshot.data != null) {
            deliverboyList = snapshot.data;
            print('Length deliverboyList :  '+deliverboyList.length.toString());
            return Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
              child: Container(
                child: _body(deliverboyList),
                //  child: _body(1),
              ),
            );
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text('Aucun livreur trouvé', // 'Not Have Orders',
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
    ));
  }

  _body(List<DeliverBoyModel> deliversboy) {
  

    if (deliversboy.length == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          UnconstrainedBox(
              child: Container(
                  height: windowHeight / 3,
                  width: windowWidth / 2,
                  child: Container(
                    child: Icon(Icons.person_outlined),
                  ))),
          SizedBox(
            height: 10,
          ),
          Text('Aucun livreur trouvé!', // 'Not Have Orders',
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
        children: _body2(deliversboy),
      );
    }
  }

  _body2(List<DeliverBoyModel> deliversboys) {
    var list = <Widget>[];

    for (var _data in deliversboys) {
      //orderppc = _data;
      list.add(cardDeliverboy(_data));
    }

    return list;
  }

  Widget cardDeliverboy(DeliverBoyModel _data) {
    //  print(_data.order.id);
    var status = '';
    var statusColor;
    /*
            'agreed',
            'rejected',
            'pending',
            'banned'
          */
    if (_data.status == 'agreed') {
      status = 'Agrée';
      statusColor = Colors.teal;
    } else if (_data.status == 'banned') {
      status = 'Banni';
      statusColor = Colors.red;
    } else if (_data.status == 'rejected') {
      status = 'Rejeté';
      statusColor = Colors.red;
    } else {
      status = 'En attente';
      statusColor = Colors.orange;
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
                 Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Icon(Icons.person_outline_sharp, color: Colors.black, size: 55,),
                    Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  Livreur : ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Text('  ' + _data.user.name.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                              SizedBox(
                      height: 8,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '  Statut : ',
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w700),
                          ),
                          Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          height: 20.0,
                          //width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: statusColor),
                            color: statusColor,
                          ),
                          child: Center(
                              child: Text(
                            status,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )))
                   
                ])
                    ])
                    
                    ,]),
                
                    
                SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: (_data.status == 'pending' ||
                                _data.status == 'banned' ||
                                _data.status == 'rejected')
                            ? true
                            : false,
                        child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: OutlineButton(
                              onPressed: () {
                                _decision(_data.id, 'agreed');
                              },
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                              ),
                              child: Text('Agréer', style: TextStyle(fontWeight: FontWeight.w700,color: Colors.teal),)/*,
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.teal)),*/
                            )),
                      ),
                      Visibility(
                        visible: (_data.status == 'pending' ||
                                _data.status == 'agreed')
                            ? true
                            : false,
                        child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: OutlineButton(
                              onPressed: () {
                                _decision(_data.id, 'rejected');
                              },
                               borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                              ),
                              child: Text('Rejeter', style: TextStyle( fontWeight: FontWeight.w700,  color: Colors.red[800]))/*,
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red)),*/
                            )),
                      ),
                      Visibility(
                        visible: (_data.status == 'agreed' ||
                                _data.status == 'banned' ||
                                _data.status == 'rejected')
                            ? true
                            : false,
                        child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: OutlineButton(
                              onPressed: () {
                                _decision(_data.id, 'pending');
                              },
                               borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                              ),
                              child: Text('En attente', style: TextStyle(fontWeight: FontWeight.w700,color: Colors.orangeAccent))/*,
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.orange)),*/
                            )),
                      ),
                      Visibility(
                        visible: (_data.status == 'agreed' ||
                                _data.status == 'pending' ||
                                _data.status == 'rejected')
                            ? true
                            : false,
                        child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: OutlineButton(
                              onPressed: () {
                                _decision(_data.id, 'banned');
                              },
                               borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                              ),
                              child: Text('Bannir', style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black)),/*
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red))*/
                            )),
                      ),
                    ])
                //  : Container(),
                ,
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => DeliverBoyDetailsScreen(deliverboy)));
      },
    );
  }
}
