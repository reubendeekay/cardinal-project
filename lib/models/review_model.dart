import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String? review;
  final String? id;
  final String? mechanicId;
  final String? fullName;
  final String? imageUrl;
  final String? userId;
  final double? rating;
  final Timestamp? createdAt;

  ReviewModel(
      {this.review,
      this.id,
      this.mechanicId,
      this.userId,
      this.fullName,
      this.imageUrl,
      this.rating = 0.0,
      this.createdAt});

  factory ReviewModel.fromJson(dynamic doc) {
    return ReviewModel(
      review: doc['review'],
      id: doc.id,
      mechanicId: doc['mechanicId'],
      rating: doc['rating'],
      createdAt: doc['createdAt'],
      userId: doc['userId'],
      fullName: doc['fullName'],
      imageUrl: doc['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review': review,
      'id': id,
      'mechanicId': mechanicId,
      'rating': rating,
      'createdAt': createdAt,
      'userId': userId,
      'fullName': fullName,
      'imageUrl': imageUrl,
    };
  }
}
