import 'package:app/component/color.dart';
import 'package:app/model/share_pref_memory.dart';
import 'package:app/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: 50,
          width: size.width,
          color: kPrimaryBackgroundColor,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'Chức Năng',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w500,
                  color: kAccentColorDark),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric( horizontal: 20),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              InkWell(
                child: Card(
                    color: kBackgroundColorDark,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'images/sign_out.svg',
                            color: kPrimaryColorDark,
                            height: 30,
                            width: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Thoát',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Montserrat-Medium',
                                  fontWeight: FontWeight.w400,
                                  color: kAccentColorDark),
                            ),
                          )
                        ],
                      ),
                    )),
                onTap: () async {
                  await SharePrefMemory.instance.onSignOutInfor();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              )
            ],
          ),
        )
      ],
    );
  }

}
