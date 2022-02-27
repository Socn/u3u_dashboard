import 'package:u3u_panel/classes.dart' as classes;
import 'package:flutter/material.dart';
import 'dart:ui';

class MyColors{
  static const Color mainText = Colors.black;
  static const Color secondaryText = Colors.black38;
  static const Color accentColor = Colors.blueAccent;
  static const Color blockColor = Color.fromARGB(255, 240, 240, 240);
  static const Color iconColor = Colors.black;
  static const Color iconColorDisabled = secondaryText;
}

Map<String,dynamic> config={
  'msg': '',
  'token': '',
  'id': 0
};
classes.User? userInfo;

Map<String,dynamic> settings={
  'host': 'https://u3u.wsm.ink',
  'initPage': "none"
};

class RelativeDateFormat {
  static const num oneMinute = 60000;
  static const num oneHour = 3600000;
  static const num oneDay = 86400000;
  static const num oneWeek = 604800000;

  static const String oneSecondAgo = "秒前";
  static const String oneMinuteAgo = "分钟前";
  static const String oneHourAgo = "小时前";
  static const String oneDayAgo = "天前";
  static const String oneMonthAgo = "月前";
  static const String oneYearAgo = "年前";

//时间转换
  static String format(DateTime date) {
    num delta = DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    if (delta < 1 * oneMinute) {
      num seconds = toSeconds(delta);
      return (seconds <= 0 ? 1 : seconds).toInt().toString() + oneSecondAgo;
    }
    if (delta < 45 * oneMinute) {
      num minutes = toMinutes(delta);
      return (minutes <= 0 ? 1 : minutes).toInt().toString() + oneMinuteAgo;
    }
    if (delta < 24 * oneHour) {
      num hours = toHours(delta);
      return (hours <= 0 ? 1 : hours).toInt().toString() + oneHourAgo;
    }
    if (delta < 48 * oneHour) {
      return "昨天";
    }
    if (delta < 30 * oneDay) {
      num days = toDays(delta);
      return (days <= 0 ? 1 : days).toInt().toString() + oneDayAgo;
    }
    if (delta < 12 * 4 * oneWeek) {
      num months = toMonths(delta);
      return (months <= 0 ? 1 : months).toInt().toString() + oneMonthAgo;
    } else {
      num years = toYears(delta);
      return (years <= 0 ? 1 : years).toInt().toString() + oneYearAgo;
    }
  }

  static num toSeconds(num date) {
    return date / 1000;
  }

  static num toMinutes(num date) {
    return toSeconds(date) / 60;
  }

  static num toHours(num date) {
    return toMinutes(date) / 60;
  }

  static num toDays(num date) {
    return toHours(date) / 24;
  }

  static num toMonths(num date) {
    return toDays(date) / 30;
  }

  static num toYears(num date) {
    return toMonths(date) / 365;
  }
}



