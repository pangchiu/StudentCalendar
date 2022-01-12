import 'package:app/component/table_calendar.dart';
import 'package:app/model/share_pref_memory.dart';
import 'package:app/model/task.dart';
import 'package:app/screen/loading.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  final List<Task> events;

  const HomeTab({required this.events});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late List<Task> list;

  @override
  void initState() {
    super.initState();
    setState(() {
      list = widget.events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          events: widget.events,
          focusedDay: DateTime.now(),
          startDay: DateTime.now().subtract(Duration(days: 365 * 3)),
          endDay: DateTime.now().add(Duration(days: 365 * 3)),
          view: ViewCalendar.week,
          onPressUpGrade: () async {
            String user = await SharePrefMemory.instance.getUser();
            String pass = await SharePrefMemory.instance.getPass();
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoadScreen(user: user, pass: pass)));
            });
          },
        )
      ],
    );
  }
}
