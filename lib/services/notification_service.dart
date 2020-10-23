import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class INotificationService {
  Future<void> init();
  Future<void> send(String title, String body, {String payload});
}

class NotificationService implements INotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  final androidDetails = AndroidNotificationDetails('ioaisdoisdo123!!ks',
      'SportsGuideChannel', 'Channel for sports guide notifications');

  @override
  Future<void> init() async {
    await notificationPlugin.initialize(
        InitializationSettings(
          android: AndroidInitializationSettings('icon'),
        ), onSelectNotification: (payload) async {
      print('notification: $payload');
    });
  }

  @override
  Future<void> send(String title, String body, {String payload}) async {
    await notificationPlugin.show(
        1, title, body, NotificationDetails(android: androidDetails),
        payload: payload);
  }
}
