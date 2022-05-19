import 'package:cardinal/models/property_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutx/flutx.dart';

class PropertyDetailsController extends FxController {
  bool showLoading = true, uiLoading = true;
  late PropertyModel property;

  PropertyDetailsController(this.property);

  @override
  initState() {
    super.save = false;
    super.initState();
    addView(property.id!);
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
    showLoading = false;
    uiLoading = false;
    update();
  }

  Future<void> addWishList(String id, bool exitsts) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .doc(id)
        .update({
      'likes': exitsts ? FieldValue.increment(-1) : FieldValue.increment(1),
    });
    if (exitsts) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'wishlist': FieldValue.arrayRemove([id]),
      });
    } else {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'wishlist': FieldValue.arrayUnion([id]),
      });
    }

    update();
  }

  @override
  String getTag() {
    return "single_estate_controller";
  }
}
