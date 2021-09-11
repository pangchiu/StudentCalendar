import 'package:app/component/color.dart';
import 'package:app/component/table_calendar.dart';
import 'package:app/app_data_base.dart';
import 'package:app/model/api_ictu.dart';
import 'package:app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentBottomBar = 0;
  bool showBottomBar = false;
  List<Task> events = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kAccentColorLight,
        body: FutureBuilder<List<Task>>(
            future: getAllEvent(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                events = snapshot.data!;
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  setState(() {
                    showBottomBar = true;
                  });
                });
                return Column(
                  children: [
                    buildCalendar(),
                  ],
                );
              } else {
                return Lottie.asset('images/cat_loader.json', repeat: true);
              }
            }),
        bottomNavigationBar: Visibility(
          child: buildBottomNavigationBar(),
          visible: showBottomBar,
        ),
      ),
    );
  }

  Widget buildCalendar() {
    return TableCalendar(
      events: events,
      focusedDay: DateTime.now(),
      startDay: DateTime(2020, 1, 1),
      endDay: DateTime(2022, 1, 1),
      view: ViewCalendar.week,
    );
  }

  Widget buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: kBackgroundColorDark, blurRadius: 1)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: kAccentColorLight),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              setState(() {
                currentBottomBar = index;
              });
            },
            currentIndex: currentBottomBar,
            items: [
              BottomNavigationBarItem(
                  label: 'home',
                  icon: SvgPicture.asset(
                    'images/home.svg',
                    width: 23,
                    height: 23,
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/home.svg',
                    color: kPrimaryBackgroundColor,
                    width: 24.5,
                    height: 24.5,
                  )),
              BottomNavigationBarItem(
                  label: 'remind',
                  icon: SvgPicture.asset(
                    'images/document_signed.svg',
                    width: 23,
                    height: 23,
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/document_signed.svg',
                    color: kPrimaryBackgroundColor,
                    width: 24.5,
                    height: 24.5,
                  )),
              BottomNavigationBarItem(
                  label: 'nofi',
                  icon: SvgPicture.asset(
                    'images/bell.svg',
                    width: 23,
                    height: 23,
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/bell.svg',
                    color: kPrimaryBackgroundColor,
                    width: 24.5,
                    height: 24.5,
                  )),
              BottomNavigationBarItem(
                  label: 'apps',
                  icon: SvgPicture.asset(
                    'images/apps.svg',
                    width: 23,
                    height: 23,
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/apps.svg',
                    color: kPrimaryBackgroundColor,
                    width: 24.5,
                    height: 24.5,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Task>> getAllEvent() async {
    var tasks = await AppDatabase.instance.allTask();
    if (tasks.isEmpty) {
      var schedule = await APIICTU.instance
          .getSchedule("DTC1854802010001", "c6dea4fca538c435f58b32dc7699c907");

      AppDatabase.instance.insetAll(schedule);

      schedule.forEach((element) {
        tasks.add(Task.fromJson(element));
      });
    }

    return tasks;
  }
}
