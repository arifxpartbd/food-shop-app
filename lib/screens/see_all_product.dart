import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/product_details_page.dart';
import 'package:food_delivery_app/utils/my_colors.dart';
import 'package:food_delivery_app/widgets/app_text_field.dart';
import 'package:get/get.dart';
import '../getxControllerFile/product_controller.dart';
import '../getxControllerFile/product_search_controller.dart';
import '../models/product_model.dart';

class SeeAllProductScreen extends StatefulWidget {
  const SeeAllProductScreen({Key? key}) : super(key: key);

  @override
  State<SeeAllProductScreen> createState() => _SeeAllProductScreenState();
}

class _SeeAllProductScreenState extends State<SeeAllProductScreen> {
  final ProductController _productController = Get.find<ProductController>();
  final ProductSearchController _productSearchController = Get.put(ProductSearchController());
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productSearchController.setProducts(_productController.products); // Set the initial list of products
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          TextFormField(
            onChanged: (query){
              _productSearchController.searchProduct(query);
            },
          controller: _searchController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search,color: MyColors.brandColor,),
            hintText: "Search hear......",
            filled: true,
            fillColor: Colors.white70,
            border: OutlineInputBorder(
              //borderSide: BorderSide.none
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          keyboardType: TextInputType.text,
        ),


            Expanded(
              child: Obx(
                    () {
                  final filteredProducts = _productSearchController.filteredProducts;
                  if (_searchController.text.isEmpty) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: _productController.products.length,
                      itemBuilder: (context, index) {
                        Product product = _productController.products[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(ProductDetailsScreen(product: product));
                            // Handle product tap event
                          },
                          child: Card(
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(product.imageUrls[0]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: double.infinity,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (filteredProducts.isEmpty) {
                    return const Center(child: Text("No products found"));
                  } else {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        Product product = filteredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(ProductDetailsScreen(product: product));
                            // Handle product tap event
                          },
                          child: Card(
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(product.imageUrls[0]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: double.infinity,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
