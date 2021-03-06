import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

class APIICTU {
  static APIICTU instance = APIICTU._();

  APIICTU._();

  String urlLogin = "http://dangkytinchi.ictu.edu.vn/kcntt/login.aspx";
  final String urlOrigin = "http://dangkytinchi.ictu.edu.vn";
  String urlSchedule =
      "http://dangkytinchi.ictu.edu.vn/kcntt/Reports/Form/StudentTimeTable.aspx";
  String? cookie;

  Options get optionsGetCokies => Options(
          followRedirects: true,
          validateStatus: (value) {
            return value! <= 302;
          },
          headers: {
            'Accept-Language': 'en-US,en;q=0.9,vi;q=0.8',
            'Referer': urlLogin,
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36 Edg/92.0.902.67',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Origin': urlOrigin,
            'Upgrade-Insecure-Requests': '1',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            'Accept-Encoding': 'gzip, deflate',
            'Host': '220.231.119.171',
          });

  Options get optionsLogin => Options(followRedirects: true, headers: {
        'Accept-Language': 'en-US,en;q=0.9,vi;q=0.8',
        'Referer': urlOrigin,
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36 Edg/92.0.902.67',
        'Upgrade-Insecure-Requests': '1',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate',
        'Host': '220.231.119.171',
      });

  Options get optionsGetSchedule => Options(
          followRedirects: true,
          validateStatus: (value) {
            return value! <= 302;
          },
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Cookie': cookie,
            'Accept-Language': 'en-US,en;q=0.9,vi;q=0.8',
            'Referer': urlSchedule,
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36 Edg/92.0.902.67',
            'Upgrade-Insecure-Requests': '1',
            'Connection': 'keep-alive',
            'Accept-Encoding': 'gzip, deflate',
            'Host': '220.231.119.171',
            'Origin': urlOrigin,
            'Content-Type': 'application/x-www-form-urlencoded',
          });

  Future<List<dynamic>> getSchedule(String useName, String passWord) async {
    // l???y form data ????? ????ng nh???p
    return await formData().then((formData) async {
      // l???y cookies
      cookie = await getCookie(useName, passWord, formData);
      if (cookie != null) {
        var response =
            await Dio().get(urlSchedule, options: optionsGetSchedule);
        if (response.statusCode == 200) {
          urlSchedule = response.realUri.toString().contains(urlOrigin)
              ? response.realUri.toString()
              : urlOrigin + response.realUri.toString();

          var doc = await docSchedule(response);
          return json(doc);
        } else {
          return [];
        }
      } else {
        throw Exception("Login failed");
      }
    });
  }

  Future<Map> formData() async {
    return await Dio()
        .get(
      urlLogin,
      options: optionsLogin,
    )
        .timeout(const Duration(milliseconds: 7000), onTimeout: () {
      throw TimeoutException('Kh??ng c?? ph???n h???i');
    }).then((response) {
      var form = {};

      if (response.statusCode == 200) {
        // g??n ???????ng d???n ????ng nh???p m???i v?? khi ????ng nh???p t??? ???????ng d???n ????ng nh???p g???c s??? b??? ??i???u h?????ng n???u th??nh c??ng
        // khi ????ng nh???p l???n 1 ch??? c?? 1 ph???n url c??n t??? l???n 2 tr??? ??i s??? c?? ????? to??n b??? n??n khi c???ng chu???i
        // s??? b??? tr??ng . => s??? d???ng v??ng
        urlLogin = response.realUri.toString().contains(urlOrigin)
            ? response.realUri.toString()
            : urlOrigin + response.realUri.toString();

        // tr??? v??? form ????? ????ng nh???p

        var document = parse(response.data);
        form['__VIEWSTATE'] = document
            .getElementById('__VIEWSTATE')!
            .attributes['value']
            .toString();
        form['__EVENTVALIDATION'] = document
            .getElementById('__EVENTVALIDATION')!
            .attributes['value']
            .toString();
      }
      return form;
    });
  }

  Future<Document> docSchedule(Response root) async {
    // l???ch b??? ?????i li??n t???c n??n n???u ch???n l???ch c??? th??? s??? g??y l???i
    // kh???c ph???c b???ng c??ch cho v??ng for ch???y l???n l?????t qua id c??c k??? n???u th???y l???ch d???ng ngay

    List<String> idSemesters = [];
    late String defaultSemester;
    Response res = root;
    late Document document;
    // l???y gi?? tr??? ban ?????u c???a danh s??ch k??? h???c v?? k??? h???c m???c ?????nh ban ?????u
    parse(root.data)
        .getElementById("drpSemester")!
        .getElementsByTagName("option")
        .forEach((element) {
      if (element.attributes['selected']?.compareTo('selected') == 0) {
        defaultSemester = element.attributes['value']!;
      }
      idSemesters.add(element.attributes['value']!);
    });
    // *
    // n???u id k??? h???c tr??ng m???c ?????nh tr??ng v???i id ?????u th?? s??? ko request ??k v?? n?? kh??ng
    // kh??c g?? request m???c ?????nh n??n n?? s??? ko request g??
    // x??? l?? : request t??? id k??? h???c th??? 2 r???i request l???i k??? h???c ?????u ????? xem c?? l???ch kh??ng

    int index = 0;
    if (defaultSemester.compareTo(idSemesters[0]) == 0) {
      index = 1;
    }
    for (int i = index; i < idSemesters.length; i++) {
      var data = formDataDynamic(res, idSemesters[i]);
      res = await Dio()
          .post(urlSchedule, options: optionsGetSchedule, data: data);

      document = parse(res.data);

      if (document.getElementsByClassName("cssListItem").isNotEmpty ||
          document
              .getElementsByClassName('cssListAlternativeItem')
              .isNotEmpty) {
        break;
      }
    }
    // request l???i v???i k??? h???c ?????u n???u x???y ra *
    if (index == 1) {
      var resTemp = await Dio().post(urlSchedule,
          options: optionsGetSchedule,
          data: formDataDynamic(res, defaultSemester));
      var docTemp = parse(resTemp.data);

      if (docTemp.getElementsByClassName("cssListItem").isNotEmpty ||
          docTemp.getElementsByClassName('cssListAlternativeItem').isNotEmpty) {
        document = docTemp;
      }
    }

    return document;
  }

  Map<String, dynamic> formDataDynamic(Response response, String semester) {
    Map<String, dynamic> form = {};
    var document = parse(response.data);

    form['__VIEWSTATE'] =
        document.getElementById('__VIEWSTATE')!.attributes['value'].toString();

    form['__EVENTVALIDATION'] = document
        .getElementById('__EVENTVALIDATION')!
        .attributes['value']
        .toString();

    // drpSemester
    form['drpSemester'] = semester;

    //hidShowTeacher
    form['hidShowTeacher'] =
        document.getElementById('hidShowTeacher')!.attributes['value'];

    // drpType
    form['drpType'] = document
        .getElementById('drpType')!
        .querySelectorAll('option')[0]
        .attributes['value'];

    //hidTuitionFactorMode
    form['hidTuitionFactorMode'] =
        document.getElementById('hidTuitionFactorMode')!.attributes['value'];

    //hidLoaiUuTienHeSoHocPhi
    form['hidLoaiUuTienHeSoHocPhi'] =
        document.getElementById('hidLoaiUuTienHeSoHocPhi')!.attributes['value'];

    //hidStudentId
    form['hidStudentId'] =
        document.getElementById('hidStudentId')!.attributes['value'];

    return form;
  }

  Future<String?> getCookie(String useName, String passWord, Map form) {
    form['btnSubmit'] = '????ng nh???p';
    form['txtUserName'] = useName;
    form['txtPassword'] = md5.convert(utf8.encode((passWord))).toString();
    return Dio()
        .post(urlLogin, options: optionsGetCokies, data: form)
        .then((response) {
      if (response.statusCode == 200 || response.statusCode == 302) {
        return fomatCookies(response);
      } else {
        return null;
      }
    });
  }

  String? fomatCookies(Response<dynamic> response) {
    var listCookies = response.headers['Set-Cookie'];
    if (listCookies != null) {
      return listCookies.toString().split(';')[0].substring(1);
    }
    return null;
  }

  List<dynamic> json(Document doc) {
    var schedule = mergeSchedule(getScheduleByClass(doc, "cssListItem"),
        getScheduleByClass(doc, "cssListAlternativeItem"));
    return schedule;
  }

  List<Map<String, dynamic>> getScheduleByClass(
      Document doc, String className) {
    List<Map<String, dynamic>> schedule = [];
    var elements = doc.getElementsByClassName(className);

    elements.forEach((e) {
      var datas = e.getElementsByTagName("td");

      // ph???n t??? th??? 0 l?? stt
      // ph???n t??? th??? 1 l?? t??n v?? m?? m??n
      // ph???n t??? th??? 2 l?? m?? h???c ph???n
      // ph???n t??? th??? 3 l?? th???i kh??a bi???u
      // ph???n t??? th??? 4,5,6 l?? ?????a ??i???m, gi??o vi??n , s?? s???,s??? t??n ch???
      String subject = datas[1].innerHtml.trim();
      String code = datas[2].getElementsByTagName("span")[0].innerHtml.trim();
      var location = getLocation(datas[4].innerHtml.trim());
      String teacher = datas[5].innerHtml.trim();
      var scheduleOfSubject = getScheduleOfSubject(
          datas[3].innerHtml, subject, location, teacher, code);
      mergeSchedule(schedule, scheduleOfSubject);
    });
    return schedule;
  }

  Map<String, dynamic> getLocation(String datas) {
    var locationDetail = datas.split(RegExp("<[^>]*>"));

    if (locationDetail.length > 1) {
      List<String> keys = [];
      var address = [];
      String kTemp = "";
      for (int index = 0; index < locationDetail.length; index++) {
        if (locationDetail[index].trim().isNotEmpty) {
          if (locationDetail[index].trim()[0] == '(') {
            kTemp = locationDetail[index].trim();
          } else {
            keys.add(kTemp);
            address.add(locationDetail[index].trim());
          }
        }
      }
      return Map.fromIterables(keys, address);
    } else {
      return {"only": locationDetail[0].trim()};
    }
  }

  List<Map<String, dynamic>> getScheduleOfSubject(String source, String subject,
      Map location, String teacher, String code) {
    var doc = source.trim().split("T??? ");
    doc.removeAt(0);
    List<Map<String, dynamic>> schedule = [];
    doc.forEach((docSchedule) {
      // l???y kho???ng th???i gian di???n ra s??? ki???n
      DateTimeRange period = getPeriodBroad(docSchedule);
      // l???y chu k?? h???c
      var cycle =
          getCycle(docSchedule, period.start, subject, location, teacher, code);

      // l???y l???ch m??n hoc trong t???ng kho???ng th???i gian
      List<Map<String, dynamic>> scheduleForPeriod =
          getScheduleDetail(cycle, period);

      // g???p l???ch h???c trong c??c kho???ng th???i gian
      mergeSchedule(schedule, scheduleForPeriod);
    });

    return schedule;
  }

  List<Map<String, dynamic>> mergeSchedule(
      List<Map<String, dynamic>> root, List<Map<String, dynamic>> other) {
    List<Map<String, dynamic>> newRoot = root;
    if (newRoot.isEmpty) {
      newRoot.addAll(other);
    } else {
      other.forEach((scheduleOfOther) {
        int index = newRoot.indexWhere((scheduleOfRoot) {
          if ((scheduleOfOther["date"] as DateTime)
              .isAtSameMomentAs(scheduleOfRoot["date"] as DateTime)) {
            return true;
          }
          return false;
        });
        if (index != -1) {
          for (int i = 0;
              i < (scheduleOfOther["sessions"] as List).length;
              i++) {
            (newRoot[index]["sessions"] as List)
                .add((scheduleOfOther["sessions"][i] as Map));
          }

          // s???p x???p l???i th???i kh??a bi???u
          (newRoot[index]["sessions"] as List).sort((a, b) {
            return int.parse(
                    (a as Map)["time"].toString().trim().substring(0, 1))
                .compareTo(int.parse(
                    (b as Map)["time"].toString().trim().substring(0, 1)));
          });
        } else {
          Map<String, dynamic> newOfOther = Map.from(scheduleOfOther);
          newRoot.add(newOfOther);
        }
      });
    }
    return newRoot;
  }

  List<Map<String, dynamic>> getCycle(String scheduleForPeriod, DateTime start,
      String subject, Map locations, String teacher, String code) {
    List<Map<String, dynamic>> sessionsCycle = [];
    late String location;
    var cycle = parse(scheduleForPeriod).getElementsByTagName("b");
    if (locations.length > 1) {
      // ph???n t??? s??? th??? t??? c?? khi c?? t??? 2 l???ch
      var number = cycle[0].innerHtml.substring(1, 2);
      var keyOfNumber = locations.keys
          .firstWhere((element) => (element as String).indexOf(number) != -1);
      location = locations[keyOfNumber];
    } else {
      // quy ?????nh trong ph???n ?????a ??i???m n???u ch??? c?? 1 ?????a ??i???m th?? map c?? key "only"
      location = locations["only"];
    }
    if (cycle.length > 1) {
      // c???t b??? ph???n t??? s??? th??? t???
      cycle.removeAt(0);
    }

    cycle.forEach((session) {
      var lessons = session.innerHtml.split(" ");
      // l???y th??? :
      late int weekday;
      try {
        weekday = int.parse(lessons[1]);
      } catch (e) {
        weekday = 8;
      }
      if (weekday > start.weekday) {
        start = start.add(Duration(days: weekday - start.weekday - 1));
      } else {
        start =
            start.add(Duration(days: 7 - (weekday - start.weekday - 1).abs()));
      }
      sessionsCycle.add(
        {
          "date": start,
          "sessions": [
            {
              "name": subject,
              "code": code,
              "location": location,
              "teacher": teacher,
              "time": lessons[3],
              "type": lessons[4],
            }
          ]
        },
      );
    });
    return sessionsCycle;
  }

  DateTimeRange getPeriodBroad(String period) {
    var dates = period.split(":")[0].split("?????n");
    return DateTimeRange(
        start: formatDate(dates[0]), end: formatDate(dates[1]));
  }

  List<Map<String, dynamic>> getScheduleDetail(
      List<Map<String, dynamic>> cycle, DateTimeRange period) {
    List<Map<String, dynamic>> scheduleDetail = List.from(cycle);

    DateTime currentDate = period.start;
    int inWeeks = 1;
    cycle.forEach((element) {
      if ((element["date"] as DateTime).weekday <= currentDate.weekday &&
          !currentDate.isAtSameMomentAs((element["date"] as DateTime))) {
        inWeeks++;
      }
      currentDate = (element["date"] as DateTime);
    });

    int repeat = 1;

    while ((cycle.last["date"] as DateTime)
        .add(Duration(days: inWeeks * 7 * repeat))
        .isBefore(period.end)) {
      cycle.forEach((e) {
        // ch?? th??ch l???i qt 1
        // ph???i clone 1 bi???n m???i v?? n???u ????? gi?? tr??? g???c th?? s??? b??? tr??ng ?????a ch???
        // ?????n l??c ?????i gi?? tr??? s??? ?????i lu??n gi?? tr??? t???i v??ng nh??? ????
        List<Map<String, dynamic>> newSession = List.of(e["sessions"]);
        var newDate =
            (e["date"] as DateTime).add(Duration(days: repeat * 7 * inWeeks));
        scheduleDetail.add({"date": newDate, "sessions": newSession});
      });
      repeat++;
    }
    return scheduleDetail;
  }

  DateTime formatDate(String date) {
    var elements = date.split("/");
    if (elements.length != 3) {
      return throw FormatException;
    }
    return DateTime(
        int.parse(elements[2]), int.parse(elements[1]), int.parse(elements[0]));
  }
}
