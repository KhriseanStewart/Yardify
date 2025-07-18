import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yardify/routes.dart';

class NotificationService {
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  final db = FirebaseFirestore.instance;

  //get token
  Future<void> saveToken(String uid, String token) async {
    String? platform;
    if (Platform.isAndroid) {
      platform = "android";
    } else {
      platform = "iphone";
    }
    await db
        .collection("users")
        .doc(uid)
        .collection("messaging")
        .doc("deviceToken")
        .set({"token": token, "device": platform});
  }

  Future<String?> getToken(String uid) async {
    final doc = await db
        .collection("users")
        .doc(uid)
        .collection("messaging")
        .doc(uid)
        .get();
    if (doc.exists) {
      return doc.data()?['token'] as String?;
    } else {
      return null;
    }
  }

  void pushToken(String uid) async {
    String? token = await fcm.getToken();
    print("FCM TOKEN: $token");
    if (token != null) {
      saveToken(uid, token);
    } else {
      print("Null token");
      return;
    }
  }

  //forground messaging
  void firebaseMessaging(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "N/A";
      final body = message.notification?.body ?? "N/A";
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(
            body,
            maxLines: 1,
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),
          actions: [
            TextButton(
              onPressed: () {
                //Push to notification screen
              },
              child: Text("Next"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        ),
      );
    });
  }

  void backgroundNotification(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "N/A";
      final body = message.notification?.body ?? "N/A";
      Navigator.pushNamed(context, AppRouter.forgetpassword);
      print("something here");
    });
  }

  void terminatedApp(BuildContext context) {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final title = message.notification?.title ?? "N/A";
        final body = message.notification?.body ?? "N/A";
        Navigator.pushNamed(context, AppRouter.forgetpassword);
        print("here too");
      } else {
        print("error");
      }
    });
  }
}
