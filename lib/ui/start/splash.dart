import 'dart:async';
import 'package:delivery_template/service/UserData.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  ////////////////////////////////////////////////////////////////
  //
  //
  //
  _startNextScreen(){
    Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
  }
  _startMain() {
    Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
  }

  //
  //
  ////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;

  UserData userD;

  @override
  void initState() {
    pref.init();
    super.initState();

    userD = UserData();

    userD.isAuth().then((value) {
      print("see the value $value");
      if(value) {
        startTime(_startMain());
      } else {
        startTime(_startNextScreen());
      }

    });
    //startTime();
  }

  startTime(Function fn) async {
    var duration = new Duration(seconds: 3);
    return Timer(duration, fn);
  }



  // startTime() async {
  //   var duration = new Duration(seconds: 3);
  //   return Timer(duration, _startNextScreen);
  // }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: initScreen(context),
    );

  }

  initScreen(BuildContext context) {

    return Scaffold(
        body: Stack(
          children: <Widget>[

            Container(
              color: theme.colorBackground,
            ),

            IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "SplashLogo",
                    child: Container(
                      width: windowWidth*0.3,
                      child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  CircularProgressIndicator(
                    backgroundColor: theme.colorCompanion4,
                    strokeWidth: 1,
                  )
                ],
              ),
            ),


          ],
        )

    );
  }

}


