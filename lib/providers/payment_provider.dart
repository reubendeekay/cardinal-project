import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/models/request_model.dart';
import 'package:cardinal/models/user_model.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

final userPurchaseRef = FirebaseFirestore.instance
    .collection('userData')
    .doc('purchases')
    .collection(uid);

class PaymentProvider with ChangeNotifier {
  bool uiLoading = false;

  Future<void> purchaseProperty(RequestModel request) async {
    final id = FirebaseFirestore.instance.collection('requests').doc().id;

    await userPurchaseRef.doc(id).set(
          request.toJson(),
        );

    await FirebaseFirestore.instance
        .collection('purchases')
        .doc('agents')
        .collection(request.ownerId!)
        .doc(id)
        .set(
          request.toJson(),
        );
    await FirebaseFirestore.instance
        .collection('propertyData/propertyListing/properties')
        .doc(request.propertyId)
        .update({
      'status': 'sold',
    });
    notifyListeners();
  }

  Future<List<PurchaseModel>> getAllPurchases(String agentId) async {
    uiLoading = true;

    final results = await FirebaseFirestore.instance
        .collection('purchases')
        .doc('agents')
        .collection(agentId)
        .get();

    final List<RequestModel> requests =
        results.docs.map((e) => RequestModel.fromJson(e)).toList();
    List<UserModel> users = [];
    List<PropertyModel> properties = [];

    for (RequestModel e in requests) {
      final userResult = await FirebaseFirestore.instance
          .collection('users')
          .doc(e.userId)
          .get();
      users.add(
        UserModel.fromJson(userResult),
      );
      final propertyResult = await FirebaseFirestore.instance
          .collection('propertyData')
          .doc('propertyListing')
          .collection('properties')
          .doc(e.propertyId)
          .get();
      properties.add(
        PropertyModel.fromJson(propertyResult),
      );
    }

    uiLoading = false;
    notifyListeners();
    return List.generate(requests.length,
        (i) => PurchaseModel(requests[i], properties[i], users[i]));
  }
}
