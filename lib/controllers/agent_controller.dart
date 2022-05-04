import 'package:cardinal/models/property_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutx/flutx.dart';

import '../models/agent_model.dart';

class AgentController extends FxController {
  bool showLoading = true, uiLoading = true;

  List<PropertyModel>? properties = [];
  late AgentModel agent;

  AgentController(this.agent);

  @override
  initState() {
    super.save = false;
    super.initState();
    fetchAgentListings();
  }

  void fetchAgentListings() async {
    final results = await FirebaseFirestore.instance
        .collection('propertyData/propertyListing/properties')
        .where('ownerId', isEqualTo: agent.userId)
        .get();

    List<PropertyModel> _properties = [];

    for (var element in results.docs) {
      _properties.add(PropertyModel.fromJson(element));
    }
    properties = _properties;

    showLoading = false;
    uiLoading = false;
    update();
  }

  @override
  String getTag() {
    return "single_agent_controller";
  }
}
