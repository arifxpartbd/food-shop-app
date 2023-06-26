import 'package:cloud_firestore/cloud_firestore.dart';


enum OrderStatus {
  processing,
  pending,
  done,
  cancelled,
}

class Order {
  final String orderId;
  final String userId;
  final DateTime orderDate;
  final double totalAmount;
  final List<String> items;
  OrderStatus status;

  Order({
    required this.orderId,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
    this.status = OrderStatus.pending,
  });
}

class OrderController {
  List<Order> orders = [];
  CollectionReference<Map<String, dynamic>> ordersCollection =
  FirebaseFirestore.instance.collection('orders');

  Future<void> placeOrder(Order order) async {
    try {
      // Save the order to Firestore
      await ordersCollection.add({
        'orderId': order.orderId,
        'userId': order.userId,
        'orderDate': order.orderDate,
        'totalAmount': order.totalAmount,
        'items': order.items,
        'status': order.status.toString(),
      });

      // Update the local orders list
      orders.add(order);
    } catch (e) {
      // Handle the error
      print('Failed to place order: $e');
    }
  }
}