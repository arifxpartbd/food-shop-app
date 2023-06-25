import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../getxControllerFile/cart_controller.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartListScreen extends StatelessWidget {
  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<Map<String, dynamic>>(
                stream: controller.cartStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final cartData = snapshot.data!;
                    final List<dynamic> cartItems = cartData['items'] ?? [];

                    return ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final Product product = Product.fromMap(item, item['id']);
                        final CartItem? cartItem = controller.getCartItem(product);

                        return Card(
                          child: ListTile(
                            title: Text(product.name),
                            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => controller.decreaseQuantity(product),
                                  icon: const Icon(Icons.remove),
                                ),
                                if (cartItem != null)
                                  Text('${cartItem.quantity}'),
                                IconButton(
                                  onPressed: () => controller.increaseQuantity(product),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            // leading: Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                            //     image: DecorationImage(
                            //       image: NetworkImage(product.imageUrls[index].toString()),
                            //       fit: BoxFit.cover,
                            //     ),
                            //   ),
                            //   width: 150,
                            //   height: 150,
                            // ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GetBuilder<CartController>(
                    builder: (cartController) {
                      return Text(
                        'Total: \$${cartController.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
