import 'dart:isolate';

import 'dart:ui';
import '../../../main.dart';
import 'package:restaurant_app/config/api_config.dart';
import 'package:restaurant_app/config/notification/notification_config.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _service;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._createObject();

  factory BackgroundService() {
    _service ??= BackgroundService._createObject();
    return _service!;
  }

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    final NotificationConfig _notificationConfig = NotificationConfig();
    var result = await RestaurantAPI().getListOfRestaurant();
    await _notificationConfig.showNotification(flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}