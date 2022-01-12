import 'package:app/component/color.dart';
import 'package:flutter/material.dart';

class SmallItemDay extends StatelessWidget {
  final DateTime solar;
  final DateTime currentValue;
  final DateTime lunar;
  final Function() onChanged;
  final int? eventCount;
  final bool ofOtherMonth;
  final DateTime focusedDay;

  SmallItemDay({
    required this.solar,
    required this.lunar,
    required this.onChanged,
    required this.currentValue,
    required this.focusedDay,
    this.eventCount,
    this.ofOtherMonth = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
        height: ((size.width - 40) ~/ 7).toDouble(),
        decoration: BoxDecoration(
            color: getItemColor(),
            borderRadius: BorderRadius.all(Radius.circular(7))),
        // build ngày tháng năm
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${solar.day}',
              style: TextStyle(
                  fontFamily: 'Montserrat-Medium',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: getTextItemColor()),
            ),
            Text(
              '${lunar.day}/${lunar.month}',
              style: TextStyle(
                  fontFamily: 'Montserrat-Medium',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: getTextItemColor()),
            ),
            // build số sự kiện trong ngày
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(eventCount!, (_) => buildDots()),
            ),
          ],
        ),
      ),
      onTap: onChanged,
    );
  }

  Widget buildDots() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        height: 5,
        width: 5,
        decoration: BoxDecoration(shape: BoxShape.circle, color: getDotsColor()),
      ),
    );
  }

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

  Color getItemColor() {
    if (solar.isAtSameMomentAs(currentValue)) {
      return kPrimaryBackgroundColor;
    } else {
      return kAccentColorLight;
    }
  }

 Color getDotsColor() {
    if (solar.isAtSameMomentAs(currentValue)) {
      return kAccentColorLight;
    } else {
      if (ofOtherMonth) {
        if (solar.isBefore(focusedDay)) {
          return kPrimaryColorDark;
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
}
