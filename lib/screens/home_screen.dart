import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/profile_update_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String userName = "";
  String userEmail = "";


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
      ),
      drawer: Drawer(
        //backgroundColor: MyColors.brandColor,
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  accountName: Text(userName,style: const TextStyle(color: Colors.white),),
                  accountEmail: Text(userEmail),

                )),

            ListTile(
              title: const Text("Profile"),
              onTap: (){
                Get.to(const ProfileScreen());
              },
            )
          ],
        ),
      ),
    );
  }
}
