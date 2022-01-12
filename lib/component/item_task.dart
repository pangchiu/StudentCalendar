import 'package:app/model/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'color.dart';

class ItemTask extends StatefulWidget {
  final Session session;
  final bool isOldEvent;
  final bool isExpand;
  final Function()? onTakeNode;
  ItemTask({

    this.isExpand = false,
    this.isOldEvent = false,
    this.onTakeNode,
    required this.session,
  });

  @override
  _ItemTaskState createState() => _ItemTaskState();
}

class _ItemTaskState extends State<ItemTask> {
  late bool isShowMore;
  bool showNofi = false;

  @override
  void initState() {
    super.initState();
    isShowMore = widget.isExpand;
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
                                        text: (widget.session.node ?? '' ).isEmpty ?  'Không có ghi chú' : widget.session.node,
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
                              onPressed: widget.onTakeNode,
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
}

class DetailInfor extends StatelessWidget {
  final String? text;
  final Widget icon;
  DetailInfor({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, right: 8.0),
          child: Container(height: 13, width: 13, child: icon),
        ),
        Text(
          text!.split("(")[0].trim(),
          maxLines: 2,
          style: TextStyle(
              wordSpacing: 2,
              color: kAccentColorDark,
              fontFamily: 'Montserrat-Medium',
              fontSize: 12.5,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
