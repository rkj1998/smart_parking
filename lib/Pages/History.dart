import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../const.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('detected_texts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No data available.'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var document = snapshot.data!.docs[index];
                // Ensure document data is correctly typed
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                // Replace 'registrationNumber' with the actual registration number saved in your system
                if (data['text'] == ProfileData.userData['Reg']) {
                  bool isPaid = data.length == 3; // Check if the document has 2 fields
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: const Text('Parking Session Details'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Timestamp: ${data['timestamp']}'),
                          Text('Status: ${isPaid ? 'Paid' : 'Unpaid'}'),
                        ],
                      ),
                      tileColor: isPaid ? Colors.green : Colors.red, // Green for paid, red for unpaid
                    ),
                  );
                } else {
                  // Return an empty container if the registration number doesn't match
                  return Container();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
