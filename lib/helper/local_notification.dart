import 'dart:convert';

import 'package:find_dropdown/rxdart/behavior_subject.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;

  void onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('myDataEncode2', payload);
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotification {
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  Future<void> initializeLocalNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              didReceiveLocalNotificationSubject.add(
                ReceivedNotification(
                  id: id,
                  title: title,
                  body: body,
                  payload: payload,
                ),
              );
            });
    // app_icon needs to be a added as a drawable resource to the
    // Android head project
    // var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsIOS = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> showNotification(RemoteMessage payload) async {
    final prefs = await SharedPreferences.getInstance();

    final dynamic data = payload.data;
    final dynamic notification = payload.notification;
    int? idNotification;
    if (data['golid'] != null) {
      idNotification = int.parse(data['golid']);
    } else {
      idNotification = 1;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'herbani',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      showProgress: true,
      enableVibration: true,
      channelShowBadge: true,
      ticker: 'ticker',
      enableLights: true,
      color: Color.fromARGB(255, 255, 0, 0),
      ledColor: Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      fullScreenIntent: false,
      styleInformation: BigTextStyleInformation('', htmlFormatBigText: true),
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(
            threadIdentifier: 'thread_id',
            presentAlert: false,
            presentBadge: false,
            presentSound: false);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
    var myData = jsonEncode(data);
    await prefs.setString('myDataEncode', myData);
    await flutterLocalNotificationsPlugin.show(idNotification,
        notification.title, notification.body, platformChannelSpecifics,
        payload: myData.toString());

    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(payload) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('myDataEncode2', payload!);
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
