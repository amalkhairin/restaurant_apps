import 'dart:convert';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/config/navigation.dart';
import 'package:restaurant_app/constant/routes_name.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();
 
class NotificationConfig {
  static NotificationConfig? _instance;
 
  NotificationConfig._internal() {
    _instance = this;
  }
 
  factory NotificationConfig() => _instance ?? NotificationConfig._internal();
 
  Future<void> initNotifications(
     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');

 
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
 
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        var data = Restaurant.fromJson(json.decode(payload!));
        var restaurant = data;
        Navigation.intentWithData(detailScreenRoute, restaurant);
        selectNotificationSubject.add(payload);
      }
    );
  }
 
  Future<void> showNotification( FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, RestaurantsResult restaurantsResult) async {
    var _channelId = "1234";
    var _channelName = "Tampilkan notifikasi";
    var _channelDescription = "Restaurant Channel"; 

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId, _channelName, _channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: const DefaultStyleInformation(true, true)
    );

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    
    Random rn = Random();
    var random = 0 + rn.nextInt(restaurantsResult.restaurants!.length - 0);

    var titleNotification = "<b>Recommendation</b>";
    var title = restaurantsResult.restaurants![random].name;

    await flutterLocalNotificationsPlugin.show(
      0, titleNotification, title, platformChannelSpecifics,
      payload: json.encode(restaurantsResult.restaurants![random].toJson())
    );
  }
 
  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = Restaurant.fromJson(json.decode(payload));
        var restaurant = data;
        Navigation.intentWithData(route, restaurant);
      },
    );
  }
}