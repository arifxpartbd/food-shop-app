import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<String> selectedImageUrls = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  bool _showLoading = false;
  double _loadingProgress = 0.0;

  Future<void> selectImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages != null) {
      List<String> imageUrls = [];
      for (final pickedImage in pickedImages) {
        final image = File(pickedImage.path);
        String imageUrl = await uploadImage(image);
        imageUrls.add(imageUrl);
      }
      setState(() {
        selectedImageUrls = imageUrls;
      });
    }
  }

  Future<String> uploadImage(File image) async {
    String filename = Uuid().v4();
    Reference storageRef =
    FirebaseStorage.instance.ref().child('product_images/$filename.jpg');

    UploadTask uploadTask = storageRef.putFile(image);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      setState(() {
        _loadingProgress = snapshot.bytesTransferred / snapshot.totalBytes * 100;
      });
    });

    await uploadTask;
    String imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  void removeImage(int index) {
    setState(() {
      selectedImageUrls.removeAt(index);
    });
  }

  Future<void> addProductToFirestore(
      String name,
      double price,
      double discount,
      String description,
      List<String> imageUrls,
      ) async {
    setState(() {
      _showLoading = true;
      _loadingProgress = 0.0;
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productsRef = firestore.collection('products');

    DocumentReference newProductRef = productsRef.doc();
    Map<String, dynamic> productData = {
      'name': name,
      'price': price,
      'discount': discount,
      'description': description,
      'imageUrls': imageUrls,
    };

    newProductRef
        .set(productData)
        .then((value) {
      setState(() {
        _showLoading = false;
        _loadingProgress = 0.0;
      });
      print('Product added to Firestore with ID: ${newProductRef.id}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully')),
      );
    })
        .catchError((error) {
      setState(() {
        _showLoading = false;
        _loadingProgress = 0.0;
      });
      print('Failed to add product to Firestore: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: selectImages,
                  child: Text('Select Images'),
                ),
                SizedBox(height: 16.0),
                selectedImageUrls.isNotEmpty
                    ? Container(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImageUrls.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            width: 200.0,
                            margin: EdgeInsets.only(right: 16.0),
                            child: Image.network(
                              selectedImageUrls[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => removeImage(index),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
                    : Placeholder(fallbackHeight: 200.0),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Discount'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text;
                    final price = double.tryParse(priceController.text) ?? 0.0;
                    final description = descriptionController.text;
                    final discount = double.tryParse(discountController.text) ?? 0.0;

                    addProductToFirestore(
                      name,
                      price,
                      discount,
                      description,
                      selectedImageUrls,
                    );

                    nameController.clear();
                    priceController.clear();
                    descriptionController.clear();
                    discountController.clear();
                    setState(() {
                      selectedImageUrls = [];
                    });
                  },
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
          if (_showLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16.0),
                    Text(
                      'Uploading...',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '${_loadingProgress.toStringAsFixed(1)}%',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}