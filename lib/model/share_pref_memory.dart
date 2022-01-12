import 'package:shared_preferences/shared_preferences.dart';

class SharePrefMemory {

  SharePrefMemory._();

  static final SharePrefMemory instance = SharePrefMemory._();


  get isLogin async =>  (await SharedPreferences.getInstance()).getBool('onLogin');

  get isViewedBoard async =>  (await SharedPreferences.getInstance()).getBool('onBoard');

  Future <dynamic> isSaveInfor() async{
    return (await SharedPreferences.getInstance()).getBool('save');

  }


  Future <dynamic> getUser() async{
    return (await SharedPreferences.getInstance()).getString('user');

  }


  Future <dynamic> getPass() async{
    return (await SharedPreferences.getInstance()).getString('pass');

  }
  
  Future<void> onUserInfor( String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', text);
  }

  Future<void> onPassInfor(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('pass', text);

  }

  Future<void> onLoginInfor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onLogin', true);
  }

  Future<void> onBoardingInfor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onBoard', true);
  }
 
  Future<void> onSignOutInfor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool save = prefs.getBool('save') ?? false;
    if(save == false){
      prefs.remove('pass');
      prefs.remove('user');
      prefs.remove('save');
    }
    prefs.remove('onLogin');
  }


  Future<void> onSaveInfor( bool save) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(save) {
      prefs.setBool('save', save);
    }
    else {
      prefs.remove('save');
    }
  }
}
