import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PropertyProvider with ChangeNotifier {
  List<PropertyModel> _properties = [];
  final List<PropertyModel> _yourHistory = [];
  final List<PropertyModel> _yourWishlist = [];
  List<PropertyModel> get properties => [..._properties];
  List<PropertyModel> get yourHistory => [..._yourHistory];
  List<PropertyModel> get yourWishlist => [..._yourWishlist];

  Future<void> fetchProperties() async {
    final propertyData = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .get();
    List<PropertyModel> propData = [];

    for (var e in propertyData.docs) {
      propData.add(PropertyModel.fromJson(e));
    }

    _properties = propData;

    notifyListeners();
  }

  Future<void> fetchAgentProperties() async {
    final propertyData = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .where('ownerId', isEqualTo: uid)
        .get();
    List<PropertyModel> propData = [];

    for (var e in propertyData.docs) {
      propData.add(PropertyModel.fromJson(e));
    }

    _properties = propData;

    notifyListeners();
  }

//On editing
  Future<void> addRecentSearch(String searchTerm) async {
    if (searchTerm.isNotEmpty) {
      final searchData = await FirebaseFirestore.instance
          .collection('userData')
          .doc('recentSearch')
          .collection(uid)
          .get();
      if (searchData.docs.map((e) => e['term']).toList().contains(searchTerm)) {
        await FirebaseFirestore.instance
            .collection('userData')
            .doc('recentSearch')
            .collection(uid)
            .doc(searchData.docs
                .firstWhere((element) => element['term'] == searchTerm)
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

  Future<void> addView(
    String id,
  ) async {
    await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .doc(id)
        .update({
      'views': FieldValue.increment(1),
    });

    notifyListeners();
  }

  Future<void> postProperty(PropertyModel property) async {
    final ref = FirebaseFirestore.instance
        .collection('propertyData/propertyListing/properties');
    final id = ref.doc().id;

    final coverUpload = await FirebaseStorage.instance
        .ref('propertyImages/$id')
        .putFile(property.coverFile!);

    final coverImage = await coverUpload.ref.getDownloadURL();

    List<String> imageUrls = [];

    if (property.imageFiles!.isNotEmpty) {
      await Future.wait(
        property.imageFiles!.map((imageFile) async {
          final upload =
              FirebaseStorage.instance.ref('propertyImages/$id/images/');
          final url = await upload.putFile(imageFile);
          imageUrls.add(await url.ref.getDownloadURL());
        }),
      );

      property.coverImage = coverImage;
      property.images = imageUrls;

      await ref.doc(id).set(property.toJson());

      await FirebaseFirestore.instance.collection('agents').doc(uid).set({
        'properties': FieldValue.increment(1),
      });
      notifyListeners();
    }
  }

  Future<void> editProperty(PropertyModel property) async {
    final ref = FirebaseFirestore.instance
        .collection('propertyData/propertyListing/properties');
    final id = property.id;

    if (property.coverFile != null) {
      final coverUpload = await FirebaseStorage.instance
          .ref('propertyImages/$id')
          .putFile(property.coverFile!);

      final coverImage = await coverUpload.ref.getDownloadURL();

      property.coverImage = coverImage;
    }

    List<String> imageUrls = [];

    if (property.imageFiles!.isNotEmpty) {
      await Future.wait(
        property.imageFiles!.map((imageFile) async {
          final upload =
              FirebaseStorage.instance.ref('propertyImages/$id/images/');
          final url = await upload.putFile(imageFile);
          imageUrls.add(await url.ref.getDownloadURL());
        }),
      );

      property.images = imageUrls;
    }

    await ref.doc(id).update(property.toJson());
    notifyListeners();
  }

  Future<void> deleteProperty(String id) async {
    await FirebaseFirestore.instance
        .collection('propertyData/propertyListing/properties')
        .doc(id)
        .delete();
    await FirebaseFirestore.instance.collection('agents').doc(uid).update({
      'properties': FieldValue.increment(-1),
    });
    notifyListeners();
  }

  Future<List<PropertyModel>> fetchYourWishlist() async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final List wishlist = userData['wishlist'];
    List<PropertyModel> myWish = [];
    for (var e in wishlist) {
      final propertyData = await FirebaseFirestore.instance
          .collection('propertyData')
          .doc('propertyListing')
          .collection('properties')
          .doc(e)
          .get();
      myWish.add(PropertyModel.fromJson(propertyData));
    }

    notifyListeners();
    return myWish;
  }
}
