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

  void addToCart(Product product, int quantity) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";
    final cartData = _cartItems[userId];

    if (cartData != null && cartData['items'] != null) {
      final List<dynamic> items = cartData['items'];

      final index = items.indexWhere((item) => item['id'] == product.id);
      if (index != -1) {
        //items[index]['quantity']++;
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
    await _cartRef.doc(userId).set(_cartItems[userId]);
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
    await _cartRef.doc(userId).set(_cartItems[userId]);
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
    await _cartRef.doc(userId).set(_cartItems[userId]);
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
    await _cartRef.doc(userId).set(_cartItems[userId]);
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
    await _cartRef.doc(userId).set(_cartItems[userId]);
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
        return CartItem.fromMap(items[index]);
      }
    }
    return null;
  }
}
