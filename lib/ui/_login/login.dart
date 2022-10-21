import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';
import 'package:delivery_template/ui/widgets/ibox.dart';
import 'package:delivery_template/ui/widgets/ibutton.dart';
import 'package:delivery_template/ui/widgets/iinputField2.dart';
import 'package:delivery_template/ui/widgets/iinputField2Password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _pressLoginButton(){
    print("User pressed \"LOGIN\" button");
    print("Login: ${editControllerName.text}, password: ${editControllerPassword.text}");
    Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
  }

  _pressDontHaveAccountButton(){
    print("User press \"Don't have account\" button");
    Navigator.pushNamed(context, "/createaccount");
  }

  _pressForgotPasswordButton(){
    print("User press \"Forgot password\" button");
    Navigator.pushNamed(context, "/forgot");
  }
  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.colorBackground,

      body: Stack(
        children: <Widget>[

          IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

           Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, windowHeight*0.1),
                  width: windowWidth,
                  child: _body(),
                  )
           ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      _pressDontHaveAccountButton();
                    }, // needed
                    child:Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                      child: Text(strings.get(11),                    // ""Don't have an account? Create",",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: theme.text16boldWhite
                      ),
                    )),
                InkWell(
                    onTap: () {
                      _pressForgotPasswordButton();
                    }, // needed
                    child:Container(
                      padding: EdgeInsets.all(20),
                      child: Text(strings.get(12),                    // "Forgot password",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: theme.text16boldWhite
                      ),
                    ))
              ],
            ),
          ),


        ],
      ),
    );
  }

  _body(){
    return ListView(
      shrinkWrap: true,
      children: <Widget>[

        Container(
          margin: EdgeInsets.only(left: 15, right: 20),
          alignment: Alignment.centerLeft,
          child: Text(strings.get(13),                        // "Let's start with LogIn!"
              style: theme.text20boldWhite
          ),
        ),
        SizedBox(height: 20,),

        IBox(
            color: theme.colorBackgroundDialog,
            child: Column(
              children: <Widget>[
                SizedBox(height: 15,),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2(
                      hint: strings.get(14),            // "Login"
                      icon: Icons.alternate_email,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog,
                      controller: editControllerName,
                      type: TextInputType.emailAddress
                    )
                ),
                SizedBox(height: 10,),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2Password(
                      hint: strings.get(15),            // "Password"
                      icon: Icons.vpn_key,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog,
                      controller: editControllerPassword,
                    )),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: IButton(pressButton: _pressLoginButton, text: strings.get(16), // LOGIN
                    color: theme.colorPrimary,
                    textStyle: theme.text16boldWhite,),
                ),
                SizedBox(height: 15,),
              ],
            )
        ),

      ],
    );
  }

}