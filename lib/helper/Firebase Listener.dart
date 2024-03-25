import 'dart:async';
import 'dart:isolate';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pay/pay.dart';
import 'package:smart_parking/const.dart';

import '../firebase_options.dart';
import 'Payments.dart';

@pragma('vm:entry-point')
void startForegroundTaskCallback() {
  if (kDebugMode) {
    print("Starting Payment Listener Service");
  }
  FlutterForegroundTask.setTaskHandler(ForegroundServicePaymentHandler());
}

class ForegroundServicePaymentHandler extends TaskHandler {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> parkingSessionsSubscription;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    initNotifications();
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    var data = await fireStore.collection("User Info").doc(FirebaseAuth.instance.currentUser!.uid).get();
    ProfileData.assignData(data.data());
    String registrationNumber = ProfileData.userData['Reg'];
    if (kDebugMode) {
      print("Connecting to Firestore DB");
      print(registrationNumber);
    }
    try {
      parkingSessionsSubscription = FirebaseFirestore.instance
          .collection('detected_texts')
          .where('text', isEqualTo: registrationNumber) // No payment status field
          .snapshots()
          .listen((snapshot) async {
        for (final change in snapshot.docChanges) {
          if (kDebugMode) {
            print("Change Found");
          }
          if (change.type == DocumentChangeType.added || change.type == DocumentChangeType.modified) {
            final parkingSession = change.doc.data();
            if (kDebugMode) {
              print("Sending Notifs");
            }
            // Send notification if registration number matches and no payment status field exists
            sendNotification();
          }
        }
      });
    } catch (error) {
      print('Error subscribing to Firestore: $error');
    }
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {
    await parkingSessionsSubscription.cancel();
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
    // No repeat event needed in this case
  }

  void sendNotification() {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
      flutterLocalNotificationsPlugin.show(
        0,
        'New Parking Session',
        'A new parking session is detected. Please check your app for details.',
        notificationDetails,
      );
    } catch (error) {
      print('Error sending notification: $error');
    }
  }

  initNotifications() async {

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(
        defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  }

  Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    // Handle the notification response as needed, e.g., navigate to a different screen
  }

  Future<void> onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    // Handle the local notification as needed
  }

}
