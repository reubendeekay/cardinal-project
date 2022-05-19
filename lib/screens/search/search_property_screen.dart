import 'package:cardinal/controllers/property_controller.dart';
import 'package:cardinal/helpers/my_shimmer.dart';
import 'package:cardinal/models/agent_model.dart';
import 'package:cardinal/models/category.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/screens/home_screen.dart';
import 'package:cardinal/screens/search/agent_avatar.dart';
import 'package:cardinal/screens/search_results_screen.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';

class SearchPropertyScreen extends StatefulWidget {
  const SearchPropertyScreen({Key? key}) : super(key: key);

  @override
  State<SearchPropertyScreen> createState() => _SearchPropertyScreenState();
}

class _SearchPropertyScreenState extends State<SearchPropertyScreen> {
  String? searchText;
  late CustomTheme customTheme;
  late ThemeData theme;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Expanded(
                  child: FxTextField(
                    onChanged: (val) {
                      setState(() {
                        searchText = val;
                      });
                    },
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        Get.to(() => SearchResultScreen(
                              searchTerm: val,
                              isDetailed: true,
                            ));
                      }
                    },
                    textFieldStyle: FxTextFieldStyle.outlined,
                    filled: true,
                    fillColor: customTheme.card,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    autoFocusedBorder: true,
                    textInputAction: TextInputAction.search,
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: customTheme.estatePrimary,
                      size: 20,
                    ),
                    labelTextColor: customTheme.estatePrimary,
                    cursorColor: customTheme.estatePrimary,
                    labelText: 'Search Property',
                    labelStyle: TextStyle(
                        fontSize: 12, color: customTheme.estatePrimary),
                    focusedBorderColor: customTheme.estatePrimary,
                    enabledBorderColor: customTheme.estatePrimary,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                FxContainer.bordered(
                  onTap: () {
                    if (searchText != null) {
                      Get.to(() => SearchResultScreen(
                            searchTerm: searchText!,
                            isDetailed: true,
                          ));
                    }
                  },
                  paddingAll: 10,
                  child: Icon(
                    CupertinoIcons.search,
                    color: customTheme.estatePrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FxText.titleSmall(
              'POPULAR AGENTS',
              fontWeight: 600,
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('agents').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          10,
                          (index) => const MyShimmer(
                            child: CircleAvatar(
                              radius: 24,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!.docs
                          .map((doc) =>
                              AgentAvatar(agent: AgentModel.fromJson(doc)))
                          .toList(),
                    ),
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            FxText.titleSmall(
              'RECENTLY SEARCHED',
              fontWeight: 600,
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('userData')
                    .doc('recentSearch')
                    .collection(uid)
                    .orderBy('createdAt')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  return Expanded(
                    child: ListView(
                      children: List.generate(
                          docs.length,
                          (i) => ListTile(
                                leading: const Icon(CupertinoIcons.search),
                                title: Text(docs[i]['term']),
                                onTap: () {
                                  Get.to(() => SearchResultScreen(
                                        searchTerm: docs[i]['term'],
                                        isDetailed: true,
                                      ));
                                },
                                trailing: const Icon(
                                  Icons.north_east,
                                ),
                              )),
                    ),
                  );
                })
          ]),
        ),
      ),
    );
  }
}
