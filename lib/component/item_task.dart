import 'package:app/model/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'color.dart';

class ItemEvent extends StatefulWidget {
  final Session session;
  final String? node;
  final bool isOldEvent;
  final bool isExpand;

  ItemEvent({
    this.node,
    this.isExpand = false,
    required this.session,
    this.isOldEvent = false,
  });

  @override
  _ItemEventState createState() => _ItemEventState();
}

class _ItemEventState extends State<ItemEvent> {
  late bool isShowMore;
  late TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    isShowMore = widget.isExpand;
    _textEditingController = TextEditingController()..addListener(() { });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isShowMore = !isShowMore;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: kBackgroundColorDark,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatName(widget.session.name, false),
                    maxLines: 1,
                    style: TextStyle(
                      color: kAccentColorDark,
                      fontFamily: 'Montserrat-Medium',
                      fontSize: 12.5,
                    ),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: widget.session.type,
                        style: TextStyle(
                            wordSpacing: 2,
                            color: kAccentColorDark,
                            fontFamily: 'Montserrat-Medium',
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.top,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, top: 2),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.isOldEvent
                                    ? kPrimaryColorDark
                                    : kSecondaryColorDark),
                          ),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
              Text(
                formatName(widget.session.name, true),
                style: TextStyle(
                  color: kAccentColorDark,
                  fontFamily: 'Montserrat-Medium',
                  fontSize: 12.5,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DetailInfor(
                                text: "Tiết " + widget.session.time,
                                icon: SvgPicture.asset(
                                  'images/clock.svg',
                                  color: kPrimaryColorDark,
                                )),
                            DetailInfor(
                                text: widget.session.location,
                                icon: SvgPicture.asset(
                                  'images/location.svg',
                                  color: kPrimaryColorDark,
                                )),
                            Visibility(
                              visible: isShowMore ? true : false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.5),
                                    child: DetailInfor(
                                        text: widget.session.teacher,
                                        icon: SvgPicture.asset(
                                          'images/user.svg',
                                          color: kPrimaryColorDark,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.5),
                                    child: DetailInfor(
                                        text: 'Mã Môn: ' + widget.session.code,
                                        icon: SvgPicture.asset(
                                          'images/bar_code.svg',
                                          color: kPrimaryColorDark,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.5),
                                    child: DetailInfor(
                                        text: widget.node ?? "Không có ghi chú",
                                        icon: SvgPicture.asset(
                                          'images/document_signed.svg',
                                          color: kPrimaryColorDark,
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: kAccentColorLight, shape: BoxShape.circle),
                          child: FittedBox(
                            child: IconButton(
                              icon: SvgPicture.asset(
                                "images/pen.svg",
                                color: kPrimaryColorDark,
                              ),
                              onPressed: () {
                                onTakeNode(context, widget.session);
                              },
                            ),
                          ),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String formatName(String name, bool isOtherName) {
    var listName = name.split(RegExp(r'[()]'));
    if (isOtherName != true) {
      return listName[0].trim();
    } else {
      return listName[1].trim();
    }
  }

  Future<void> onTakeNode(BuildContext context, Session value) async {
    int maxLenght = 50;
    bool showNofi = false;
    int charLenght = 0;
    return await showDialog(
        context: context,
        builder: (context) {
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
                            fontSize: 16,
                            color: kAccentColorDark)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(formatName(widget.session.name, false),
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
                          autofocus: true,
                          controller: _textEditingController,
                          onTap: (){
                            WidgetsBinding.instance!.addPostFrameCallback((_) => _textEditingController.clear());
                          },

                          // controller: textEditingController,
                          cursorHeight: 5,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          maxLines: 5,
                          cursorColor: kPrimaryColorDark,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nội Dung",
                              hintStyle: TextStyle(
                                  fontFamily: "Montserrat-Medium",
                                  fontSize: 16,
                                  color: kAccentColorDark)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          child: Text("Không được bỏ trống"),
                          visible: showNofi,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                        ),
                        Text("$charLenght/$maxLenght")
                      ],
                    ),
                    Align(
                      child: InkWell(
                        child: Container(
                          height: 40,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kPrimaryBackgroundColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Lưu",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Montserrat-Medium",
                                color: kAccentColorLight),
                          ),
                        ),
                        onTap: () {
                          // if (textEditingController.value.text.length == 0) {
                          //   setState(() {
                          //     showNofi = true;
                          //   });
                          // } else {
                          //   setState(() {
                          //     value.node = textEditingController.value.text;
                          //   });
                          //   return Navigator.of(context).pop();
                          // }
                        },
                      ),
                      alignment: Alignment.bottomCenter,
                    )
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ));
        });
  }
}

class DetailInfor extends StatelessWidget {
  final String? text;
  final Widget icon;
  DetailInfor({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.top,
          child: Padding(
            padding: const EdgeInsets.only(top: 2, right: 8.0),
            child: Container(height: 13, width: 13, child: icon),
          ),
        ),
        TextSpan(
          text: text,
          style: TextStyle(
              wordSpacing: 2,
              color: kAccentColorDark,
              fontFamily: 'Montserrat-Medium',
              fontSize: 12.5,
              fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}
