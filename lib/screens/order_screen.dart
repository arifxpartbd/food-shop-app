import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // If no user is logged in, display a message or redirect to login
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view orders.'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('userId', isEqualTo: user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching orders.'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No orders available.'),
              );
            }
            final orders = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final itemsList = (data['items'] ?? []) as List<dynamic>; // Adjust the data type to List<dynamic>
              final items = List<String>.from(itemsList.map((item) => item.toString()));
              return Order(
                orderId: doc.id,
                userId: data['userId'].toString(), // Convert to string
                orderDate: (data['orderDate'] as Timestamp).toDate(),
                totalAmount: (data['totalAmount'] as num).toDouble(),
                items: items,
                status: OrderStatus.values.firstWhere(
                      (status) => status.toString().split('.').last == data['status'].toString(), // Convert to string
                ),
              );
            }).toList();


            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];
                return Card(
                  child: ListTile(
                    title: Text('Order ID: ${order.orderId}'),
                    subtitle: Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
                    trailing: Text('Status: ${order.status.toString().split('.').last}'),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
}

class Order {
  final String orderId;
  final String userId;
  final DateTime orderDate;
  final double totalAmount;
  final List<String> items;
  final OrderStatus status;

  Order({
    required this.orderId,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
    required this.status,
  });
}

enum OrderStatus {
  processing,
  pending,
  done,
  cancelled,
}
