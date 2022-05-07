import 'package:cardinal/models/property_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../models/category.dart';

class PropertyController extends FxController {
  bool showLoading = true, uiLoading = true;

  List<Category>? categories;
  List<PropertyModel> properties = [];

  // List<House>? houses;
  List selectedBedRooms = [];
  List selectedBathRooms = [];
  var selectedRange = const RangeValues(200, 800);

  @override
  initState() {
    super.save = false;
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    categories = Category.categoryList();
    // houses = House.houseList();
    final propertyData = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        // .where('status', isNotEqualTo: 'sold')
        .get();
    List<PropertyModel> propData = [];

    for (var e in propertyData.docs) {
      propData.add(PropertyModel.fromJson(e));
    }

    properties = propData;

    showLoading = false;
    uiLoading = false;
    update();
  }

  @override
  String getTag() {
    return "home_controller";
  }
}
