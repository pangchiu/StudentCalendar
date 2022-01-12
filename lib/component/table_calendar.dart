import 'package:app/component/color.dart';
import 'package:app/component/expanded_page_view.dart';
import 'package:app/component/item_day.dart';
import 'package:app/component/list_task.dart';
import 'package:app/component/small_button.dart';
import 'package:app/component/small_item_day.dart';
import 'package:app/model/calendar.dart';
import 'package:app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ViewCalendar { week, month }

class TableCalendar extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime startDay;
  final DateTime endDay;
  final ViewCalendar view;
  final List<dynamic>? events;
  final List<dynamic> Function(DateTime day)? eventLoader;
  final void Function()? onPressUpGrade;

  TableCalendar(
      {required this.focusedDay,
      required this.startDay,
      required this.endDay,
      this.view = ViewCalendar.week,
      this.eventLoader,
      this.events,
      this.onPressUpGrade});

  @override
  TableCalendarState createState() => TableCalendarState();
}

class TableCalendarState extends State<TableCalendar> {
  late PageController controllerMonth;
  late PageController controllerWeek;
  late PageController controllerDay;
  late DateTime currentDayOfPage; // Ngày trong trang tuần và tháng hiện tại
  late DateTime previousDayOfPage; // Ngày trong trang tuần và tháng trước đó
  late DateTime selectedDay; // ngày đang chọn hiện tại
  late bool isExpanded; // hiển thị lịch tuần hay tháng
  late List<DateTime> months; // danh sách các tháng trong lịch
  late List<DateTime> weeks; // danh sách thứ 2 các tuần trong lịch
  late List<DateTime> days;
  @override
  void initState() {
    super.initState();
    prepareInit();
  }

  @override
  void dispose() {
    controllerMonth.dispose();
    controllerWeek.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          buildAppBar(),
          buildView(),
          buildDivider(),
          buildWatchEvent()
        ],
      ),
    );
  }

  Widget buildWatchEvent() {
    return Expanded(
      child: Container(
        color: kBackgroundColorLight,
        child: ListEvent(
          focusedDay: formatDate(widget.focusedDay),
          days: days,
          controller: controllerDay,
          endDay: widget.endDay,
          selectedDay: selectedDay,
          startDay: widget.startDay,
          events: widget.events,
        ),
      ),
    );
  }

  Widget buildAppBar() {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: kBackgroundColorLight,
      height: size.height / 7,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: size.height / 8,
                  child: FittedBox(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('${selectedDay.day}',
                            style: TextStyle(
                                fontFamily: 'Montserrat-Bold',
                                fontWeight: FontWeight.w100,
                                fontSize: 50)),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text('${convertWeekend(selectedDay)}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-Medium',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text('${convertDate(selectedDay)}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-Medium',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: kPrimaryColorDark)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SmallButton(
                  child: Text(
                    '${widget.focusedDay.day}',
                    style: TextStyle(fontSize: 12, color: kAccentColorLight),
                  ),
                  icon: SvgPicture.asset(
                    'images/day.svg',
                    color: kAccentColorLight,
                  ),
                  color: kPrimaryBackgroundColor,
                  onPressed: () {
                    setState(() {
                      selectedDay = formatDate(widget.focusedDay);
                      currentDayOfPage = selectedDay;
                    });
                    jumpToPageCalendar(selectedDay);
                  },
                ),
                SmallButton(
                  icon: isExpanded
                      ? SvgPicture.asset(
                          'images/calendar.svg',
                          color: kAccentColorLight,
                        )
                      : SvgPicture.asset(
                          'images/calendar_collapse.svg',
                          color: kAccentColorLight,
                        ),
                  color: kPrimaryColorDark,
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                    // nhảy đến ngày đang  chọn
                    jumpToPageCalendar(selectedDay);
                  },
                ),
                SmallButton(
                  icon: SvgPicture.asset(
                    'images/refresh.svg',
                    color: kAccentColorLight,
                  ),
                  color: kSecondaryColorDark,
                  onPressed: widget.onPressUpGrade ??  (){},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildView() {
    if (isExpanded) {
      return buildMonthView();
    } else {
      return buildWeekView();
    }
  }

  Widget buildDivider() {
    return Divider(
      height: 1,
      color: kPrimaryBackgroundColor,
      thickness: 2,
    );
  }

  Widget buildMonthView() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: kAccentColorLight,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: ExpandedPageView(
        pageController: controllerMonth,
        itemCount: months.length,
        itemBuilder: (context, index) {
          int pagePos = monthPageOf(currentDayOfPage);
          int factor; // hệ số để quy định chiều xuất hiện hiệu ứng
          if (isScrollLeft(pagePos, index)) {
            factor = 1;
          } else if (isScrollRight(pagePos, index)) {
            factor = -1;
          } else {
            if (currentDayOfPage.isAfter(previousDayOfPage)) {
              factor = 1;
            } else
              factor = -1;
          }
          if (pagePos * factor > index * factor) {
            return buildItemMonth(index);
          } else if (pagePos * factor < index * factor) {
            return Transform.translate(
              offset: Offset(screenWidth * factor, 0),
              child: buildItemMonth(index),
            );
          } else {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: screenWidth),
              duration: Duration(milliseconds: 300),
              builder: (_, value, child) => Transform.translate(
                offset: Offset((screenWidth - value) * factor, 0),
                child: buildItemMonth(index),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildItemMonth(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            buildTitle('T2'),
            buildTitle('T3'),
            buildTitle('T4'),
            buildTitle('T5'),
            buildTitle('T6'),
            buildTitle('T7'),
            buildTitle('CN')
          ]),
          Table(
              children: getTableMonth(months[index].year, months[index].month)),
        ],
      ),
    );
  }

  Widget buildWeekView() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 8,
      child: Container(
        decoration: BoxDecoration(
          color: kAccentColorLight,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: PageView.builder(
          controller: controllerWeek,
          itemCount: weeks.length,
          itemBuilder: (context, index) {
            int pagePos = weekPageOf(currentDayOfPage);
            int factor; // hệ số để quy định chiều xuất hiện hiệu ứng
            if (isScrollLeft(pagePos, index)) {
              factor = 1;
            } else if (isScrollRight(pagePos, index)) {
              factor = -1;
            } else {
              if (currentDayOfPage.isAfter(previousDayOfPage)) {
                factor = 1;
              } else
                factor = -1;
            }
            if (pagePos * factor > index * factor) {
              return buildItemWeek(size, index);
            } else if (pagePos * factor < index * factor) {
              return Transform.translate(
                offset: Offset(size.width * factor, 0),
                child: buildItemWeek(size, index),
              );
            } else {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: size.width),
                duration: Duration(milliseconds: 300),
                builder: (_, value, child) => Transform.translate(
                  offset: Offset((size.width - value) * factor, 0),
                  child: buildItemWeek(size, index),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildItemWeek(Size size, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: Table(
          children: [
            getTableWeek(
                weeks[index].year, weeks[index].month, weeks[index].day)
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Text(
        '$title',
        style: TextStyle(
          color: kPrimaryBackgroundColor,
          fontFamily: 'Montserrat-Bold',
          fontSize: 15,
        ),
      ),
    );
  }

  void prepareInit() {
    weeks = Calendar.fillWeek(widget.startDay, widget.endDay);
    months = Calendar.fillMonth(widget.startDay, widget.endDay);
    days = Calendar.fillDays(widget.startDay, widget.endDay);
    isExpanded = _expanded;
    selectedDay = formatDate(widget.focusedDay);
    previousDayOfPage = selectedDay;
    currentDayOfPage = selectedDay;
    controllerMonth = PageController(initialPage: monthPageOf(currentDayOfPage))
      ..addListener(() {
        setState(() {
          final newPage = controllerMonth.page!.round();
          if (newPage.toDouble() == controllerMonth.page! &&
              newPage != monthPageOf(currentDayOfPage)) {
            previousDayOfPage = currentDayOfPage;
            currentDayOfPage = months[newPage];
            selectedDay = currentDayOfPage;
          }
        });
      });

    controllerWeek = PageController(initialPage: weekPageOf(currentDayOfPage))
      ..addListener(() {
        setState(() {
          final newPage = controllerWeek.page!.round();
          if (newPage.toDouble() == controllerWeek.page! &&
              newPage != weekPageOf(currentDayOfPage)) {
            previousDayOfPage = currentDayOfPage;
            currentDayOfPage = weeks[newPage];
          }
        });
      });

    controllerDay = PageController(initialPage: days.indexOf(selectedDay))
      ..addListener(() {
        setState(() {
          final newPage = controllerDay.page!.round();
          if (newPage.toDouble() == controllerDay.page! &&
              newPage != days.indexOf(currentDayOfPage)) {
            previousDayOfPage = currentDayOfPage;
            currentDayOfPage = days[newPage];
            selectedDay = currentDayOfPage;
            jumpToPageCalendar(selectedDay);
          }
        });
      });
  }

  // hàm này để chuyển ngày về đúng định dạng là đầu ngày
  // ví dụ:
  // khi lấy focusedDay , nếu lấy bằng phương thức DateTime.now thì sẽ lấy cả ngày và giờ(2021/70/13 12:41:00)
  // nhưng trong danh sách lại chỉ sử dụng thời gian đầu ngày (2021/07/13 00:00:00)
  DateTime formatDate(final DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<TableRow> getTableMonth(int year, int month) {
    List<TableRow> rows = [];
    int totalItem = 0; // tổng số item
    List<CustomCalendar> calendar =
        Calendar.getMonthCalendar(year, month); // lấy lịch tháng

    while (totalItem != calendar.length) {
      List<Widget> widgets = [];

      for (int index = totalItem; index < totalItem + 7; index++) {
        int indexEvent = -1;
        if (widget.events != null) {
          indexEvent = widget.events!.indexWhere((element) =>
              (element as Task).date.isAtSameMomentAs(calendar[index].date));
        }

        widgets.add(SmallItemDay(
          solar: calendar[index].date,
          lunar: calendar[index].dateLunar,
          onChanged: () {
            onPressedSmallItem(calendar[index].date);
          },
          currentValue: selectedDay,
          ofOtherMonth: currentDayOfPage.month != calendar[index].date.month,
          eventCount: indexEvent != -1
              ? (widget.events![indexEvent] as Task).sessions.length
              : 0,
          focusedDay: formatDate(widget.focusedDay),
        ));
      }
      rows.add(TableRow(children: widgets));
      totalItem += 7;
    }
    return rows;
  }

  TableRow getTableWeek(int year, int month, int day) {
    List<Widget> widgets = [];

    List<CustomCalendar> calendar = Calendar.getWeekCalendar(year, month, day);
    for (int index = 0; index < calendar.length; index++) {
      int indexEvent = -1;
      if (widget.events != null) {
        indexEvent = widget.events!.indexWhere((element) =>
            (element as Task).date.isAtSameMomentAs(calendar[index].date));
      }
      widgets.add(
        ItemDay(
          onChanged: () {
            onPressItem(calendar[index].date);
          },
          currentValue: selectedDay,
          solar: calendar[index].date,
          ofOtherMonth: currentDayOfPage.month != calendar[index].date.month,
          lunar: calendar[index].dateLunar,
          eventCount: indexEvent != -1
              ? (widget.events![indexEvent] as Task).sessions.length
              : 0,
          focusedDay: formatDate(widget.focusedDay),
        ),
      );
    }
    return TableRow(children: widgets);
  }

  void onPressItem(final DateTime dayPick) {
    setState(() {
      selectedDay = dayPick;
      currentDayOfPage = dayPick;
    });
    controllerDay.jumpToPage(days.indexOf(selectedDay));
  }

  // lấy biến kiểm tra build view theo tuần hoặc theo tháng
  bool get _expanded => widget.view == ViewCalendar.week ? false : true;

  void onPressedSmallItem(final DateTime dayPick) async {
    if (dayPick.month != currentDayOfPage.month) {
      if (currentDayOfPage.isBefore(dayPick)) {
        await controllerMonth.nextPage(
            duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
      } else if (currentDayOfPage.isAfter(dayPick)) {
        await controllerMonth.previousPage(
            duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
      }
    }
    setState(() {
      selectedDay = dayPick;
      currentDayOfPage = dayPick;
    });
    controllerDay.jumpToPage(days.indexOf(selectedDay));
  }

  String convertWeekend(DateTime date) {
    if (date.weekday == 7)
      return 'Chủ Nhật';
    else
      return 'Thứ ' + (date.weekday + 1).toString();
  }

  String convertDate(DateTime date) {
    return 'Tháng ${date.month},${date.year}';
  }

  void jumpToPageCalendar(final DateTime date) {
    int page;
    if (isExpanded) {
      page = monthPageOf(date);
      //phải thêm widgetBinding vì khi thay đổi trạng thái thì sẽ render lại toàn bộ widget,
      //khi chưa render xong chuyển page luôn sẽ nhận lỗi "ScrollController not attached to any scroll views"
      //nên thêm widgetBinding thì sẽ đợi render xong rồi chuyển page
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        controllerMonth.jumpToPage(page);
      });
    } else {
      page = weekPageOf(date);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        controllerWeek.jumpToPage(page);
      });
    }
  }

  // lấy chỉ số tuần cần hiển thị
  int weekPageOf(final DateTime date) {
    DateTime d = formatDate(date);
    if (d.weekday != 1) {
      d = d.subtract(Duration(days: d.weekday - 1));
    }
    return weeks.indexOf(d);
  }

  // lấy chỉ số tháng cần hiển thị
  int monthPageOf(final DateTime date) {
    return (date.year - widget.startDay.year) * 12 + date.month - 1;
  }

  bool isScrollLeft(final int pos, final int index) {
    return pos < index && pos != index;
  }

  bool isScrollRight(final int pos, final int index) {
    return pos > index && pos != index;
  }

  void onAddNode(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              children: [

              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        });
  }
}
