import 'dart:math' as math;
import 'package:app/component/color.dart';
import 'package:flutter/material.dart';

class CallSchduleLoading extends StatefulWidget {
  final AnimationController? controller;

  CallSchduleLoading({this.controller});

  @override
  CallSchduleLoadingState createState() => CallSchduleLoadingState();
}

class CallSchduleLoadingState extends State<CallSchduleLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationDotOne;
  late Animation<double> _animationDotTwo;
  late Animation<double> _animationDotThree;
  double initialBounce = 15;
  double bounceDotOne = 10;
  double bounceDotTwo = 10;
  double bounceDotThree = 10;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        AnimationController(
            duration: Duration(milliseconds: 1500), vsync: this);

    _animationDotOne = Tween<double>(begin: 0.0, end: 2).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.8, curve: Curves.easeInOutSine)));

    _animationDotTwo = Tween<double>(begin: 0.0, end: 2).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0.1, 0.9, curve: Curves.easeInOutSine)));

    _animationDotThree = Tween<double>(begin: 0.0, end: 2).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0.2, 1, curve: Curves.easeInOutSine)));

    _controller.addListener(() {
      setState(() {
        if (_controller.value >= 0.0 && _controller.value <= 0.8) {
          bounceDotOne =
              initialBounce * math.sin(math.pi / 2 * _animationDotOne.value);
        }
        if (_controller.value >= 0.1 && _controller.value <= 0.9) {
          bounceDotTwo =
              initialBounce * math.sin(math.pi / 2 * _animationDotTwo.value);
        }
        if (_controller.value >= 0.2 && _controller.value <= 1) {
          bounceDotThree =
              initialBounce * math.sin(math.pi / 2 * _animationDotThree.value);
        }
      });
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size.height * 0.09,
          width: size.width * 0.15,
          child: Image.asset(
            'images/logo2.png',
            fit: BoxFit.fill,
            color: kPrimaryBackgroundColor,
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Transform.translate(
              offset: Offset(0, bounceDotOne),
              child: Opacity(
                opacity: 0.5,
                child: Dot(
                  radius: 10,
                  color: kPrimaryColorDark,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Transform.translate(
              offset: Offset(0, bounceDotTwo),
              child: Opacity(
                opacity: 0.75,
                child: Dot(
                  radius: 10,
                  color: kPrimaryColorDark,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Transform.translate(
              offset: Offset(0, bounceDotThree),
              child: Opacity(
                opacity: 1,
                child: Dot(
                  radius: 10,
                  color: kPrimaryColorDark,
                ),
              ),
            ),
          ),
        ]),

        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text('Đợi xíu nhá !!!',
              style: TextStyle(fontFamily: 'Montserrat-Bold', fontSize: 13)),
        ),
      ],
    ));
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color? color;
  Dot({required this.radius, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
