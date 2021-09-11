import 'package:flutter/material.dart';

class TextFiledContainer extends StatelessWidget {
  final Widget child;
  final Text label;
  final Widget? icon;
  final Color? color;

  TextFiledContainer(
      {Key? key,
      required this.child,
      required this.label,
      this.icon,
       required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: label,
          ),
          Container(
            height: size.height * 0.08,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: child,
                ),
                Align(
                  child: icon,
                  alignment: Alignment.centerRight,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
