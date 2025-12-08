import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    
    await _messaging.requestPermission();

  
    String? token = await _messaging.getToken();
    debugPrint("FCM Token: $token");

    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Notification Received: ${message.notification?.title}");
    });

  
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Opened from Notification");
    });
  }
}
