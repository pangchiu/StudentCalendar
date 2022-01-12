import 'package:app/app_data_base.dart';
import 'package:app/component/color.dart';
import 'package:app/model/task.dart';
import 'package:app/tab/home_tab.dart';
import 'package:app/tab/more_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  final List<Task>? events;

  const HomeScreen({this.events});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late int currentBottomBar;
  late bool showBottomBar;
  late Future<List<Task>> _futureTask;

  @override
  void initState() {
    super.initState();
    currentBottomBar = 0;
    showBottomBar = false;
    _futureTask = getEventsFromDB();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.events == null) {
      return Scaffold(
        body: FutureBuilder<List<Task>>(
          future: _futureTask,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!showBottomBar) {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  setState(() {
                    showBottomBar = true;
                  });
                });
              }
              if (snapshot.hasError) {
                return buildBody(currentBottomBar);
              } else {
                return buildBody(currentBottomBar, list: snapshot.data);
              }
            } else {
              if (showBottomBar) {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  setState(() {
                    showBottomBar = false;
                  });
                });
              }

              return Center(
                child: Container(
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
              );
            }
          },
        ),
        bottomNavigationBar:
            showBottomBar ? buildBottomNavigationBar(context) : null,
      );
    } else {
      return Scaffold(
        backgroundColor: kAccentColorLight,
        body: buildBody(currentBottomBar, list: widget.events),
        bottomNavigationBar: buildBottomNavigationBar(context),
      );
    }
  }

  Widget buildBody(int index, {List<Task>? list}) {
    switch (index) {
      case 0:
        return HomeTab(events: list ?? []);
      default:
        return MoreTab();
    }
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.075,
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
                  color: kTitleAccentTextColor,
                  width: size.width * 0.04,
                  height: size.width * 0.04,
                ),
                activeIcon: SvgPicture.asset(
                  'images/home.svg',
                  color: kPrimaryBackgroundColor,
                  width: size.width * 0.043,
                  height: size.width * 0.043,
                ),
              ),
              BottomNavigationBarItem(
                  label: 'more',
                  icon: SvgPicture.asset(
                    'images/align.svg',
                    color: kTitleAccentTextColor,
                    width: size.width * 0.04,
                    height: size.width * 0.04,
                  ),
                  activeIcon: SvgPicture.asset(
                    'images/align.svg',
                    color: kPrimaryBackgroundColor,
                    width: size.width * 0.045,
                    height: size.width * 0.045,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Task>> getEventsFromDB() async {
    return await AppDatabase.instance.allTask();
  }
}
