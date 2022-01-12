import 'package:app/component/color.dart';
import 'package:app/model/content_introduce.dart';
import 'package:app/model/share_pref_memory.dart';
import 'package:app/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      onPageChanged: (int index) {
        setState(() {
          currentPage = index;
        });
      },
      controller: _pageController,
      itemCount: ContentIntro.contents.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SvgPicture.asset(ContentIntro.contents[index].image,
                      height: 350),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  ContentIntro.contents[index].title,
                  style: TextStyle(
                      fontFamily: 'Montserrat-Bold',
                      fontSize: 25,
                      color: kPrimaryColorDark),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ContentIntro.contents[index].description,
                  style: TextStyle(
                      fontFamily: 'Montserrat-Medium',
                      fontSize: 18,
                      fontWeight: FontWeight.w100),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: List.generate(ContentIntro.contents.length,
                            (index) => buildDot(context, index)),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          shadows: [
                            BoxShadow(
                                color: Colors.black54,
                                offset: const Offset(2, 2),
                                blurRadius: 1,
                                spreadRadius: 0.5)
                          ],
                          color: kPrimaryColorDark),
                      child: MaterialButton(
                        onPressed: () async {
                          if (index == ContentIntro.contents.length - 1) {
                            await SharePrefMemory.instance.onBoardingInfor();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          }
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.bounceInOut);
                        },
                        child: SvgPicture.asset(
                          'images/arrow_right.svg',
                          color: kAccentColorLight,
                        ),
                      ),
                    ),
                  ],
                )
              ]),
        );
      },
    ));
  }

  Container buildDot(BuildContext context, int index) {
    return Container(
      width: currentPage == index ? 30 : 15,
      height: 15,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: currentPage == index ? kPrimaryColorDark : kBackgroundColorDark,
      ),
    );
  }
}
