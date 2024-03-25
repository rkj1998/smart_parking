// payment_helper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pay/pay.dart';
import 'package:smart_parking/const.dart';

void initiatePayment(String amount) async {
  // Initialize pay client with your payment configurations
  final payClient = Pay({
    PayProvider.google_pay: PaymentConfiguration.fromJsonString(defaultGooglePay),
    PayProvider.apple_pay: PaymentConfiguration.fromJsonString(defaultApplePay),
  });

 var paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: amount,
      status: PaymentItemStatus.final_price,
    )
  ];

  // Check if user can pay with Google Pay
  final canPayWithGooglePay = await payClient.userCanPay(PayProvider.google_pay);

  if (canPayWithGooglePay) {
    // Show Google Pay button
    final result = await payClient.showPaymentSelector(
      PayProvider.google_pay,
      paymentItems, // Assuming _paymentItems is defined somewhere accessible
    );
    // Handle payment result
    onGooglePayResult(result);
  } else {
    // User cannot pay with Google Pay, handle accordingly
    // Consider showing an alternative payment method
  }
}
 void onGooglePayResult(paymentResult) {

      // Get the registration number from your system
      String registrationNumber = ProfileData.userData['Reg'];

      // Iterate through documents in the 'detected_texts' collection
      FirebaseFirestore.instance
          .collection('detected_texts')
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          // Compare the 'text' field with the registration number
          if (doc.data()['text'] == registrationNumber) {
            // Check if document has exactly two fields
            if (doc.data().length == 2) {
              // Update the document to mark it as paid
              doc.reference.update({'isPaid': true});
            }
          }
        }
      }).catchError((error) {
        if (kDebugMode) {
          print('Error updating documents: $error');
        }
      });
    }

