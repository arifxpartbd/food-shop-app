import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/getxControllerFile/cart_controller.dart';
import 'package:food_delivery_app/getxControllerFile/order_controller.dart';
import 'package:food_delivery_app/getxControllerFile/product_controller.dart';
import 'package:food_delivery_app/getxControllerFile/product_search_controller.dart';
import 'package:food_delivery_app/getxControllerFile/user_auth_controller.dart';
import 'package:food_delivery_app/screens/home_screen.dart';
import 'package:food_delivery_app/screens/login_screen.dart';
import 'package:food_delivery_app/utils/my_colors.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: MyColors.brandColor, // Set your desired color here
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      title: 'Flutter Demo',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: MyColors.brandColor
        )
      ),
      home: FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading screen if the authentication state is still loading
            return const CircularProgressIndicator();
          } else {
            // Check if the user is logged in
            if (snapshot.hasData) {
              // User is already logged in, navigate to the home screen
              return  const HomeScreen();
            } else {
              // User is not logged in, navigate to the login screen
              return const LoginScreen();
            }
          }
        },
      ),
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<UserAuthController>(UserAuthController());
    Get.put<ProductController>(ProductController());
    Get.put<CartController>(CartController());
    Get.put<OrderController>(OrderController());
    Get.put<ProductSearchController>(ProductSearchController());
  }
}
