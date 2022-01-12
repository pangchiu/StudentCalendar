import 'package:app/component/color.dart';
import 'package:app/component/text_filed_container.dart';
import 'package:app/model/share_pref_memory.dart';
import 'package:app/screen/loading.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final bool? isError;

  LoginScreen({this.isError});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  bool _isSave = false;
  late TextEditingController textPassController;
  late TextEditingController textUserController;
  @override
  void initState() {
    super.initState();


    // lấy tài khoản
    SharePrefMemory.instance.getUser().then((value) {
      setState(() {
        textUserController = TextEditingController(text: value);
      });
    });

    // lấy mật khẩu
    SharePrefMemory.instance.getPass().then((value) {
      setState(() {
        textPassController = TextEditingController(text: value);
      });
    });

    textUserController = TextEditingController();
    textPassController = TextEditingController();

    SharePrefMemory.instance.isSaveInfor().then((value){
      setState(() {
        _isSave = value ?? false;
      });
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.isError == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Đăng nhập không thành công!",
              style: TextStyle(
                  fontFamily: 'Montserrat-Medium',
                  fontSize: 15,
                  fontWeight: FontWeight.w400)),
          backgroundColor: kPrimaryBackgroundColor,
          
        ));
      }
    });
  }

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
                  controller: textUserController,
                  style:
                      TextStyle(fontSize: 15, fontFamily: 'Montserrat-Medium'),
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
                  controller: textPassController,
                  style:
                      TextStyle(fontSize: 15, fontFamily: 'Montserrat-Medium'),
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
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                        value: _isSave,
                        activeColor: kPrimaryBackgroundColor,
                        onChanged: (save) async {
                          //nếu chọn lưu mật khẩu thì lưu mật khẩu và tài khoản cho lần đăng nhập sau
                          await SharePrefMemory.instance.onSaveInfor(save!);
                          setState(() {
                            _isSave = save;
                          });
                        }),
                  ),
                  Text('Lưu tài khoản và mật khẩu.',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Montserrat-Medium',
                          fontWeight: FontWeight.w400)),
                ],
              ),
              SizedBox(height: size.height * 0.05),
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
                          builder: (context) => LoadScreen(
                            user: textUserController.text.trim(),
                            pass: textPassController.text.trim(),
                          ),
                        ));
                  },
                  child: Text('ĐĂNG NHẬP',
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w500,
                          color: kAccentColorLight)),
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
