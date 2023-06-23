import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/getxControllerFile/user_auth_controller.dart';
import 'package:food_delivery_app/screens/add_product_screen.dart';
import 'package:food_delivery_app/screens/login_screen.dart';
import 'package:food_delivery_app/screens/profile_update_screen.dart';
import 'package:get/get.dart';

import '../utils/my_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String userName = "";
  String userEmail = "";
  String imageUrl = '';

  final UserAuthController _userAuthController = Get.find<UserAuthController>();

  Future<void> checkUserData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .then((snapshot) {
        final profileData = snapshot.data();
        userName = profileData?['name'] ?? "User Name";
        userEmail = profileData?['email']?? "user email";
        imageUrl = profileData?['profileImage']?? "";
        setState(() {

        });
        if (profileData == null ||
            profileData['name'] == null ||
            profileData['email'] == null) {
          Get.to(const ProfileScreen());
        }
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_border)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.card_giftcard)),

        ],
      ),
      drawer: Drawer(
        //backgroundColor: MyColors.brandColor,
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: MyColors.brandColor),
                  otherAccountsPictures: const [
                    CircleAvatar(
                        backgroundImage: AssetImage('images/arif.jpeg'),
                    )
                  ],
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  accountName: Text(userName,style: const TextStyle(color: Colors.white),),
                  accountEmail: Text(userEmail),
                )),

            const ListTile(
              title: Text("Refund account"),
              subtitle: Text("Blance and payment methods"),
              trailing: Text("0"),
            ),
            const Divider(
              thickness: 1,
              color: Colors.black12,
            ),

            const ListTile(
              title: Text('Become a pandapro'),
              leading: Icon(Icons.star,color: MyColors.brandColor,),
            ),const ListTile(
              title: Text('Voucher & Offers'),
              leading: Icon(Icons.gif,color: MyColors.brandColor,),
            ),

            const ListTile(
              title: Text('Favourites'),
              leading: Icon(Icons.favorite_border,color: MyColors.brandColor,),
            ),

            const ListTile(
              title: Text('Orders & reordering'),
              leading: Icon(Icons.list_alt,color: MyColors.brandColor,),
            ),

             ListTile(
              onTap: (){
                Get.to(const ProfileScreen());
              },
              title: const Text('Profile'),
              leading: const Icon(Icons.person,color: MyColors.brandColor,),
            ),

            const ListTile(
              title: Text('Address'),
              leading: Icon(Icons.location_on,color: MyColors.brandColor,),
            ),

            const ListTile(
              title: Text('Help Center'),
              leading: Icon(Icons.error,color: MyColors.brandColor,),
            ),

            const ListTile(
              title: Text('Invite friends'),
              leading: Icon(Icons.card_giftcard,color: MyColors.brandColor,),
            ),
            const Divider(
              thickness: 2,
              color: Colors.black12,
            ),
            ListTile(
              onTap: (){

              },
              title: const Text('Settings'),
            ),ListTile(
              onTap: (){

              },
              title: const Text('Terms & Conditions / privacy'),
            ),

            ListTile(
              onTap: (){
                _userAuthController.signOut().then((value){
                  Get.offAll(const LoginScreen());
                });
              },
              title: const Text('Log out'),
            ),ListTile(
              onTap: (){
                Get.to(const AddProductScreen());
              },
              title: const Text('Add Product'),
            ),
            
          ],
        ),
      ),
    );
  }
}
