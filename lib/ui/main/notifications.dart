import 'dart:async';
import 'dart:ui';
 
import 'package:delivery_template/model/notification.dart';
import 'package:delivery_template/models/deliveryboy.dart'; 
import 'package:delivery_template/ressources/getNotificationsApi.dart'; 
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart'; 
class AllNotificationScreen extends StatefulWidget {
  final unreadNotifs;
  AllNotificationScreen({this.unreadNotifs});

  @override
  _AllNotificationScreenState createState() => _AllNotificationScreenState();
}

class _AllNotificationScreenState extends State<AllNotificationScreen>
    with TickerProviderStateMixin {
  ///////////////////////////////////////////////////////////////////////////////
  //

  get notification => null;

  //
  ///////////////////////////////////////////////////////////////////////////////

  var _myF;
  GetNotification getNotification;

  double windowWidth = 0.0;
  double windowHeight = 0.0;

  @override
  void initState() {
    getNotification = GetNotification();

    _myF = getNotification.fetchAll();
    getNotification.updateReadState(widget.unreadNotifs);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _myF = getNotification.fetchAll();

    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          title: Text('Notifications',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900)),
        ),
        body: FutureBuilder(
          future: _myF,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.done) {
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
              List<NotificationModel> notificationList;
              if (snapshot.data != null) {
                notificationList = snapshot.data;
                print('Length notificationList :  ' +
                    notificationList.length.toString());
                return Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 30),
                  child: Container(
                    child: _body(notificationList),
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
                    Text('Aucun Notification', // 'Not Have Orders',
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

  _body(List<NotificationModel> deliversboy) {
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

  _body2(List<NotificationModel> deliversboys) {
    var list = <Widget>[];

    for (var _data in deliversboys) {
      //orderppc = _data;
      list.add(cardNotification(_data));
    }

    return list;
  }

  Widget cardNotification(NotificationModel _data) {
    //  print(_data.order.id);
    var status = '';
    var statusColor;

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
                      Icon(
                        Icons.person_outline_sharp,
                        color: Colors.black,
                        size: 55,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('  ' + _data.title.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 8,
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        _data.body,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        _data.date.substring(0, 11),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ))
                                ])
                          ]),
                    ]),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )),
      onTap: () {
        /* Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => OrdersDetailsScreen(notification: notification)));*/
      },
    );
  }
}
