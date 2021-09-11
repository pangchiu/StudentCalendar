import 'package:app/component/color.dart';
import 'package:app/component/text_filed_container.dart';
import 'package:app/screen/loading.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              //build logo
              Container(
                height: size.height * 0.4,
                width: size.width * 0.8,
                child: Column(
                  children: [
                    Image.asset(
                      'images/logo2.png',
                      fit: BoxFit.fill,
                      color: kPrimaryBackgroundColor,
                    ),
                    Text('Student Calendar',
                        style: TextStyle(
                            fontFamily: 'Montserrat-Bold', fontSize: 30))
                  ],
                ),
              ),
              //build user
              TextFiledContainer(
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'Montserrat-Medium'),
                  decoration: InputDecoration(border: InputBorder.none),
                  cursorColor: kPrimaryColorDark,
                ),
                label: Text(
                  'Mã sinh viên',
                  style: TextStyle(
                      fontFamily: 'Montserrat-Medium',
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                color: kBackgroundColorDark,
              ),
              SizedBox(height: size.height * 0.04),
              // bulid password
              TextFiledContainer(
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'Montserrat-Medium'),
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  cursorColor: kPrimaryColorDark,
                 
                ),
                label: Text(
                  'Mật khẩu',
                  style: TextStyle(
                      fontFamily: 'Montserrat-Medium',
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                color: kBackgroundColorDark,
                icon: IconButton(
                  icon: _isObscure
                      ? Icon(Icons.visibility, color: kAccentColorDark)
                      : Icon(Icons.visibility_off, color: kAccentColorDark),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
              SizedBox(height: size.height * 0.08),
              // build login button
              Container(
                height: size.height * 0.08,
                width: size.width,
                decoration: BoxDecoration(
                  color: kPrimaryBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadScreen(),
                        ));
                  },
                  child: Text('ĐĂNG NHẬP',
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w500)),
                  textColor: kAccentColorLight,
                ),
              ),
              SizedBox(height: size.height * 0.013),
              Text('Made by Minh',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat-Medium',
                      fontWeight: FontWeight.w100,
                      decoration: TextDecoration.underline))
            ],
          ),
        ),
      ),
    );
  }
}
