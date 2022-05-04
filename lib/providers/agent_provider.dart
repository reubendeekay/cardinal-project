import 'package:cardinal/models/agent_model.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class AgentProvider with ChangeNotifier {
  List<PropertyModel> agentProperties = [];

  Future<void> registerAsAgent(AgentModel agent) async {
    final upload = await FirebaseStorage.instance
        .ref('agents/profile/${agent.userId}')
        .putFile(agent.profilePicFile!);

    final profilePicUrl = await upload.ref.getDownloadURL();
    agent.profilePic = profilePicUrl;

    await FirebaseFirestore.instance
        .collection('agents')
        .doc(agent.userId)
        .set({
      'createdAt': Timestamp.now(),
      ...agent.toJson(),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(agent.userId)
        .update({
      'isAgent': true,
    });
    notifyListeners();
  }

  Future<void> updateAgent(AgentModel agent) async {
    if (agent.profilePicFile != null) {
      final upload = await FirebaseStorage.instance
          .ref('agents/profile/${agent.userId}')
          .putFile(agent.profilePicFile!);

      final profilePicUrl = await upload.ref.getDownloadURL();
      agent.profilePic = profilePicUrl;
    }

    await FirebaseFirestore.instance
        .collection('agents')
        .doc(agent.userId)
        .update({
      ...agent.toJson(),
    });

    notifyListeners();
  }

  Future<AgentModel> getAgent(String userId) async {
    final results =
        await FirebaseFirestore.instance.collection('agents').doc(userId).get();

    notifyListeners();
    return AgentModel.fromJson(results);
  }

  Future<List<PropertyModel>> getAgentProperties(String userId) async {
    final results = await FirebaseFirestore.instance
        .collection('propertyData/propertyListing/properties')
        .where('ownerId', isEqualTo: userId)
        .get();

    List<PropertyModel> propData = [];

    for (var e in results.docs) {
      propData.add(PropertyModel.fromJson(e));
    }

    agentProperties = propData;

    notifyListeners();
    return propData;
  }
}
