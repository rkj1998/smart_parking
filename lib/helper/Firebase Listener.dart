import 'dart:async';
import 'dart:isolate';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay/pay.dart';
import 'package:smart_parking/const.dart';

import '../firebase_options.dart';
import 'Payments.dart';

// ... other required imports

// ... functions for getUserRegistrationNumber(), calculateParkingFee(), initiatePayment()

// Top-level function for the service handler
@pragma('vm:entry-point')
void startForegroundTaskCallback() {
  if (kDebugMode) {
    print("Starting Payment Listener Service");
  }
  FlutterForegroundTask.setTaskHandler(ForegroundServicePaymentHandler());
}

class ForegroundServicePaymentHandler extends TaskHandler {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> parkingSessionsSubscription;

  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

        FirebaseFirestore fireStore = FirebaseFirestore.instance;
        var data = await fireStore.collection("User Info").doc(FirebaseAuth.instance.currentUser!.uid).get();
        ProfileData.assignData(data.data());
    String registrationNumber = ProfileData.userData['Reg'];
    if (kDebugMode) {
      print("Connecting to Firestore DB");
      print(registrationNumber);
    }
    try {
      print(FirebaseFirestore.instance
          .collection('parking_sessions')
          .where('registration_number', isEqualTo: registrationNumber)
          .snapshots());
      parkingSessionsSubscription = FirebaseFirestore.instance
          .collection('parking_sessions')
          .where('registration_number', isEqualTo: registrationNumber)
          .snapshots()
          .listen((snapshot) async {
        for (final change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added ||
              change.type == DocumentChangeType.modified) {
            try {
              final parkingSession = change.doc.data();
              final paymentStatus = parkingSession?['payment_status'];
              if (paymentStatus != 'paid') {
                final outTime = parkingSession?['out_time'];
                if (outTime != null) {
                  final duration =
                      DateTime.now().difference(outTime.toDate()).inMinutes;
                  final parkingFee = calculateParkingFee(duration);
                  initiatePayment('10');
                  await change.doc.reference
                      .update({'payment_status': 'paid'});
                }
              }
            } catch (error) {
              print('Error processing document: $error');
            }
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

  int calculateParkingFee(int duration) {
    // Implement your logic to calculate parking fee
    return 10;
  }
}

