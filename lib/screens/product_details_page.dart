import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/my_colors.dart';
import 'package:food_delivery_app/utils/my_text_style.dart';
import 'package:food_delivery_app/widgets/app_button.dart';
import '../models/product_model.dart';


class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text("Product Details"),
    ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CarouselSlider(
                    items: widget.product.imageUrls.map((image) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                          image: DecorationImage(
                            image: NetworkImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: double.infinity,
                        height: 250,
                      );

                    }).toList(),
                    options: CarouselOptions(
                      height: 250,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                    ),
                  ),
                  // CarouselSlider(
                  //   options: CarouselOptions(
                  //     height: 300.0,
                  //     aspectRatio: 16 / 9,
                  //     viewportFraction: 0.9,
                  //     initialPage: 0,
                  //     enableInfiniteScroll: true,
                  //     reverse: false,
                  //     autoPlay: true,
                  //     autoPlayInterval: const Duration(seconds: 3),
                  //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  //     autoPlayCurve: Curves.fastOutSlowIn,
                  //     enlargeCenterPage: true,
                  //     onPageChanged: (index, reason) {},
                  //     scrollDirection: Axis.horizontal,
                  //   ),
                  //   items: widget.product.imageUrls.map((imageUrl) {
                  //     return Builder(
                  //       builder: (BuildContext context) {
                  //         return Container(
                  //           width: MediaQuery.of(context).size.width,
                  //           margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  //           child: Image.network(
                  //             imageUrl,
                  //             fit: BoxFit.contain,
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   }).toList(),
                  // ),
                  // Positioned(
                  //     top: 40,
                  //     left: 15,
                  //     child: CircleAvatar(
                  //       backgroundColor: Colors.white70,
                  //         child: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios,color: Colors.black,),)))
                ],
              ),

              Text(widget.product.name,style: MyStyle.myTitleTextStyle(Colors.black),),
              const SizedBox(height: 8,),
              Text(widget.product.price.toStringAsFixed(2)),
              const SizedBox(height: 8.0,),
              Text(widget.product.description),
              const SizedBox(height: 8.0,),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                    backgroundColor: MyColors.brandColor,
                    buttonText: "Add to cart", onTap: (){

                }),
              )


            ],
          ),
        ),
      ),
    );
  }
}
