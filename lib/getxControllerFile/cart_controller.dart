import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/models/cart_item_model.dart';
import 'package:food_delivery_app/models/product_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final CollectionReference _cartRef =
  FirebaseFirestore.instance.collection("carts");

  final CollectionReference _favRef =
  FirebaseFirestore.instance.collection("favorite");

  final RxMap<String, dynamic> _cartItems = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> _favItems = <String, dynamic>{}.obs;

  Map<String, dynamic> get cartItems => _cartItems;
  Map<String, dynamic> get favItems => _favItems;

  Stream<Map<String, dynamic>> get cartStream => _cartRef
      .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
      .snapshots()
      .map((snapshot) => snapshot.data() as Map<String, dynamic>);

  void addToCart(Product product, int quantity) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";
    final cartData = _cartItems[userId];

    if (cartData != null && cartData['items'] != null) {
      final List<dynamic> items = cartData['items'];

      final index = items.indexWhere((item) => item['id'] == product.id);
      if (index != -1) {
        items[index]['quantity'] += quantity;
      } else {
        items.add({
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'quantity': quantity,

        });
      }
      update();
    } else {
      _cartItems[userId] = {
        'items': [
          {
            'id': product.id,
            'name': product.name,
            'price': product.price,
            'quantity': quantity,

          }
        ]
      };
    }

    await _cartRef.doc(userId).update(_cartItems[userId]); // Update the document in Firestore

    _cartRef.doc(userId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        _cartItems[userId] = data;
        update();
      }
    });

    update();
  }

  void removeFromCart(Product product) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";
    final cartData = _cartItems[userId];

    if (cartData != null && cartData['items'] != null) {
      final List<dynamic> items = cartData['items'];
      final index = items.indexWhere((item) => item['id'] == product.id);

      if (index != -1) {
        final int newQuantity = items[index]['quantity'] - 1;

        if (newQuantity > 0) {
          items[index]['quantity'] = newQuantity;
        } else {
          items.removeAt(index);
        }
      }
    }

    await _cartRef.doc(userId).update(_cartItems[userId]); // Update the document in Firestore

    update();
  }

  void addToFav(Product product) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";
    final favData = _favItems[userId];

    if (favData != null && favData['items'] != null) {
      final List<dynamic> items = favData['items'];

      final index = items.indexWhere((item) => item['id'] == product.id);
      if (index != -1) {
        items[index]['quantity']++;
      } else {
        items.add({
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'quantity': 1,
        });
      }
      update();
    } else {
      _favItems[userId] = {
        'items': [
          {
            'id': product.id,
            'name': product.name,
            'price': product.price,
            'quantity': 1,
          }
        ]
      };
    }

    await _favRef.doc(userId).set(_favItems[userId]);
    update();
  }

  void removeFromFav(Product product) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";
    final cartData = _cartItems[userId];

    if (cartData != null && cartData['items'] != null) {
      final List<dynamic> items = cartData['items'];
      final index = items.indexWhere((item) => item['id'] == product.id);

      if (index != -1) {
        final int newQuantity = items[index]['quantity'] - 1;

        if (newQuantity > 0) {
          items[index]['quantity'] = newQuantity;
        } else {
          items.removeAt(index);
        }
      }
    }

    await _cartRef.doc(userId).update(_cartItems[userId]); // Update the document in Firestore

    update();
  }

  void increaseQuantity(Product product) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";
    final cartData = _cartItems[userId];

    if (cartData != null && cartData['items'] != null) {
      final List<dynamic> items = cartData['items'];
      final index = items.indexWhere((item) => item['id'] == product.id);

      if (index != -1) {
        items[index]['quantity']++;
      }
    }

    await _cartRef.doc(userId).update(_cartItems[userId]); // Update the document in Firestore

    update();
  }

  void decreaseQuantity(Product product) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";
    final cartData = _cartItems[userId];

    if (cartData != null && cartData['items'] != null) {
      final List<dynamic> items = cartData['items'];
      final index = items.indexWhere((item) => item['id'] == product.id);

      if (index != -1) {
        final int newQuantity = items[index]['quantity'] - 1;

        if (newQuantity > 0) {
          items[index]['quantity'] = newQuantity;
        } else {
          items.removeAt(index);
        }
      }
    }

    await _cartRef.doc(userId).update(_cartItems[userId]); // Update the document in Firestore

    update();
  }

  CartItem? getCartItem(Product product) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";
    final cartData = _cartItems[userId];

    if (cartData != null && cartData['items'] != null) {
      final List<dynamic> items = cartData['items'];
      final index = items.indexWhere((item) => item['id'] == product.id);

      if (index != -1) {
        final itemData = items[index];
        return CartItem.fromMap(itemData);
      }
    }

    return null;
  }


  double get totalPrice {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";
    final cartData = _cartItems[userId];

    double total = 0;

    if (cartData != null && cartData['items'] != null) {
      final List<dynamic> items = cartData['items'];

      for (var item in items) {
        final Product product = Product.fromMap(item, item['id']);
        final double price = product.price;
        final int quantity = item['quantity'];

        total += price * quantity;
      }
    }

    return total;
  }
}
