import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class APIICTU {
  static APIICTU instance = APIICTU._();

  APIICTU._();

  String urlLogin = "http://220.231.119.171/kcntt/login.aspx";
  String urlOrigin = "http://220.231.119.171";
  String urlSchedule =
      "http://220.231.119.171/kcntt/Reports/Form/StudentTimeTable.aspx";
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
            'Origin': 'http://220.231.119.171',
            'Upgrade-Insecure-Requests': '1',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            'Accept-Encoding': 'gzip, deflate',
            'Host': '220.231.119.171',
          });

  Options get optionsLogin => Options(followRedirects: true, headers: {
        'Accept-Language': 'en-US,en;q=0.9,vi;q=0.8',
        'Referer': 'http://dangkytinchi.ictu.edu.vn/',
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
          });

  Future<List<dynamic>> getSchedule(String useName, String passWord) async {
    // lấy form data để đăng nhập
    return await getFormData().then((formData) async {
      // lấy cookies
      cookie = await getCookie(useName, passWord, formData);
      if (cookie != null) {
        return await Dio()
            .get(urlSchedule, options: optionsGetSchedule)
            .then((res) {
          return json(res);
        });
      } else
        return [];
    });
  }

  Future<Map> getFormData() async {
    return await Dio().get(urlLogin, options: optionsLogin).then((response) {
      // gán đường dẫn đăng nhập mới vì khi đăng nhập từ đường dẫn đăng nhập gốc sẽ bị điều hướng
      urlLogin = urlOrigin + response.realUri.toString();

      // trả về form để đăng nhập
      var form = {};
      var document = parse(response.data);
      form['__VIEWSTATE'] = document
          .getElementById('__VIEWSTATE')!
          .attributes['value']
          .toString();
      form['__EVENTVALIDATION'] = document
          .getElementById('__EVENTVALIDATION')!
          .attributes['value']
          .toString();
      return form;
    });
  }

  Future<String?> getCookie(String useName, String passWord, Map form) {
    form['btnSubmit'] = 'Đăng nhập';
    form['txtUserName'] = '$useName';
    form['txtPassword'] = '$passWord';

    return Dio()
        .post(urlLogin, options: optionsGetCokies, data: form)
        .then((response) {
      return fomatCookies(response);
    });
  }

  String fomatCookies(Response<dynamic> response) {
    var listCookies = response.headers['Set-Cookie'].toString();
    return listCookies.split(';')[0].substring(1);
  }

  List<dynamic> json(Response res) {
    var schedule = mergeSchedule(getScheduleByClass(res, "cssListItem"),
        getScheduleByClass(res, "cssListAlternativeItem"));
    return schedule;
  }

  List<Map<String, dynamic>> getScheduleByClass(
      Response<dynamic> res, String className) {
    List<Map<String, dynamic>> schedule = [];
    var docs = parse(res.data).getElementsByClassName(className);

    docs.forEach((doc) {
      var datas = doc.getElementsByTagName("td");

      // phần tử thứ 0 là stt
      // phần tử thứ 1 là tên và mã môn
      // phần tử thứ 2 là mã học phần
      // phần tử thứ 3 là thời khóa biểu
      // phần tử thứ 4,5,6 là địa điểm, giáo viên , sĩ số,số tín chỉ
      String subject = datas[1].getElementsByTagName("b")[0].innerHtml.trim();
      String code = datas[2].getElementsByTagName("span")[0].innerHtml.trim();
      var location = getLocation(datas[4].innerHtml.trim());
      String teacher = datas[5].innerHtml.trim();
      var scheduleOfSubject = getScheduleOfSubject(
          datas[3].innerHtml, subject, location, teacher, code);
      schedule = mergeSchedule(schedule, scheduleOfSubject);
    });
    return schedule;
  }

  Map<String, dynamic> getLocation(String datas) {
    var locationDetail = datas.split(RegExp("<[^>]*>"));

    if (locationDetail.length > 1) {
      List<String> keys = [];
      var address = [];
      for (int index = 0; index < locationDetail.length; index++) {
        if (locationDetail[index].indexOf("\(") != -1) {
          keys.add(locationDetail[index].trim());
        } else if (locationDetail[index].trim().isNotEmpty) {
          address.add(locationDetail[index].trim());
        }
      }
      return Map.fromIterables(keys, address);
    } else {
      return {"only": locationDetail[0].trim()};
    }
  }

  List<Map<String, dynamic>> getScheduleOfSubject(String source, String subject,
      Map location, String teacher, String code) {
    var doc = source.trim().split("Từ ");
    doc.removeAt(0);
    List<Map<String, dynamic>> schedule = [];
    doc.forEach((docSchedule) {
      // lấy khoảng thời gian diễn ra sự kiện
      DateTimeRange period = getPeriodBroad(docSchedule);
      // lấy chu kì học
      var cycle =
          getCycle(docSchedule, period.start, subject, location, teacher, code);

      // lấy lịch môn hoc trong từng khoảng thời gian
      var scheduleForPeriod = getScheduleDetail(cycle, period);

      // gộp lịch học trong các khoảng thời gian
      schedule = mergeSchedule(schedule, scheduleForPeriod);
    });

    return schedule;
  }

  List<Map<String, dynamic>> mergeSchedule(
      List<Map<String, dynamic>> root, List<Map<String, dynamic>> other) {
    List<Map<String, dynamic>> newRoot = List.from(root);
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
          (newRoot[index]["sessions"] as List)
              .addAll(scheduleOfOther["sessions"]);
          // sắp xếp lại thời khóa biểu
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
      // phần tử số thứ tự có khi có từ 2 lịch
      var number = cycle[0].innerHtml.substring(1, 2);
      var keyOfNumber = locations.keys
          .firstWhere((element) => (element as String).indexOf(number) != -1);
      location = locations[keyOfNumber];
    } else {
      location = locations["only"];
    }
    if (cycle.length > 1) {
      // cắt bỏ phần tử số thứ tự
      cycle.removeAt(0);
    }

    cycle.forEach((session) {
      var lessons = session.innerHtml.split(" ");
      if (int.parse(lessons[1]) > start.weekday) {
        start = start
            .add(Duration(days: int.parse(lessons[1]) - start.weekday - 1));
      } else {
        start = start.add(Duration(
            days: 7 - (int.parse(lessons[1]) - start.weekday - 1).abs()));
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
    var dates = period.split(":")[0].split("đến");
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
        // chú thích lỗi qt 1
        // phải clone 1 biến mới vì nếu để giá trị gốc thì sẽ bị trùng địa chỉ
        // đến lúc đối giá trị sẽ đổi luôn giá trị tại vùng nhớ đó
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
