//@dart=2.8
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

import 'package:rxdart/rxdart.dart';

class LocalNotifyManager{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  LocalNotifyManager.init(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>().requestPermissions(
        alert: true,
        badge: true,
        sound: true
    );
  }
  initializePlatform(){
    var initSettingAndroid = const AndroidInitializationSettings('app_notification_icon');
    var initSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true,
        onDidReceiveLocalNotification: (id,title,body,payload) async{
          ReceiveNotification notification = ReceiveNotification(id: id,title: title,body: body,payload: payload);
          didReceiveNotificationSubject.add(notification);
        }
    );
    initSetting = InitializationSettings(android: initSettingAndroid,iOS: initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive){
    didReceiveNotificationSubject.listen((value) {
      onNotificationReceive(value);
    });
  }

  Future<void> showNotification(ReceiveNotification notification) async{
    var androidChannel = const AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var iosChannel = IOSNotificationDetails();
    var platfornChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(notification.id, notification.title, notification.body, platfornChannel);
  }

  Future<void> scheduleNotification(ReceiveNotification notification) async{
    var androidChannel = const AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    var iosChannel = IOSNotificationDetails();
    var platfornChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.schedule(notification.id, notification.title, notification.body,notification.scheduleDate, platfornChannel);
  }

  Future<void> deleteNotification(ReceiveNotification notification) async{
    await flutterLocalNotificationsPlugin.cancel(notification.id);
  }

  setOnNotificationClick(Function onNotificationClick) async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String payload) async{
      onNotificationClick(payload);
    });
  }

}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceiveNotification{
  int id;
  String title,body,payload;
  DateTime scheduleDate;

  ReceiveNotification({this.id,this.title,this.body,this.payload,this.scheduleDate});

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'body': body,
      'schedule_date': scheduleDate.toString(),
    };
  }

  factory ReceiveNotification.fromMap(Map<String, dynamic> map) {
    return ReceiveNotification(
      id:map["id"],
      title:map["title"],
      body:map["body"],
      scheduleDate: DateTime.parse(map["schedule_date"]),
    );
  }

}