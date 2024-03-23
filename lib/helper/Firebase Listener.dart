import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay/pay.dart';

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
    // Get the registration number dynamically
    String registrationNumber = "CNW 2266";

    // Listen for changes in Firestore parking sessions
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
                final duration = DateTime.now().difference(outTime).inMinutes;
                final parkingFee = calculateParkingFee(duration);
                initiatePayment(parkingFee);
                // Update payment status in Firestore after successful payment
                await change.doc.reference.update({'payment_status': 'paid'});
              }
            }
          } catch (error) {
            // Handle any errors during payment or Firestore operations
            print('Error processing payment: $error');
          }
        }
      }
    });
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {
    await parkingSessionsSubscription.cancel();
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    // Send a ping or data to the main app if needed
  }

  calculateParkingFee(int duration) {
    return "10";
  }
}
