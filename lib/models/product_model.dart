
// class Product {
//     final String id;
//   final String name;
//   final double price;
//   final double discount;
//   final String description;
//   final List<String> imageUrls;
//   final List<Review>? reviews; // Optional list of reviews
//
//   Product({
//     required this.description,
//     required this.discount,
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.imageUrls,
//     this.reviews,
//   });
//
//   // Other methods and constructors
//
//   factory Product.fromMap(Map<String, dynamic> map, String id) {
//     final List<dynamic> reviewData = map['reviews'] ?? []; // Handle optional reviews
//
//     // Parse review data into a list of Review objects
//     final List<Review>? reviews = reviewData.isNotEmpty
//         ? reviewData
//         .map((review) => Review.fromMap(review as Map<String, dynamic>))
//         .toList()
//         : null;
//
//     return Product(
//       discount: map['discount']?.toDouble() ?? 0.0,
//       description: map['description'] ?? '',
//       id: id,
//       name: map['name'] ?? '',
//       price: (map['price'] ?? 0.0).toDouble(),
//       imageUrls: List<String>.from(map['imageUrls'] ?? []),
//       reviews: reviews,
//     );
//   }
// }
//
// class Review {
//   final String userId;
//   final String comment;
//   final double rating;
//
//   Review({
//     required this.userId,
//     required this.comment,
//     required this.rating,
//   });
//
//   factory Review.fromMap(Map<String, dynamic> map) {
//     return Review(
//       userId: map['userId'] ?? '',
//       comment: map['comment'] ?? '',
//       rating: (map['rating'] ?? 0.0).toDouble(),
//     );
//   }
// }

class Product {
  final String id;
  final String name;
  final double price;
  final double discount;
  final String description;
  final List<String> imageUrls;
  int quantity; // Added quantity property

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.description,
    required this.imageUrls,
    this.quantity = 1, // Default quantity is 1
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      discount: map['discount']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
    );
  }
}





// class Product {
//   final String id;
//   final String name;
//   final double price;
//   final double discount;
//   final String description;
//   final List<String> imageUrls;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.discount,
//     required this.description,
//     required this.imageUrls,
//   });
//
//   factory Product.fromMap(Map<String, dynamic> map, String id) {
//     return Product(
//       id: id,
//       name: map['name'] ?? '',
//       price: map['price']?.toDouble() ?? 0.0,
//       discount: map['discount']?.toDouble() ?? 0.0,
//       description: map['description'] ?? '',
//       imageUrls: List<String>.from(map['imageUrls'] ?? []),
//     );
//   }
// }







// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Product {
//   late String id;
//   late String name;
//   late double price;
//   late double discount;
//   late String description;
//   late List<String> imageUrls;
//   late List<Review> reviews;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.discount,
//     required this.description,
//     required this.imageUrls,
//     required this.reviews,
//   });
//
//   // Convert a Product object to a Firestore document
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'price': price,
//       'discount': discount,
//       'description': description,
//       'imageUrls': imageUrls,
//       'reviews': reviews.map((review) => review.toMap()).toList(),
//     };
//   }
//
//   // Create a Product object from a Firestore document
//   factory Product.fromMap(Map<String, dynamic>? map, String id) {
//     if (map == null) {
//       throw ArgumentError("Invalid product map data");
//     }
//
//     return Product(
//       id: id,
//       name: map['name'] as String,
//       price: (map['price'] as num).toDouble(),
//       discount: (map['discount'] as num).toDouble(),
//       description: map['description'] as String,
//       imageUrls: List<String>.from(map['imageUrls'] as List<dynamic>),
//       reviews: (map['reviews'] as List<dynamic>).map((review) => Review.fromMap(review as Map<String, dynamic>)).toList(),
//     );
//   }
// }
//
//
//
// class Review {
//   late String userId;
//   late String comment;
//   late int rating;
//
//   Review({
//     required this.userId,
//     required this.comment,
//     required this.rating,
//   });
//
//   // Convert a Review object to a map
//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'comment': comment,
//       'rating': rating,
//     };
//   }
//
//   // Create a Review object from a map
//   factory Review.fromMap(Map<String, dynamic> map) {
//     return Review(
//       userId: map['userId'],
//       comment: map['comment'],
//       rating: map['rating'],
//     );
//   }
// }
