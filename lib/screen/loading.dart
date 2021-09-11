import 'package:app/component/color.dart';
import 'package:app/screen/home.dart';
import 'package:flutter/material.dart';

const PI = 3.14;

class LoadScreen extends StatefulWidget {
  @override
  LoadScreenState createState() => LoadScreenState();
}

class LoadScreenState extends State<LoadScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration(milliseconds: 4000),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(seconds: 4),
              builder: (context, val, child) {
                int percent = (val * 100).ceil();
                return Stack(
                  children: [
                    ShaderMask(
                        shaderCallback: (rect) => SweepGradient(
                              startAngle: 0.0,
                              endAngle: PI * 2,
                              colors: <Color>[
                                kPrimaryColorDark,
                                kBackgroundColorDark
                              ],
                              stops: [val, val],
                              transform: GradientRotation(PI * 1.5),
                            ).createShader(rect),
                        child: Center(
                          child: Container(
                            width: size.width * 0.2,
                            height: size.width * 0.2,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                        )),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width * 0.2 - 20,
                        height: size.width * 0.2 - 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$percent%',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat-Medium',
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
