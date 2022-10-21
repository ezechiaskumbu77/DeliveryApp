import 'package:delivery_template/models/user.dart';
import '../../ui/login/createaccount.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';
import 'package:delivery_template/ui/widgets/ibox.dart';
import 'package:delivery_template/ui/widgets/ibutton.dart';
import 'package:delivery_template/ui/widgets/iinputField2.dart';
// import 'package:delivery_template/ui/widgets/iinputField2Password.dart';
import 'package:delivery_template/service/authservice.dart';

class CreatePhone extends StatefulWidget {
  @override
  _CreatePhoneState createState() => _CreatePhoneState();
}

class _CreatePhoneState extends State<CreatePhone>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //

  String errorMessage = '';
  _pressLoginButton() async {
    bool st =true ;
    print('User pressed \'LOGIN\' button');
    if (editControllerName.text.isEmpty || editControllerName.text.length< 9 ) {
      st =false;
      setState(() {
        errorMessage = 'Le numéro est incorrect';
      });

    } else {
      setState(() {
        errorMessage = '';
      });
    }

    AuthService auth = AuthService();


    String phone = '+243'+editControllerName.text;



   if(st){
     var respond = await  auth.createPhone(phone);
     if(!respond['error'] && st && respond['success'] && respond['find']) {

       Navigator.pushNamed(context,'/setotp');
     } else if( respond['success'])   {

       UserModel user = UserModel(phone: phone);

       Navigator.of(context).push(
         MaterialPageRoute(
           builder: (context) => CreateAccountScreen( user: user,)
         )
       );



     //  Navigator.pushNamed(context, '/createaccount');

       // setState(() {
       //   errorMessage ='Le numéro n'est pas enregistré';
       // });
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
          child: Text('Entrez votre numéro de téléphone'    ,                    // 'Let's start with LogIn!'
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
                      code: '+243',
                      hint: 'Numéro de téléphone',            // 'Login'
                      icon: Icons.phone,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog,
                      controller: editControllerName,
                      type: TextInputType.emailAddress
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