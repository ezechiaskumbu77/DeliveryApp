import 'package:delivery_template/models/user.dart';
import 'package:delivery_template/ressources/getDeliverBoyApi.dart';
import 'package:delivery_template/ressources/getDeliverCorpApi.dart';
import 'package:delivery_template/ressources/localeDB.dart';
import 'package:delivery_template/service/UserData.dart';
import 'package:delivery_template/ui/main/deliverboys.dart';
import 'package:delivery_template/ui/main/statistics.dart';
import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/order.dart';
import 'package:delivery_template/ui/main/account.dart';
import 'package:delivery_template/ui/main/header.dart';
import 'package:delivery_template/ui/main/map.dart';
import 'package:delivery_template/ui/main/notifications.dart';
import 'package:delivery_template/ui/main/orders.dart';
import 'package:delivery_template/ui/menu/help.dart';
import 'package:delivery_template/ui/menu/language.dart';
import 'package:delivery_template/ui/main/orderdetails.dart';
import 'package:delivery_template/ui/menu/menu.dart';

import 'customerservice.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //

  _openMenu() {
    print('Open menu');
    setState(() {
      _scaffoldKey.currentState.openDrawer();
    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _currentPage = 'orders';
  Map<String, dynamic> _params = {};

  UserData uudata = UserData();
  UserModel uu;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String isDeliverCorp = 'false';

  initializing() async {
    final db = LocalDB();

    await db.read('isDeliverCorp').then((val) {
      setState(() {
        isDeliverCorp = val.toString();
      });

      if (isDeliverCorp == 'true') {
        setState(() {
          _currentPage = 'deliverboys';
        });
      }
      print('fffffff' + isDeliverCorp);
    });
  }

  @override
  void initState() {
    initializing();
    super.initState();
    _initDistance();
    account.setRedraw(_redraw);
    super.initState();

    uudata.getUser().then((value) {
      uu = value;
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        // _showNotificationItemDialog();
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

    subscribtopic();
  }

  void subscribtopic() {
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      print('deliverboy token mainscreen : ' + token);
      
     
      if(isDeliverCorp=='true'){  
        var delivercorpID = '';
         final getdelivercorp = GetDeliverCorp();

          await getdelivercorp.getDeliverCorpID().then((value) {
            setState(() {
              delivercorpID = value;
            });

            print('delivercorp ID maiscreen : ' + delivercorpID);

            _firebaseMessaging.subscribeToTopic(delivercorpID);
          });

      }else{
        
          var deliverboyID = '';
          final getdeliverboy = GetDeliverBoy();

          await getdeliverboy.getDeliverBoyID().then((value) {
            setState(() {
              deliverboyID = value;
            });

            print('deliverboy ID maiscreen : ' + deliverboyID);

            _firebaseMessaging.subscribeToTopic(deliverboyID);
          });

      }
    });
  }

  Widget _buildDialog(BuildContext context) {
 
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
            //  Navigator.of(context).pop();

            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => OrdersScreen()));
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

  _initDistance() async {
    await ordersSetDistance();
    setState(() {});
  }

  _redraw() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    var _headerText = strings.get(21); //
    switch (_currentPage) {
      case 'statistics':
        _headerText = strings.get(79); // 'Statistics',
        break;
      case 'orderDetails':
        _headerText = strings.get(56); // 'Order Details',
        break;
      case 'map':
        _headerText = strings.get(89); // 'Map',
        break;
      case 'language':
        _headerText = strings.get(28); // 'Languages',
        break;
      case 'account':
        _headerText = strings.get(27); // 'Account',
        break;
      case 'help':
        _headerText = strings.get(38); // 'Help & support',
        break;
      case 'notification':
        _headerText = strings.get(25); // 'Notifications',
        break;
      case 'orders':
        _headerText = strings.get(24); // 'Orders',
        break;
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(context: context, callback: routes, userL: uu),
      backgroundColor: theme.colorBackground,
      body: Stack(
        children: <Widget>[
          if (_currentPage == 'statistics') StatisticsScreen(callback: routes),
          if (_currentPage == 'orderDetails') OrdersDetailsScreen(),
          if (_currentPage == 'map')
            MapScreen(
              callback: routes,
              params: _params,
            ),
          if (_currentPage == 'language') LanguageScreen(),
          if (_currentPage == 'account')
            AccountScreen(callback: routes, userL: uu),
          if (_currentPage == 'help') 
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomerServicePage())),
            CustomerServicePage(),
          if (_currentPage == 'notification')
            AllNotificationScreen(unreadNotifs: null),
          if (_currentPage == 'deliverboys') AllDeliverBoyScreen(),
          if (_currentPage == 'orders') OrdersScreen(callback: routes2),
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Header(
                  title: _headerText,
                  onMenuClick: _openMenu,
                  callback: routes)),
        ],
      ),
    );
  }

  routes(String route) {
    if (route != 'redraw') _currentPage = route;
    setState(() {});
  }

  routes2(String route, Map<String, dynamic> params) {
    _params = params;
    if (route != 'redraw') _currentPage = route;
    setState(() {});
  }
}
