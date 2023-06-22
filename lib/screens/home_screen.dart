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



  Future<void> checkUserData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .then((snapshot) {
        final profileData = snapshot.data();
        if (profileData == null ||
            profileData['name'] == null ||
            profileData['email'] == null) {
          Get.to(const ProfileUpdateScreen());
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
        child: ListView(
          children: [

          ],
        ),
      ),
    );
  }
}
