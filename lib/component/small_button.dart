import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final Widget icon;
  final Function() onPressed;
  final Widget? child;
  final Color color;

  const SmallButton(
      {required this.icon,
      required this.color,
      required this.onPressed,
      this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          height: 35,
          width: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(8)),
          child: Stack(children: [
            Center(
              child: Container(
                width: 22,
                height: 22,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: icon,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: child != null ? child : Text(''),
              ),
            )
          ]),
        ),
      ),
      onTap: onPressed,
    );
  }
}
