import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:checkout_screen_ui/checkout_ui.dart';
import 'package:checkout_screen_ui/models/checkout_result.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_parking/helper/Payments.dart';

import '../const.dart';

class PaymentDetails extends StatelessWidget {
  const PaymentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: calculateTotalAmountDue(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          int totalAmountDue = snapshot.data?.toInt() ?? 0;
          return Scaffold(
            body: CheckoutPage(
              data: CheckoutData(
                priceItems: [
                  PriceItem(name: 'Parking Session', quantity: totalAmountDue~/5 , itemCostCents: 500),
                ],
                payToName: 'Smart Parking',
                displayNativePay: true,
                onNativePay: (checkoutResults) => _nativePayClicked(context,totalAmountDue),
            
                taxRate: 0.05, onCardPay: (CardFormResults results, CheckOutResult checkOutResult) {  },
              ),
            ),
          );
        }
      },
    );
  }

  // Function to calculate total amount due based on payment status
  Future<int> calculateTotalAmountDue() async {
    // Count the number of unpaid sessions
    int unpaidSessionsCount = 0;

    // Fetch documents from Firestore collection 'detected_texts'
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('detected_texts').get();

    // Iterate through documents
    for (var document in querySnapshot.docs) {
      // Explicitly cast document data to Map<String, dynamic>
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // Check if the document has exactly two fields and 'text' field matches the registration
      if (data.length == 2 && data['text'] == ProfileData.userData['Reg']) {
        unpaidSessionsCount++;
      }
    }
    // Calculate total amount due based on $5 cost per session
    int totalAmountDue = unpaidSessionsCount * 5;

    return totalAmountDue;
  }

  // Function to handle the native pay button being clicked
  Future<void> _nativePayClicked(BuildContext context,int amount) async {
   initiatePayment(amount.toString());
  }



  // Function to handle submission of credit card form
  Future<void> _creditPayClicked(
      CardFormResults results, CheckOutResult checkOutResult) async {
    // Implement your credit card payment logic here
    print(results);
    // WARNING: you should NOT print the above out using live code

    for (PriceItem item in checkOutResult.priceItems) {
      print('Item: ${item.name} - Quantity: ${item.quantity}');
    }

    final String subtotal =
    (checkOutResult.subtotalCents / 100).toStringAsFixed(2);
    print('Subtotal: \$$subtotal');

    final String tax = (checkOutResult.taxCents / 100).toStringAsFixed(2);
    print('Tax: \$$tax');

    final String total =
    (checkOutResult.totalCostCents / 100).toStringAsFixed(2);
    print('Total: \$$total');
  }
}
