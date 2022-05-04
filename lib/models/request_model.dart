import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String? propertyId;
  final String? userId;
  final String? ownerId;
  final String? amount;
  final Timestamp? createdAt;
  final String? status;
  final String? paymentMethod;
  final String? id;

  RequestModel({
    this.propertyId,
    this.userId,
    this.ownerId,
    this.amount,
    this.createdAt,
    this.status,
    this.paymentMethod,
    this.id,
  });

  Map<String, dynamic> toJson() => {
        'propertyId': propertyId,
        'userId': userId,
        'amount': amount,
        'createdAt': createdAt,
        'status': status,
        'paymentMethod': paymentMethod,
        'ownerId': ownerId,
      };

  factory RequestModel.fromJson(dynamic json) => RequestModel(
        propertyId: json['propertyId'],
        userId: json['userId'],
        amount: json['amount'],
        createdAt: json['createdAt'],
        status: json['status'],
        paymentMethod: json['paymentMethod'],
        id: json.id,
        ownerId: json['ownerId'],
      );
}

class PurchaseModel {
  final RequestModel request;
  final PropertyModel property;
  final UserModel user;

  PurchaseModel(this.request, this.property, this.user);
}
