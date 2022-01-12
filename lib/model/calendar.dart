import 'dart:math';

class CustomCalendar {
  DateTime date;

  CustomCalendar(
    this.date,
  );

  DateTime get dateLunar =>
      Calendar.convertSolar2Lunar(date.day, date.month, date.year);
}

class Calendar {
  static const TIMEZONE = 7;
  // năm nhuận
  static bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) return true;
        return false;
      }
      return true;
    }
    return false;
  }

  // lấy số ngày của tháng
  static int getDayOfMonth(int year, int month) {
    int day;
    switch (month) {
      case 1:
        day = 31;
        break;
      case 2:
        if (isLeapYear(year)) {
          day = 29;
        } else {
          day = 28;
        }

        break;
      case 3:
        day = 31;
        break;
      case 4:
        day = 30;
        break;
      case 5:
        day = 31;
        break;
      case 6:
        day = 30;
        break;
      case 7:
        day = 31;
        break;
      case 8:
        day = 31;
        break;
      case 9:
        day = 30;
        break;
      case 10:
        day = 31;
        break;
      case 11:
        day = 30;
        break;
      default:
        day = 31;
    }
    return day;
  }

  // lấy số trang lịch theo năm và tháng
  static List<DateTime> getYearMonth(int yearStart, int yearEnd) {
    List<DateTime> calendar = [];
    for (int i = yearStart; i <= yearEnd; i++) {
      for (int j = 1; j <= 12; j++) {
        calendar.add(DateTime(i, j));
      }
    }
    return calendar;
  }

  // lấy lịch theo tuần
  static List<CustomCalendar> getWeekCalendar(int year, int month, int day) {
    List<CustomCalendar> calendar = [];

    // trèn ngày ngày muốn lấy lịch vào
    calendar.add(CustomCalendar(DateTime(year, month, day)));

    // trèn những ngày trước thời gian muốn lấy
    while (calendar[0].date.weekday != 1) {
      int? y;
      int? m;
      int? d;
      if (calendar[0].date.day == 1) {
        if (calendar[0].date.month == 1) {
          // biến tạm lưu giá trị thêm
          y = calendar[0].date.year - 1;
          m = 12;
          d = getDayOfMonth(y, m);
        } else {
          y = calendar[0].date.year;
          m = calendar[0].date.month - 1;
          d = getDayOfMonth(y, m);
        }
      } else {
        y = calendar[0].date.year;
        m = calendar[0].date.month;
        d = calendar[0].date.day - 1;
      }
      if (m != month) {
        calendar.insert(0, CustomCalendar(DateTime(y, m, d)));
      } else {
        calendar.insert(0, CustomCalendar(DateTime(y, m, d)));
      }
    }

    // trèn những ngày sau thời gian muốn lấy
    while (calendar[calendar.length - 1].date.weekday != 7) {
      // biến tạm lưu giá trị thêm
      late int y;
      late int m;
      late int d;
      if (calendar[calendar.length - 1].date.day ==
          getDayOfMonth(year, month)) {
        if (calendar[calendar.length - 1].date.month == 12) {
          y = calendar[calendar.length - 1].date.year + 1;
          m = 1;
          d = 1;
        } else {
          y = calendar[calendar.length - 1].date.year;
          m = calendar[calendar.length - 1].date.month + 1;
          d = 1;
        }
      } else {
        y = calendar[calendar.length - 1].date.year;
        m = calendar[calendar.length - 1].date.month;
        d = calendar[calendar.length - 1].date.day + 1;
      }
      if (m != month) {
        calendar.insert(calendar.length, CustomCalendar(DateTime(y, m, d)));
      } else {
        calendar.insert(calendar.length, CustomCalendar(DateTime(y, m, d)));
      }
    }

    return calendar;
  }

  // lấy lịch trong tháng
  static List<CustomCalendar> getMonthCalendar(int year, int month) {
    List<CustomCalendar> calendar = [];
    int previousDays; // những ngày của tháng phía sau
    int nextDays; // những ngày của tháng phía trước
    int totalDay; // tổng số ngày tháng hiện tại
    int previousYear; // năm của những ngày phía sau
    int previousMonth; // tháng của những ngày phía sau
    int nextYear; //năm của những ngày phía trước
    int nextMonth; //năm của những ngày phía trước
    int totalPreviousDays; // tổng số ngày của tháng trước

    // trình tự những ngày có trong tháng
    totalDay = getDayOfMonth(year, month);
    for (int i = 1; i <= totalDay; i++) {
      calendar.add(CustomCalendar(DateTime(year, month, i)));
    }

    previousDays = (calendar[0]).date.weekday - 1;
    nextDays = 7 - calendar[totalDay - 1].date.weekday;

    // trèn những ngày phía sau còn trống
    if (calendar[0].date.month == 1) {
      previousMonth = 12;
      previousYear = calendar[0].date.year - 1;
    } else {
      previousMonth = calendar[0].date.month - 1;
      previousYear = calendar[0].date.year;
    }
    totalPreviousDays = getDayOfMonth(previousYear, previousMonth);
    for (int i = 0; i < previousDays; i++) {
      calendar.insert(
          0,
          CustomCalendar(
              DateTime(previousYear, previousMonth, totalPreviousDays - i)));
    }

    // trèn những ngày phía trước còn trống
    if (calendar[calendar.length - 1].date.month == 12) {
      nextMonth = 1;
      nextYear = calendar[calendar.length - 1].date.year + 1;
    } else {
      nextMonth = calendar[calendar.length - 1].date.month + 1;
      nextYear = calendar[calendar.length - 1].date.year;
    }
    for (int i = 1; i <= nextDays; i++) {
      calendar.insert(
          calendar.length, CustomCalendar(DateTime(nextYear, nextMonth, i)));
    }

    return calendar;
  }

  // đổi ngày sang số ngày julius

  static int jdFromDate(int dd, int mm, int yy) {
    var a, y, m, jd;
    a = (14 - mm) ~/ 12;
    y = yy + 4800 - a;
    m = mm + 12 * a - 3;
    jd = dd +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
    if (jd < 2299161) {
      jd = dd + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - 32083;
    }
    return jd;
  }

  // đổi số ngày julius sang ngày dương
  static List<int> jdToDate(int jd) {
    var a, b, c, d, e, m, day, month, year;
    if (jd > 2299160) {
      a = jd + 32044;
      b = (4 * a + 3) ~/ 146097;
      c = a - (b * 146097) ~/ 4;
    } else {
      b = 0;
      c = jd + 32082;
    }
    d = (4 * c + 3) ~/ 1461;
    e = c - (1461 * d) ~/ 4;
    m = (5 * e + 2) ~/ 153;
    day = e - (153 * m + 2) ~/ 5 + 1;
    month = m + 3 - 12 * (m ~/ 10);
    year = b * 100 + d - 4800 + m ~/ 10;
    return [day, month, year];
  }

  //tính ngày sóc
  static int getNewMoonDay(int k, {timeZone = TIMEZONE}) {
    var T, t2, t3, dr, jD1, m, mpr, f, c1, deltat, jDnew;
    T = k / 1236.85; // Time in Julian centuries from 1900 January 0.5
    t2 = T * T;
    t3 = t2 * T;
    dr = pi / 180;
    jD1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3;
    jD1 = jD1 +
        0.00033 *
            sin((166.56 + 132.87 * T - 0.009173 * t2) * dr); // Mean new moon
    m = 359.2242 +
        29.10535608 * k -
        0.0000333 * t2 -
        0.00000347 * t3; // Sun's mean anomaly
    mpr = 306.0253 +
        385.81691806 * k +
        0.0107306 * t2 +
        0.00001236 * t3; // Moon's mean anomaly
    f = 21.2964 +
        390.67050646 * k -
        0.0016528 * t2 -
        0.00000239 * t3; // Moon's argument of latitude
    c1 = (0.1734 - 0.000393 * T) * sin(m * dr) + 0.0021 * sin(2 * dr * m);
    c1 = c1 - 0.4068 * sin(mpr * dr) + 0.0161 * sin(dr * 2 * mpr);
    c1 = c1 - 0.0004 * sin(dr * 3 * mpr);
    c1 = c1 + 0.0104 * sin(dr * 2 * f) - 0.0051 * sin(dr * (m + mpr));
    c1 = c1 - 0.0074 * sin(dr * (m - mpr)) + 0.0004 * sin(dr * (2 * f + m));
    c1 = c1 - 0.0004 * sin(dr * (2 * f - m)) - 0.0006 * sin(dr * (2 * f + mpr));
    c1 = c1 +
        0.0010 * sin(dr * (2 * f - mpr)) +
        0.0005 * sin(dr * (2 * mpr + m));
    if (T < -11) {
      deltat = 0.001 +
          0.000839 * T +
          0.0002261 * t2 -
          0.00000845 * t3 -
          0.000000081 * T * t3;
    } else {
      deltat = -0.000278 + 0.000265 * T + 0.000262 * t2;
    }

    jDnew = jD1 + c1 - deltat;
    return (jDnew + 0.5 + timeZone / 24).toInt();
  }

  //tính tọa độ mặt trời`
  static int getSunLongitude(int jdn, {timeZone = TIMEZONE}) {
    var T, t2, dr, m, l0, dl, l;
    T = (jdn - 2451545.5 - timeZone / 24) /
        36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
    t2 = T * T;
    dr = pi / 180; // degree to radian
    m = 357.52910 +
        35999.05030 * T -
        0.0001559 * t2 -
        0.00000048 * T * t2; // mean anomaly, degree
    l0 = 280.46645 + 36000.76983 * T + 0.0003032 * t2; // mean longitude, degree
    dl = (1.914600 - 0.004817 * T - 0.000014 * t2) * sin(dr * m);
    dl = dl +
        (0.019993 - 0.000101 * T) * sin(dr * 2 * m) +
        0.000290 * sin(dr * 3 * m);
    l = l0 + dl; // true longitude, degree
    l = l * dr;
    l = l - pi * 2 * (l ~/ (pi * 2)); // Normalize to (0, 2*pi)
    return (l / pi * 6).toInt();
  }

  // tìm ngày bắt đầu tháng 11 âm lịch
  static int getLunarMonth11(int yy, {timeZone = TIMEZONE}) {
    var k, off, nm, sunLong;
    off = jdFromDate(31, 12, yy) - 2415021;
    k = off ~/ 29.530588853;
    nm = getNewMoonDay(k);
    sunLong = getSunLongitude(nm); // sun longitude at local midnight
    if (sunLong >= 9) {
      nm = getNewMoonDay(k - 1);
    }
    return nm;
  }

  //xác định tháng nhuận
  static int getLeapMonthOffset(a11, {timeZone = TIMEZONE}) {
    var k, last, arc, i;
    k = ((a11 - 2415021.076998695) / 29.530588853 + 0.5).toInt();
    last = 0;
    i = 1; // We start with the month following lunar month 11
    arc = getSunLongitude(getNewMoonDay(k + i));
    do {
      last = arc;
      i++;
      arc = getSunLongitude(getNewMoonDay(k + i));
    } while (arc != last && i < 14);
    return i - 1;
  }

  static DateTime convertSolar2Lunar(dd, mm, yy, {timeZone = TIMEZONE}) {
    var k, dayNumber, monthStart, a11, b11, lunarDay, lunarMonth, lunarYear;

    dayNumber = jdFromDate(dd, mm, yy);
    k = ((dayNumber - 2415021.076998695) / 29.530588853).toInt();
    monthStart = getNewMoonDay(k + 1);
    if (monthStart > dayNumber) {
      monthStart = getNewMoonDay(k);
    }
    a11 = getLunarMonth11(yy);
    b11 = a11;
    if (a11 >= monthStart) {
      lunarYear = yy;
      a11 = getLunarMonth11(yy - 1);
    } else {
      lunarYear = yy + 1;
      b11 = getLunarMonth11(yy + 1);
    }
    lunarDay = dayNumber - monthStart + 1;
    var diff = (monthStart - a11) ~/ 29;

    lunarMonth = diff + 11;
    if (b11 - a11 > 365) {
      int leapMonthDiff = getLeapMonthOffset(a11);
      if (diff >= leapMonthDiff) {
        lunarMonth = diff + 10;
      }
    }
    if (lunarMonth > 12) {
      lunarMonth = lunarMonth - 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
      lunarYear -= 1;
    }
    return DateTime(lunarYear, lunarMonth, lunarDay);
  }

  // lấy danh sách các tuần
  static List<DateTime> fillWeek(
      final DateTime startDay, final DateTime endDay) {
    List<DateTime> list = [];
    DateTime s = startDay;
    DateTime e = endDay;
    // điền ngày đầu tiên
    if (s.weekday != 1) {
      int nd = 7 - s.weekday + 1;
      s = DateTime(s.year, s.month, s.day + nd);
    }
    list.add(s);

    // định dạng ngày cuối cùng
    if (e.weekday != 7) {
      e = e.subtract(Duration(days: e.weekday + 1));
    }

    while (DateTime(list[list.length - 1].year, list[list.length - 1].month,
            list[list.length - 1].day + 7)
        .isBefore(e)) {
      list.add(DateTime(list[list.length - 1].year, list[list.length - 1].month,
          list[list.length - 1].day + 7));
    }

    return list;
  }

  // lấy danh sách các tháng
  static List<DateTime> fillMonth(DateTime startDay, DateTime endDay) {
    List<DateTime> list = [];
    for (int i = startDay.year; i <= endDay.year; i++) {
      for (int j = 1; j <= 12; j++) {
        list.add(DateTime(i, j));
      }
    }
    return list;
  }

  // lấy danh sách ngày
  static List<DateTime> fillDays(
      final DateTime startDay, final DateTime endDay) {
    List<DateTime> list = [];
    DateTime s = startDay;
    DateTime e = endDay;
    // điền ngày đầu tiên
    if (s.weekday != 1) {
      int nd = 7 - s.weekday + 1;
      s = DateTime(s.year, s.month, s.day + nd);
      
    }
    list.add(s);
    // định dạng ngày cuối cùng
    if (e.weekday != 7) {
      e = e.subtract(Duration(days: e.weekday + 1));
    }

    while (DateTime(list[list.length - 1].year, list[list.length - 1].month,
            list[list.length - 1].day + 1)
        .isBefore(e)) {
      list.add(DateTime(list[list.length - 1].year, list[list.length - 1].month,
          list[list.length - 1].day + 1));
    }

    return list;
  }
}
