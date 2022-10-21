import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:delivery_template/main.dart';
import 'package:delivery_template/models/user.dart';
import 'package:delivery_template/service/authservice.dart';
import 'package:delivery_template/ui/widgets/iappBar.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';
import 'package:delivery_template/ui/widgets/ibox.dart';
import 'package:delivery_template/ui/widgets/ibutton.dart';
import 'package:delivery_template/ui/widgets/iinputField2.dart';
// ignore: unused_import
import 'package:delivery_template/ui/widgets/iinputField2Password.dart';

class CreateAccountScreen extends StatefulWidget {
  UserModel user;

  CreateAccountScreen({Key key, this.user}) : super(key: key);
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  String _sexe = 'M';

  DateTime selectedDate = DateTime.now();
  _pressCreateAccountButton() async {
    if (editControllerName.text.isEmpty || editControllerAddress.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Noms , adresse et date de naissance ne doivent pas être vide',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      widget.user.address = editControllerAddress.text;
      widget.user.sexe = _sexe;
      widget.user.name = editControllerName.text;
      widget.user.birthday = choseDate;
      print('see your date ${widget.user.birthday}');

      AuthService auth = AuthService();

      bool isLogin = await auth.create(widget.user);
      if (isLogin) {
        Navigator.pushNamed(context, '/setotp');
      }
    }

    //Navigator.pushNamedAndRemoveUntil(context, '/main', (r) => false);
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  String choseDate = 'Choisir la date';
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerSexe = TextEditingController();
  final editControllerAddress = TextEditingController();
  //final editControllerPassword2 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerSexe.dispose();
    editControllerAddress.dispose();
    //  editControllerPassword2.dispose();
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
          IBackground4(
              width: windowWidth, colorsGradient: theme.colorsGradient),
          IAppBar(context: context, text: '', color: Colors.white),
          Center(
              child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            width: windowWidth,
            child: _body(context),
          )),
        ],
      ),
    );
  }

  _body(context) {
    
    _selectDate(BuildContext context) async {
      final picked = await showDatePicker(
        locale: const Locale('fr', 'FR'),
        context: context,
        initialDate: selectedDate, // Refer step 1
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().year + 1),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: Colors.red,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.red,
            ),
            child: child,
          );
        },
      );
      if (picked != null && picked != selectedDate)
        // ignore: curly_braces_in_flow_control_structures
        setState(() {
          selectedDate = picked;
          choseDate = picked.toLocal().toString().split(' ')[0];
        });
    }

    dataPicker() {
      return Container(
        padding: EdgeInsets.only(left: 25),
        child: Row(
          children: <Widget>[
            Text(
              //'${selectedDate.toLocal()}'.split(' ')[0],
              'Date de Naissance : ',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            RaisedButton(
              onPressed: () => _selectDate(context), // Refer step 3
              child: Text(
                choseDate,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              color: Colors.red,
            ),
          ],
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.centerLeft,
          child: Text(strings.get(20), // 'Create an Account!'
              style: theme.text20boldWhite),
        ),
        SizedBox(
          height: 20,
        ),
        IBox(
            color: theme.colorBackgroundDialog,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2(
                      hint: 'Noms', // 'Login'
                      icon: Icons.attribution_sharp,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog,
                      controller: editControllerName,
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2(
                      hint: 'Adresse', // 'E-mail address',
                      icon: Icons.add_location_alt,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog,
                      controller: editControllerAddress,
                    )),
                SizedBox(
                  height: 10,
                ),
                dataPicker(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 40),
                        child: Text(
                          'Sexe  :  ',
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        )),
                    DropdownButton(
                        value: _sexe,
                        items: [
                          DropdownMenuItem(
                            child: Text('Homme',
                                style: TextStyle(
                                  color: Colors.red,
                                )),
                            value: 'M',
                          ),
                          DropdownMenuItem(
                            child: Text('Femme',
                                style: TextStyle(
                                  color: Colors.red,
                                )),
                            value: 'F',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _sexe = value;
                            print('sexe ${_sexe}');
                          });
                        }),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: IButton(
                    pressButton: _pressCreateAccountButton,
                    text: strings.get(23), // CREATE ACCOUNT
                    color: theme.colorPrimary,
                    textStyle: theme.text16boldWhite,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            )),
      ],
    );
  }
}
