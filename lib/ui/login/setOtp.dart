import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';
import 'package:delivery_template/ui/widgets/ibox.dart';
import 'package:delivery_template/ui/widgets/ibutton.dart';
import 'package:delivery_template/ui/widgets/iinputField2.dart';
import 'package:delivery_template/ui/widgets/iinputField2Password.dart';
import '../../service/authservice.dart';

class SetOtp extends StatefulWidget {
  @override
  _SetOtpState createState() => _SetOtpState();
}

class _SetOtpState extends State<SetOtp>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //

  String errorMessage = '';
  _pressLoginButton() async {
    bool st =true ;
    print('User pressed \'LOGIN\' button');
    if(editControllerName.text.length < 6){
      st =false;
      setState(() {
        errorMessage ='Le code n\'est pas correct';
      });
    }
    AuthService auth = AuthService();

    //print('Login: ${editControllerName.text}, password: ${editControllerPassword.text}');
    String code = editControllerName.text;



   if(st){
     bool isLogin = await  auth.authPhone(code);
     if(isLogin && st ) {

       Navigator.pushNamedAndRemoveUntil(context, '/main', (r) => false);
     } else  {
       setState(() {
         errorMessage =strings.get(156);
       });
     }

   }

  }

  _pressDontHaveAccountButton(){
    print('User press \'Don\'t have account\' button');
    Navigator.pushNamed(context, '/createaccount');
  }

  _pressForgotPasswordButton(){
    print('User press \'Forgot password\' button');
    Navigator.pushNamed(context, '/forgot');
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
    errorMessage =' ';
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
          child: Text('Vérification OTP',                        // 'Let's start with LogIn!'
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

                      hint: 'Entrez le code',            // 'Login'
                      icon: Icons.security,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog,
                      controller: editControllerName,
                      type: TextInputType.number
                    )
                ),
                SizedBox(height: 10,),
                // Container(
                //     margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                //     child: IInputField2Password(
                //       hint: strings.get(15),            // 'Password'
                //       icon: Icons.vpn_key,
                //       colorDefaultText: theme.colorPrimary,
                //       colorBackground: theme.colorBackgroundDialog,
                //       controller: editControllerPassword,
                //     )),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: IButton(pressButton: _pressLoginButton, text: 'Continuer', // LOGIN
                    color: theme.colorPrimary,
                    textStyle: theme.text16boldWhite,),
                ),
                SizedBox(height: 15,),
                Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Text(errorMessage, style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),

                  ],
                ),


                SizedBox(height: 15,),

              ],
            )
        ),

      ],
    );
  }

}