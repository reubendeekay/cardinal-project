import 'dart:io';

import 'package:cardinal/models/agent_model.dart';
import 'package:cardinal/models/ammenities_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyModel {
  final String? id;
  final String? ownerId;
  final String? type;
  final String? name;
  final String? description;
  final String? address;
  final String? status;
  final String? price;
  String? coverImage;
  final File? coverFile;
  List<dynamic>? images = [];
  List<File>? imageFiles = [];
  GeoPoint? location;
  final int likes;
  final int views;
  final AmmenitiesModel? ammenities;

  PropertyModel({
    this.id,
    this.ownerId,
    this.name,
    this.description,
    this.ammenities,
    this.address,
    this.price,
    this.coverImage,
    this.status,
    this.location,
    this.images,
    this.type,
    this.likes = 0,
    this.views = 0,
    this.coverFile,
    this.imageFiles,
  });

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'address': address,
      'location': location,
      'cover_image': coverImage,
      'ammenities': ammenities!.toJson(),
      'price': price,
      'likes': likes,
      'views': views,
      'images': images,
      'type': type,
      'status': status,
    };
  }

  factory PropertyModel.fromJson(dynamic json) {
    return PropertyModel(
      id: json.id,
      ownerId: json['ownerId'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      price: json['price'],
      ammenities: AmmenitiesModel.fromJson(json['ammenities']),
      coverImage: json['cover_image'],
      location: json['location'],
      images: json['images'],
      likes: json['likes'],
      type: json['type'],
      views: json['views'],
      status: json['status'],
    );
  }
}
