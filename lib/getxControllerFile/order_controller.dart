import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

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

class OrderController extends GetxController {
  List<Order> orders = [];
  CollectionReference<Map<String, dynamic>> ordersCollection =
  FirebaseFirestore.instance.collection('orders');

  @override
  void onInit() {
    fetchOrders(); // Fetch orders when the controller initializes
    super.onInit();
  }


  Future<void> fetchOrders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final querySnapshot = await ordersCollection
          .where('userId', isEqualTo: userId)
          .get();

      orders = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final items = data['items'];

        List<String> itemsList;
        if (items is String) {
          itemsList = [items];
        } else if (items is List) {
          itemsList = List<String>.from(items);
        } else {
          itemsList = [];
        }

        return Order(
          orderId: doc.id,
          userId: data['userId'],
          orderDate: data['orderDate'].toDate(),
          totalAmount: data['totalAmount'],
          items: itemsList,
          status: OrderStatus.values.firstWhere(
                (status) => status.toString().split('.').last == data['status'],
          ),
        );
      }).toList();

      update(); // Notify GetBuilder to rebuild the UI
    }
  }

  Future<void> placeOrder(String paymentMethod, double totalAmount) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";

    final cartDataSnapshot = await FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .get();
    final Map<String, dynamic>? cartData = cartDataSnapshot.data();

    if (cartData != null && cartData['items'] != null) {
      // Get the list of items from the cart data
      final List<dynamic> items = cartData['items'];

      // Perform any necessary operations for order placement
      // (e.g., saving to Firestore, updating order status, etc.)
      final orderId =
      await saveOrderToFirestore(userId, items, paymentMethod,totalAmount);

      // Clear the cart items after placing the order
      clearCart(userId);

      if (kDebugMode) {
        print('Order placed with payment method: $paymentMethod');
        print('Order ID: $orderId');
      }

      fetchOrders(); // Fetch the updated list of orders
    } else {
      if (kDebugMode) {
        print('No items in the cart.');
      }
    }
  }

  Future<String> saveOrderToFirestore(
      String userId, List<dynamic> items, String paymentMethod, double totalAmount) async {
    final orderData = {
      'userId': userId,
      'items': items,
      'paymentMethod': paymentMethod,
      'status': 'pending',
      'orderDate': DateTime.now(),
      'totalAmount':totalAmount
      // Add any other necessary order details
    };

    final newOrderDoc = await ordersCollection.add(orderData);

    return newOrderDoc.id;
  }

  void clearCart(String userId) async {
    final cartRef = FirebaseFirestore.instance.collection('carts');
    final cartDataSnapshot =
    await FirebaseFirestore.instance.collection('carts').doc(userId).get();
    final Map<String, dynamic>? cartData = cartDataSnapshot.data();

    if (cartData != null && cartRef != null) {
      cartData['items'] = null;
      await cartRef.doc(userId).update({'items': null});
    }
  }

// Rest of the code...
}
