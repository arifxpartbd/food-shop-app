import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  late String id;
  late String name;
  late double price;
  late double discount;
  late String description;
  late List<String> imageUrls;
  late List<Review> reviews;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.description,
    required this.imageUrls,
    required this.reviews,
  });

  // Convert a Product object to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'discount': discount,
      'description': description,
      'imageUrls': imageUrls,
      'reviews': reviews.map((review) => review.toMap()).toList(),
    };
  }

  // Create a Product object from a Firestore document
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'],
      price: map['price'],
      discount: map['discount'],
      description: map['description'],
      imageUrls: List<String>.from(map['imageUrls']),
      reviews: List<Review>.from(
        map['reviews']?.map((review) => Review.fromMap(review)) ?? [],
      ),
    );
  }
}

class Review {
  late String userId;
  late String comment;
  late int rating;

  Review({
    required this.userId,
    required this.comment,
    required this.rating,
  });

  // Convert a Review object to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'comment': comment,
      'rating': rating,
    };
  }

  // Create a Review object from a map
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userId: map['userId'],
      comment: map['comment'],
      rating: map['rating'],
    );
  }
}
