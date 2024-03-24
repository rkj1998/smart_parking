// payment_helper.dart
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
  // Handle Google Pay payment result
  // Send the resulting Google Pay token to your server / PSP
}
