import 'dart:ui';

import 'package:delivery_template/models/deliveryboy.dart';
import 'package:delivery_template/models/zone.dart';
import 'package:delivery_template/ressources/getDeliverBoyApi.dart';
import 'package:delivery_template/ressources/getZone.dart';
import 'package:delivery_template/ressources/localeDB.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';

class DeliverBoyDetailsScreen extends StatefulWidget {
  final deliverboy;
  DeliverBoyDetailsScreen(this.deliverboy);

  @override
  _DeliverBoyDetailsScreenState createState() =>
      _DeliverBoyDetailsScreenState();
}

class _DeliverBoyDetailsScreenState extends State<DeliverBoyDetailsScreen>
    with TickerProviderStateMixin {
  ///////////////////////////////////////////////////////////////////////////////
  //

  //
  ///////////////////////////////////////////////////////////////////////////////
  LocalDB db = LocalDB();
  GetDeliverBoy getDeliverBoy = GetDeliverBoy();
  GetZone getZone = GetZone();
  var _myF, _getzoneList, _getzoneByDeliverBoyList;

  // GetDeliverBoy getDeliverBoy;
  suppressZone(_zoneid) async {
    final resp =
        await getDeliverBoy.suppressZone(_zoneid, widget.deliverboy.id);

    if (resp) {
      setState(() {
        _getzoneByDeliverBoyList = getDeliverBoy.getZoneList(widget.deliverboy);
      });
      await Fluttertoast.showToast(
          msg: 'Supprimé',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      await Fluttertoast.showToast(
          msg: 'non effectué, verifiez votre connexion',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      return;
    }
  }

  addZone(_id) async {
    final resp = await getDeliverBoy.addZone(_id, widget.deliverboy.id);

    if (resp) {
      _getzoneByDeliverBoyList = getDeliverBoy.getZoneList(widget.deliverboy);
      await Fluttertoast.showToast(
          msg: 'Supprimé',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      await Fluttertoast.showToast(
          msg: 'non effectué, verifiez votre connexion',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
  }

  _decision(_id, status) async {
    final resp = await getDeliverBoy.changeStatus(_id, status);

    if (resp) {
      await Fluttertoast.showToast(
          msg: 'effectué',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      await Fluttertoast.showToast(
          msg: 'non effectué, verifiez votre connexion',
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
  List<ZoneModel> zoneList = <ZoneModel>[];

  @override
  void initState() {
    super.initState();
    _getzoneByDeliverBoyList = getDeliverBoy.getZoneList(widget.deliverboy);
    _getzoneList = getZone.getZoneList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            elevation: 10,
            title: Row(children: [
              Icon(
                Icons.person,
                size: 35,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Livreur',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900))
            ])),
        body: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
          child: Container(
            child: _body(widget.deliverboy),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Center(
              child: Icon(
            CupertinoIcons.add,
            size: 35,
            color: Colors.white,
          )),
          onPressed: () {
            _decision(widget.deliverboy.id, 'agreed');
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text(
                        '#Ajoutez une Zone',
                        style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87),
                      ),
                      actions: [
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1.5, color: Colors.black87),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          textColor: Colors.black87,
                          color: Colors.white,
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      content: Container(
                          width: MediaQuery.of(context).size.width,
                          child: FutureBuilder(
                            future: _getzoneList,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'Aucune zone trouvée', // 'Not Have Orders',
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

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                List<ZoneModel> zones = <ZoneModel>[];

                                if (snapshot.data != null) {
                                  zones = snapshot.data;
                                  print('Length zoneList :  ' +
                                      zones.length.toString());

                                  if (zones != null) {

                                    for (var i = 0; i < zones.length; i++) {
                                      if (zoneList.isNotEmpty && zoneList.contains(zones[i]))
                                      {
                                         zones.removeAt(i);
                                      }
                                    }

                                    return Container(
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              30),
                                      child: Container(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                            for (var item in zones)
                                              zoneAddWidget(item),
                                          ])
                                          //  child: _body(1),
                                          ),
                                    );
                                  } else {
                                    return Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Aucune zone trouvée', // 'Not Have Orders',
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
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'Aucune zone trouvée', // 'Not Have Orders',
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
                          )));
                });
          },
        ));
  }

  _body(deliversboy) {
    return ListView(
      padding: EdgeInsets.only(top: 0, left: 5, right: 5),
      children: [
        cardDeliverboy(deliversboy),
        zonesListWidget(),
        // addZoneBtn()
      ],
    );
  }

  Widget zonesListWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: 9, top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          FutureBuilder(
            future: _getzoneByDeliverBoyList,
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
                      Text('Aucune zone trouvée', // 'Not Have Orders',
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
                if (snapshot.data != null) {
                  zoneList = snapshot.data;
                  print('Length zoneyList :  ' + zoneList.length.toString());

                  if (zoneList != null) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 30),
                      child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                            //_body(deliverboyList)
                            for (var item in zoneList) zoneWidget(item),
                          ])
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
                        Text('Aucune zone trouvée', // 'Not Have Orders',
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
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text('Aucune zone trouvée', // 'Not Have Orders',
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
          )
        ],
      ),
    );
  }

  Widget zoneAddWidget(zone) {
    return Column(
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
              Icon(
                Icons.person_outline_sharp,
                color: Colors.black,
                size: 55,
              ),
              Text(
                zone.name,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.blue, size: 25),
                onPressed: () {
                  addZone(zone.id);
                },
              )
            ]),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget zoneWidget(zone) {
    return Column(
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
              Icon(
                Icons.person_outline_sharp,
                color: Colors.black,
                size: 55,
              ),
              Text(
                zone.name,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 25),
                onPressed: () {
                  suppressZone(zone.id);
                },
              )
            ]),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget cardDeliverboy(DeliverBoyModel _data) {
    //  print(_data.order.id);
    var status = '';
    var statusColor;

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
                      Icon(
                        Icons.person_outline_sharp,
                        color: Colors.black,
                        size: 55,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '  Livreur : ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
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
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      height: 20.0,
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
                          ]),
                    ]),
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
                                child: Text(
                                  'Agréer',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.teal),
                                ))),
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
                                child: Text('Rejeter',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red[800])))),
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
                                child: Text('En attente',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.orangeAccent)))),
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
                              child: Text('Bannir',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black)),
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
      onTap: () {},
    );
  }
}
