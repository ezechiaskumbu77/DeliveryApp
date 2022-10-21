import 'package:delivery_template/model/notification.dart';
import 'package:delivery_template/ressources/localeDB.dart';
import 'package:delivery_template/ui/login/setOtp.dart';
import 'package:delivery_template/ui/main/alldeliverCar.dart';
import 'package:delivery_template/ui/main/deliverboys.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/config/theme.dart';
import 'package:delivery_template/model/account.dart';
import 'package:delivery_template/model/pref.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ui/login/createaccount.dart';
import 'package:delivery_template/ui/login/forgot.dart';
import 'ui/login/login.dart';
import 'package:delivery_template/ui/main/mainscreen.dart';
import 'package:delivery_template/ui/main/orders.dart';
import 'package:delivery_template/ui/start/splash.dart';

import 'config/lang.dart';
import 'dart:async';
import 'package:delivery_template/ressources/getDeliverBoyApi.dart';

import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
//import 'package:firebase_core/firebase_core.dart';

//
// Theme
//
AppThemeData theme = AppThemeData();

//
// Language data
//
Lang strings = Lang();
//
// Account
//
Account account = Account();
Pref pref = Pref();

void main() {
  theme.init();
  strings.setLang(Lang.french); // set default language - English
  runApp(AppFoodDelivery());
}

class AppFoodDelivery extends StatefulWidget {
  @override
  _AppFoodDeliveryState createState() => _AppFoodDeliveryState();
}

class _AppFoodDeliveryState extends State<AppFoodDelivery> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
     //   _showNotificationItemDialog();
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
          shape:   RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
            borderRadius:   BorderRadius.circular(40.0),
          ),
          textColor: Colors.black,
          color: Colors.white,
          child:   Text(
            'D\'accord',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();

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
 void subscribtopic() {
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      print('deliverboy token main : '+token);
      var deliverboyID = '';

      final getdeliverboy = GetDeliverBoy();

      await getdeliverboy.getDeliverBoyID().then((value) {
        setState(() {
          deliverboyID = value;
        });

        print('deliverboy ID main : ' + deliverboyID);

        _firebaseMessaging.subscribeToTopic(deliverboyID);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _theme = ThemeData(
      fontFamily: 'Raleway',
      primarySwatch: theme.primarySwatch,
    );

    if (theme.darkMode) {
      _theme = ThemeData(
        fontFamily: 'Raleway',
        brightness: Brightness.dark,
        unselectedWidgetColor: Colors.white,
        primarySwatch: theme.primarySwatch,
      );
    }

    return MaterialApp(
      title: strings.get(10), // 'Food Delivery Flutter App UI Kit',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      initialRoute: '/splash',
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en'), const Locale('fr')],
      //initialRoute: '/main',
      routes: {
        '/splash': (BuildContext context) => SplashScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/forgot': (BuildContext context) => ForgotScreen(),
        '/createaccount': (BuildContext context) => CreateAccountScreen(),
        '/main': (BuildContext context) => MainScreen(),
        '/setotp': (BuildContext context) => SetOtp(),
        '/usersForDeliversCorp': (BuildContext context) =>  AllDeliverBoyScreen(),
        '/alldeliverCar': (BuildContext context) =>  AllDeliverCar(),
      },
    );
  }
}

saveInDB(String titre, String id, String date, String message) {
  var notilist;
  List<NotificationModel> nt = [];

  LocalDB db = LocalDB();
  db.check('noti').then((resp) {
    if (resp) {
      db.read('noti').then((data) {
        nt = NotificationModel.decode(data);
        nt.add(NotificationModel(
            id: id,
            title: titre,
            date: DateTime.now().toString(),
            orderID:
                'https://ppc-jhb-web.azureedge.net/website/attachments/cjucadneg0btv0fnowyp7rg8u-drc-products-420x257.full.png'));

        db.save('noti', NotificationModel.encode(nt));
      });
 
    } else {
      nt.add(NotificationModel(
          id: id,
          title: titre,
          date: DateTime.now().toString(),
          orderID:
              'https://ppc-jhb-web.azureedge.net/website/attachments/cjucadneg0btv0fnowyp7rg8u-drc-products-420x257.full.png'));

      db.save('noti', NotificationModel.encode(nt));
    }
  });
}

dprint(String str) {
 
  print(str);
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
     final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
     final dynamic notification = message['notification'];
  }

  // Or do other work.
}
