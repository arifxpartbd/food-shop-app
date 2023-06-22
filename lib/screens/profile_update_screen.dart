
import 'package:flutter/material.dart';
import 'package:food_delivery_app/getxControllerFile/user_auth_controller.dart';
import 'package:food_delivery_app/screens/home_screen.dart';
import 'package:food_delivery_app/utils/my_colors.dart';
import 'package:food_delivery_app/widgets/app_button.dart';
import 'package:food_delivery_app/widgets/app_text_field.dart';
import 'package:get/get.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {

  final UserAuthController _userAuthController = Get.find<UserAuthController>();
  final TextEditingController nameET = TextEditingController();
  final TextEditingController mobileET = TextEditingController();
  final TextEditingController shippingaddressET = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.brandColor,
      appBar: AppBar(
        title: const Text("Profile Screen"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
      children: [
        Form(
          key: _globalKey,
          child: Column(
            children: [
              AppTextField(
                hintText: "Name",
                textInputType: TextInputType.text,
                prefixIcon: Icons.person,
                controller: nameET,
                validator: (value){
                  if(value!.isEmpty){
                    return "Please type your name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8,),
              AppTextField(
                textFieldEnable: false,
                hintText: "Email",
                textInputType: TextInputType.text,
                prefixIcon: Icons.email,
                controller: TextEditingController(),
                validator: (value){
                  return null;
                },
              ),
              const SizedBox(height: 8,),
              AppTextField(
                hintText: "Mobile No",
                textInputType: TextInputType.phone,
                prefixIcon: Icons.call,
                controller: mobileET,
                validator: (value){
                  if(value!.isEmpty){
                    return "Please type your mobile no";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8,),
              AppTextField(
                maxLine: 5,
                hintText: "Shipping Address",
                textInputType: TextInputType.text,
                prefixIcon: Icons.location_city,
                controller: TextEditingController(),
                validator: (value){
                  if(value!.isEmpty){
                    return "Please type your Address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8,),
              Obx((){
                return _userAuthController.isLoading.value ? const CircularProgressIndicator():
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                      buttonTextColor: Colors.black,
                      backgroundColor: Colors.white,
                      buttonText: "Update", onTap: (){
                        if(_globalKey.currentState!.validate()){
                          _userAuthController.updateProfileData(nameET.text, mobileET.text, shippingaddressET.text).then((value){
                            if(_userAuthController.currentUser.value != null){
                              Get.to(const HomeScreen());
                            }

                          });
                        }
                  }),
                );
              })

            ],
          ),
        ),
      ],
      ),
    );
  }
}
