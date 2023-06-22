import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/my_colors.dart';
import 'package:get/get.dart';

import '../utils/my_text_style.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.brandColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_food_beverage_outlined,
                    size: 120,
                    color: Colors.white,
                  ),
                  Text(
                    "Enter your register email address, we'll sent reset link to your email address",
                    style: MyStyle.mySubTitleTextStyle(Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AppTextField(
                    validator: (value) {
                      return null;
                    },
                    controller: TextEditingController(),
                    hintText: 'Email Address',
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AppButton(
                      buttonTextColor: Colors.black,
                      backgroundColor: Colors.white,
                      buttonText: 'Reset Password',
                      onTap: () {},
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Already Have an account? Login Now",
                      style: MyStyle.mySubTitleTextStyle(Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
