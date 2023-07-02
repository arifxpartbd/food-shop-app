import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/getxControllerFile/order_controller.dart';
import 'package:get/get.dart';

enum OrderStatus {
  processing,
  received,
  onTheWay,
  done,
}

class AdminOrdersScreen extends StatelessWidget {

  final OrderController _orderController = Get.find<OrderController>();


  final CollectionReference<Map<String, dynamic>> ordersCollection = FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Orders'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ordersCollection.snapshots(),
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

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Text('No orders available.'),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Order ID: ${orders[index].id}'),
                subtitle: Text('Status: ${orderData['status']}'),
                trailing: DropdownButton<OrderStatus>(
                  value: OrderStatus.values.firstWhere(
                        (status) => status.toString().split('.').last == orderData['status'],
                  ),
                  items: OrderStatus.values.map((status) {
                    return DropdownMenuItem<OrderStatus>(
                      value: status,
                      child: Text(status.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (newStatus) {
                    final orderId = orders[index].id;

                    // Update the order status
                    updateOrderStatus(orderId, newStatus!);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await ordersCollection.doc(orderId).update({'status': newStatus.toString().split('.').last});

    // Retrieve the order document
    DocumentSnapshot<Map<String, dynamic>> orderDoc = await ordersCollection.doc(orderId).get();

    // Get the device token from the order document
    String? deviceToken = orderDoc.data()?['deviceToken'];

    if (deviceToken != null) {
      // Send push notification
      print("my device token is: $deviceToken");
      _orderController.sendPushNotification(
        'Your order status has been updated to ${newStatus.toString().split('.').last.toLowerCase()}.',
        deviceToken,
      );
    }
  }

}
