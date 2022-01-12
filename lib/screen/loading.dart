import 'package:app/app_data_base.dart';
import 'package:app/component/color.dart';
import 'package:app/model/api_ictu.dart';
import 'package:app/model/task.dart';
import 'package:app/model/share_pref_memory.dart';
import 'package:app/screen/home.dart';
import 'package:app/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadScreen extends StatefulWidget {
  final String user;
  final String pass;

  const LoadScreen({required this.user, required this.pass});

  @override
  LoadScreenState createState() => LoadScreenState();
}

class LoadScreenState extends State<LoadScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getAllEvents().then((data) async {
      // lưu thông tin đăng nhập vào sharePrerencet
      if ((await SharePrefMemory.instance.isLogin ?? false) == false) {
        await SharePrefMemory.instance.onLoginInfor();
        await SharePrefMemory.instance.onUserInfor(widget.user);
        await SharePrefMemory.instance.onPassInfor(widget.pass);
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    events: data,
                  )));
    }).catchError((onError) async {
      bool logined = (await SharePrefMemory.instance.isLogin) ?? false;
      if (logined) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      events: [],
                    )));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen(
            isError: true,
          );
        }));
      }
    });
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          children: [
            Container(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                color: kPrimaryColorDark,
                backgroundColor: kBackgroundColorDark,
                strokeWidth: 5,
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> onLoginInfor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onLogin', true);
  }

  Future<List<Task>> getAllEvents() async {
    // lấy data cơ sở dữ liệu
    List<Task> tasks = await AppDatabase.instance.allTask();

    // lấy api lịch học
    var schedule = await APIICTU.instance.getSchedule(widget.user, widget.pass);

    if (schedule.isNotEmpty) {
      // xóa toàn bộ cơ sở dữ liệu
      await AppDatabase.instance.deleteAll();

      //chèn cơ sở dũ liệu mới
      await AppDatabase.instance.insetAll(schedule);

      // xóa nơi lưu tạm cơ sở dữ liệu
      tasks.clear();

      schedule.forEach((element) {
        tasks.add(Task.fromJson(element));
      });
    }

    return tasks;
  }
}
