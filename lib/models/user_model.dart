import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userId;
  final String? fullName;
  final String? email;
  final String? profilePic;
  final String? phoneNumber;
  final bool? isAgent;
  final String? password;
  final Timestamp? createdAt;
  final bool? isOnline;
  final Timestamp? lastSeen;
  List<dynamic>? wishList = [];

  UserModel({
    this.userId,
    this.fullName,
    this.email,
    this.isAgent,
    this.profilePic,
    this.phoneNumber,
    this.password,
    this.createdAt,
    this.isOnline,
    this.lastSeen,
    this.wishList,
  });

  factory UserModel.fromJson(dynamic json) => UserModel(
        userId: json.id,
        fullName: json['name'],
        email: json['email'],
        isAgent: json['isAgent'],
        profilePic: json['profilePic'],
        phoneNumber: json['phone'],
        password: json['password'],
        createdAt: json['createdAt'],
        isOnline: json['isOnline'],
        lastSeen: json['lastSeen'],
        wishList: json['wishlist'],
      );
}
