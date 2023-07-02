import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/adminsection/add_product_screen.dart';
import 'package:food_delivery_app/screens/adminsection/admin_order_screen.dart';
import 'package:food_delivery_app/screens/adminsection/product_update_search.dart';
import 'package:food_delivery_app/screens/home_screen.dart';
import 'package:food_delivery_app/screens/login_screen.dart';
import 'package:food_delivery_app/utils/my_text_style.dart';
import 'package:get/get.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  Get.to(const AddProductScreen());
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Icon(Icons.add,size: 60,),
                        Text("Add Product",style: MyStyle.myTitleTextStyle(Colors.black),)
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.to(AdminOrdersScreen());
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Icon(Icons.list_alt_sharp,size: 60,),
                        Text("View Order",style: MyStyle.myTitleTextStyle(Colors.black),)
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  Get.to(const ProductUpdateSearch());
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Icon(Icons.sync,size: 60,),
                        Text("Update Product",style: MyStyle.myTitleTextStyle(Colors.black),)
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.offAll(const HomeScreen());
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Icon(Icons.change_circle,size: 60,),
                        Text("Buyer Mode",style: MyStyle.myTitleTextStyle(Colors.black),)
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
