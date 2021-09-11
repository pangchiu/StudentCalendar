import 'package:flutter/material.dart';
import 'color.dart';

class ItemDay extends StatelessWidget {
  final DateTime currentValue;
  final Function() onChanged;
  final DateTime solar;
  final DateTime lunar;
  final bool ofOtherMonth;
  final int? eventCount;
  final DateTime focusedDay;

  ItemDay(
      {required this.onChanged,
      required this.currentValue,
      required this.solar,
      required this.lunar,
      required this.focusedDay,
      this.ofOtherMonth = false,
      this.eventCount});

  Color getTextItemColor() {
    if (ofOtherMonth) {
      return kTitleAccentTextColor;
    } else {
      if (solar.isAtSameMomentAs(currentValue)) {
        return kAccentColorLight;
      } else {
        return kAccentColorDark;
      }
    }
  }

  Color getDotsColor() {
    if (solar.isAtSameMomentAs(currentValue)) {
      return kAccentColorLight;
    } else {
      if (ofOtherMonth) {
        if (solar.isBefore(focusedDay)) {
          return kPrimaryColorLight;
        }
        return kSecondaryColorLight;
      } else {
        if (solar.isBefore(focusedDay)) {
          return kPrimaryColorDark;
        }
        return kSecondaryColorDark;
      }
    }
  }

  Color getItemColor() {
    if (solar.isAtSameMomentAs(currentValue)) {
      return kPrimaryBackgroundColor;
    } else {
      return kAccentColorLight;
    }
  }

  Color getTextWeekDayItemColor() {
    if (solar.isAtSameMomentAs(currentValue)) {
      return kAccentColorLight;
    } else {
      return kPrimaryBackgroundColor;
    }
  }

  String convertWeekend(int weekend) {
    if (weekend == 7)
      return 'CN';
    else
      return 'T' + (weekend + 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
        child: SizedBox(
          width: size.width / 7 - 12,
          height: size.height / 8,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2.5),
            color: getItemColor(),
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: kBackgroundColorLight),
                borderRadius: BorderRadius.circular(7)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('${convertWeekend(solar.weekday)}',
                    style: TextStyle(
                        color: getTextWeekDayItemColor(),
                        fontFamily: 'Montserrat-Medium',
                        fontSize: 15,
                        fontWeight: FontWeight.w900)),
                Text('${solar.day}',
                    style: TextStyle(
                        color: getTextItemColor(),
                        fontSize: 15,
                        fontFamily: 'Montserrat-Medium',
                        fontWeight: FontWeight.w600)),
                Text('${lunar.day}/${lunar.month}',
                    style: TextStyle(
                        color: getTextItemColor(),
                        fontFamily: 'Montserrat-Medium',
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List.generate(eventCount!, (index) => buildDot())),
              ],
            ),
          ),
        ),
        onTap: onChanged);
  }

  Widget buildDot() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        height: 5,
        width: 5,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: getDotsColor()),
      ),
    );
  }
}
