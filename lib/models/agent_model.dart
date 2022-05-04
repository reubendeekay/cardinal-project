import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class AgentModel {
  String? agentName,
      userId,
      profilePic,
      address,
      phoneNumber,
      email,
      description,
      registrationNumber,
      website;
  GeoPoint? location;
  int? numProperties;
  File? profilePicFile;

  AgentModel(
      {this.agentName,
      this.profilePic,
      this.userId,
      this.email,
      this.address,
      this.phoneNumber,
      this.registrationNumber,
      this.website,
      this.location,
      this.numProperties,
      this.profilePicFile,
      this.description});

  Map<String, dynamic> toJson() {
    return {
      'agentName': agentName,
      'profilePic': profilePic,
      'userId': userId,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'registrationNumber': registrationNumber,
      'website': website,
      'location': location,
      'properties': numProperties,
      'description': description,
    };
  }

  factory AgentModel.fromJson(dynamic json) {
    return AgentModel(
      agentName: json['agentName'],
      userId: json['userId'],
      profilePic: json['profilePic'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      description: json['description'],
      numProperties: json['properties'],
      registrationNumber: json['registrationNumber'],
      website: json['website'],
      location: json['location'],
    );
  }
}
