import 'package:flutter/material.dart';
import 'package:food_delivery_app/getxControllerFile/user_auth_controller.dart';
import 'package:food_delivery_app/screens/forget_password_screen.dart';
import 'package:food_delivery_app/screens/sign_up_screen.dart';
import 'package:food_delivery_app/utils/my_colors.dart';
import 'package:food_delivery_app/utils/my_text_style.dart';

import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isCheck = true;
  final UserAuthController _userAuthController = Get.find<UserAuthController>();

  final TextEditingController emailET = TextEditingController();
  final TextEditingController passwordET = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.brandColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _globalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_food_beverage_outlined,
                      size: 120,
                      color: Colors.white,
                    ),
                    Text(
                      "Welcome Back",
                      style: MyStyle.myTitleTextStyle(Colors.white),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please type your email address";
                        }
                        return null;
                      },
                      controller: emailET,
                      hintText: 'Email Address',
                      textInputType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please type your email address";
                        }

                        return null;
                      },
                      controller: passwordET,
                      hintText: 'Password',
                      textInputType: TextInputType.visiblePassword,
                      prefixIcon: Icons.password,
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Remember Me",
                        style: MyStyle.mySubTitleTextStyle(Colors.white),
                      ),
                      value: _isCheck,
                      activeColor: Colors.white,
                      checkColor: MyColors.brandColor,
                      onChanged: (bool? value) {
                        setState(() {
                          _isCheck = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    Obx(() => _userAuthController.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: AppButton(
                              buttonTextColor: Colors.black,
                              backgroundColor: Colors.white,
                              buttonText: 'Login',
                              onTap: () {
                                if (_globalKey.currentState!.validate()) {
                                  _userAuthController
                                      .login(emailET.text, passwordET.text)
                                      .then((isValidUser) {
                                    if (_userAuthController.currentUser.value !=
                                        null) {
                                      Get.offAll( const HomeScreen());
                                    } else {
                                      // Display an error message
                                      Get.snackbar(
                                        "Login Error",
                                        "Invalid email or password",
                                        duration: const Duration(seconds: 3),
                                      );
                                    }
                                  }).catchError((error) {
                                    // Display an error message
                                    Get.snackbar(
                                      "Login Error",
                                      error.toString(),
                                      duration: const Duration(seconds: 3),
                                    );
                                  });
                                }
                              },
                            ),
                          )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(const SignUpScreen());
                          },
                          child: const Text(
                            "Create New Account",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(const ForgetPasswordScreen());
                          },
                          child: const Text(
                            "Forget Password",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
