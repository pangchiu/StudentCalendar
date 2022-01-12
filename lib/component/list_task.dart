import 'package:app/app_data_base.dart';
import 'package:app/component/color.dart';
import 'package:app/component/item_task.dart';
import 'package:app/model/session.dart';
import 'package:app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListEvent extends StatefulWidget {
  final DateTime selectedDay;
  final DateTime startDay;
  final DateTime endDay;
  final DateTime focusedDay;
  final List<DateTime> days;
  final PageController? controller;
  final List<dynamic>? events;
  ListEvent({
    required this.selectedDay,
    this.controller,
    required this.events,
    required this.startDay,
    required this.endDay,
    required this.days,
    required this.focusedDay,
  });

  @override
  _ListEventState createState() => _ListEventState();
}

class _ListEventState extends State<ListEvent> {
  late PageController controller;
  int previousPage = 0;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // lấy danh sách ngày
    currentPage = widget.days.indexOf(widget.selectedDay);
    previousPage = currentPage;

    controller = widget.controller ?? PageController(initialPage: currentPage)
      ..addListener(() {
        setState(() {
          final newPage = controller.page!.round();
          if (newPage.toDouble() == controller.page! &&
              newPage != currentPage) {
            previousPage = currentPage;
            currentPage = newPage;
          }
        });
      });
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lịch trong ngày',
                style: TextStyle(
                  color: kAccentColorDark,
                  fontFamily: 'Montserrat-Medium',
                  fontSize: 20,
                )),
            Expanded(
                child: PageView.builder(
              controller: controller,
              itemCount: widget.days.length,
              itemBuilder: (context, index) {
                // biến factor để quy định chiều xuất hiện hiệu ứng chiều vuốt sang trái page tăng nên factor
                // là 1, chiều vuốt sang phải page giảm nên factor là -1
                int factor;
                if (isScrollLeft(currentPage, index)) {
                  factor = 1;
                } else if (isScrollRight(currentPage, index)) {
                  factor = -1;
                } else {
                  if (currentPage >= previousPage) {
                    factor = 1;
                  } else
                    factor = -1;
                }
                if (currentPage * factor > index * factor) {
                  return buildListViewEvent(index);
                } else if (currentPage * factor < index * factor) {
                  return Transform.translate(
                    offset: Offset(screenWidth * factor, 0),
                    child: buildListViewEvent(index),
                  );
                } else {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: screenWidth),
                    duration: Duration(milliseconds: 300),
                    builder: (context, value, child) => Transform.translate(
                      offset: Offset((screenWidth - value) * factor, 0),
                      child: child,
                    ),
                    child: buildListViewEvent(index),
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget buildListViewEvent(int index) {
    if (widget.events == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                "images/search.svg",
                color: kPrimaryBackgroundColor,
                height: 20,
                width: 20,
              ),
            ),
            Text(
              "HaHa, Được nghỉ rồi !!!",
              style: TextStyle(
                color: kAccentColorDark,
                fontFamily: 'Montserrat-Medium',
                fontSize: 15,
              ),
            )
          ],
        ),
      );
    } else {
      int indexEvent = widget.events!.indexWhere((element) =>
          (element as Task).date.isAtSameMomentAs(widget.days[index]));
      if (indexEvent != -1) {
        return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10),
            itemCount: (widget.events![indexEvent] as Task).sessions.length,
            itemBuilder: (context, i) {
              Task task = widget.events![indexEvent];
              return Container(
                margin: const EdgeInsets.all(5),
                child: ItemTask(
                  session: task.sessions[i],
                  isOldEvent: task.date.isBefore(widget.focusedDay),
                  onTakeNode: () async {
                    String? node = await onTakeNode(context, task.sessions[i]);
                    if (node != null) {
                      setState(() {
                        task.sessions[i].node = node;
                      });
                    }
                  },
                ),
              );
            });
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  "images/search.svg",
                  color: kPrimaryBackgroundColor,
                  height: 20,
                  width: 20,
                ),
              ),
              Text(
                "HaHa, Được nghỉ rồi !!!",
                style: TextStyle(
                  color: kAccentColorDark,
                  fontFamily: 'Montserrat-Medium',
                  fontSize: 15,
                ),
              )
            ],
          ),
        );
      }
    }
  }

  Future<String?> onTakeNode(BuildContext context, Session s) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController =
              TextEditingController(text: s.node);
          int charLenght = _textEditingController.text.length;
          return StatefulBuilder(builder: (context, set) {
            return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Thêm Ghi Chú",
                          style: TextStyle(
                              fontFamily: "Montserrat-Medium",
                              fontSize: 15,
                              color: kAccentColorDark)),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: kBackgroundColorDark,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            controller: _textEditingController,
                            cursorHeight: 5,
                            maxLines: 5,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            cursorColor: kPrimaryColorDark,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nội Dung",
                                hintStyle: TextStyle(
                                    fontFamily: "Montserrat-Medium",
                                    fontSize: 13,
                                    color: kTitleAccentTextColor),
                                counterText: '$charLenght/50',
                                counterStyle: TextStyle(
                                  fontFamily: "Montserrat-Medium",
                                  fontSize: 12,
                                )),
                            onChanged: (value) {
                              set(() {
                                charLenght = value.length;
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: kPrimaryBackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Lưu',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Montserrat-Medium",
                                    color: kAccentColorLight),
                              ),
                            ),
                            onTap: () async {
                              // lưu thông tin
                              await AppDatabase.instance
                                  .updateNode(s, _textEditingController.text);
                              Navigator.pop(
                                  context, _textEditingController.text);
                            },
                          ),
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                charLenght == 0 ? 'Hủy' : 'Xóa',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Montserrat-Medium",
                                ),
                              ),
                            ),
                            onTap: () {
                              if (charLenght == 0) {
                                Navigator.of(context).pop();
                              } else {
                                _textEditingController.text = "";
                                set(() {
                                  charLenght = 0;
                                });
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ));
          });
        });
  }

  bool isScrollLeft(final int pos, final int index) {
    return pos < index && pos != index;
  }

  bool isScrollRight(final int pos, final int index) {
    return pos > index && pos != index;
  }
}
