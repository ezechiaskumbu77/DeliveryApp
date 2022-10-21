import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/pref.dart';

class Account{

  String userName = 'Stephane kabongo';
  String email = 'stephaneK@gmail.com';
  String phone = '+243 8996374849';
  String userAvatar = 'https://scontent-ams4-1.xx.fbcdn.net/v/t1.0-9/80272607_2670629493020780_503493995293310976_o.jpg?_nc_cat=107&_nc_sid=84a396&_nc_ohc=36Vvf8uN2-YAX-URHNo&_nc_ht=scontent-ams4-1.xx&oh=7ef0cce5990b3a7e036dfba24938651d&oe=5FA08B97';
  String token = '';

  int notifyCount = 6;
  String currentOrder = '';
  String openOrderOnMap = '';
  String backRoute = '';

  bool _initUser = true;

  okUserEnter(String name, String password, String avatar, String _email, String _token){
    _initUser = true;
    userName = name;
    userAvatar = avatar;
    email = _email;
    token = _token;
    pref.set(Pref.userEmail, _email);
    pref.set(Pref.userPassword, password);
    pref.set(Pref.userAvatar, avatar);
    dprint('User Auth! Save email=$email pass=$password');
  }

  logOut(){
//    _initUser = false;
//    pref.clearUser();
//    userName = '';
//    userAvatar = '';
//    email = '';
//    token = '';
  }

  isAuth(){
    return _initUser;
  }

  Function _redrawMainWindow;

  setRedraw(Function callback){
    _redrawMainWindow = callback;
  }

  redraw(){
    if (_redrawMainWindow != null)
      _redrawMainWindow();
  }

}
