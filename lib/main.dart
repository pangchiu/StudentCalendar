import 'package:app/model/share_pref_memory.dart';
import 'package:app/screen/home.dart';
import 'package:app/screen/login.dart';
import 'package:app/screen/onboarding.dart';
import 'package:flutter/material.dart';


bool? isViewed; // biến trạng thái nên xem onBorading

bool? isLogin; //biến trạng thái xem đã đăng nhập hay chưa



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  isViewed = await SharePrefMemory.instance.isViewedBoard;
  isLogin = await SharePrefMemory.instance.isLogin;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isViewed != true
          ? Onboarding()
          : isLogin == true
              ? HomeScreen()
              : LoginScreen(),
    );
  }
}
