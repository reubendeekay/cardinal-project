import 'package:cardinal/models/ammenities_model.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier {
  bool showLoading = true, uiLoading = true;

  Future<List<PropertyModel>> searchData(String term,
      {bool isCategory = false}) async {
    if (isCategory) {
      showLoading = true;
      uiLoading = true;
      final propertyData = await FirebaseFirestore.instance
          .collection('propertyData')
          .doc('propertyListing')
          .collection('properties')
          .where('type', isEqualTo: term)
          .get();
      List<PropertyModel> propData = [];

      for (var e in propertyData.docs) {
        propData.add(PropertyModel.fromJson(e));
      }
      uiLoading = false;
      showLoading = false;
      notifyListeners();
      return propData;
    }
    final results = await FirebaseFirestore.instance
        .collection('propertyData/propertyListing/properties')
        .get();

    List<PropertyModel> properties = [];
    results.docs
        .where((e) =>
            e['name'].toLowerCase().contains(term.toLowerCase()) ||
            e['description'].toLowerCase().contains(term.toLowerCase()) ||
            e['address'].toLowerCase().contains(term.toLowerCase()) ||
            e['type'].toLowerCase().contains(term.toLowerCase()) ||
            e['price'].toLowerCase().contains(term.toLowerCase()))
        .forEach((element) {
      properties.add(PropertyModel.fromJson(element));
    });

    uiLoading = false;
    showLoading = false;

    notifyListeners();
    return properties;
  }

  Future<void> addRecentSearch(String searchTerm) async {
    if (searchTerm.isNotEmpty) {
      final searchData = await FirebaseFirestore.instance
          .collection('userData')
          .doc('recentSearch')
          .collection(uid)
          .get();
      if (searchData.docs.contains(searchTerm)) {
        await FirebaseFirestore.instance
            .collection('userData')
            .doc('recentSearch')
            .collection(uid)
            .doc(searchData.docs
                .firstWhere((element) => element.data()['term'] == searchTerm)
                .id)
            .update({
          'createdAt': Timestamp.now(),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('userData')
            .doc('recentSearch')
            .collection(uid)
            .doc()
            .set({
          'term': searchTerm,
          'createdAt': Timestamp.now(),
        });
      }
    }
    notifyListeners();
  }

  Future<List<PropertyModel>> detailedSearchProperty({
    List<dynamic>? type,
    List<dynamic>? beds,
    List<dynamic>? baths,
    String? minprice = '25000',
    String? maxPrice = '1000000',
    String term = '',
  }) async {
    showLoading = true;
    uiLoading = true;
    final propertyData = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .get();

    List<PropertyModel> propData = [];
    if (term.isNotEmpty) {
      propertyData.docs
          .where((e) =>
              e['name'].toLowerCase().contains(term.toLowerCase()) ||
              e['description'].toLowerCase().contains(term.toLowerCase()) ||
              e['address'].toLowerCase().contains(term.toLowerCase()) ||
              double.parse(e['price']) >= double.parse(minprice!) &&
                  double.parse(e['price']) <= double.parse(maxPrice!))
          .forEach((element) {
        propData.add(PropertyModel.fromJson(element));
      });
    } else {
      propertyData.docs
          .where((e) =>
              double.parse(e['price']) >= double.parse(minprice!) &&
              double.parse(e['price']) <= double.parse(maxPrice!))
          .forEach((element) {
        propData.add(PropertyModel.fromJson(element));
      });
    }

    if (type != null) {
      for (var element in propertyData.docs) {
        if (type.contains(element['type'].toLowerCase())) {
          if (!propData.contains(PropertyModel.fromJson(element))) {
            propData.add(PropertyModel.fromJson(element));
          }
        }
      }
    }
    for (var element in propertyData.docs) {
      final ammenity = AmmenitiesModel.fromJson(element['ammenities']);

      if (baths!.contains(ammenity.bathrooms)) {
        if (!propData.contains(PropertyModel.fromJson(element))) {
          propData.add(PropertyModel.fromJson(element));
        }
      }
      if (beds!.contains(ammenity.beds)) {
        if (!propData.contains(PropertyModel.fromJson(element))) {
          propData.add(PropertyModel.fromJson(element));
        }
      }
    }

    if (term.isNotEmpty) {
      addRecentSearch(term);
    }
    showLoading = false;

    notifyListeners();
    return propData;
  }
}
