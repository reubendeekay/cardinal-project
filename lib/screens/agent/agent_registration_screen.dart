import 'dart:convert';
import 'dart:io';

import 'package:cardinal/helpers/add_on_map.dart';
import 'package:cardinal/helpers/my_loader.dart';
import 'package:cardinal/models/agent_model.dart';
import 'package:cardinal/providers/agent_provider.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/screens/agent/agent_splash.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AgentRegistrationScreen extends StatefulWidget {
  const AgentRegistrationScreen({Key? key}) : super(key: key);

  @override
  _AgentRegistrationScreenState createState() =>
      _AgentRegistrationScreenState();
}

class _AgentRegistrationScreenState extends State<AgentRegistrationScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  String? agentName,
      userId,
      email,
      agencyNumber,
      address,
      phoneNumber,
      website,
      registrationNumber,
      description,
      properties;
  LatLng? location;
  File? image;
  List<Media> mediaList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              FeatherIcons.chevronLeft,
              size: 20,
              color: theme.colorScheme.onBackground,
            ),
          ),
          centerTitle: true,
          title: FxText.titleMedium("Register as Agent", fontWeight: 600),
        ),
        body: ListView(
          padding: FxSpacing.nTop(20),
          children: <Widget>[
            FxText.bodyLarge("Personal information",
                fontWeight: 600, letterSpacing: 0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    style: FxTextStyle.titleSmall(
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: customTheme.card,
                      prefixIcon: const Icon(
                        MdiIcons.emailOutline,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        phoneNumber = val;
                      });
                    },
                    style: FxTextStyle.titleSmall(
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      hintText: "Number",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: customTheme.card,
                      prefixIcon: const Icon(
                        MdiIcons.phoneOutline,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        description = val;
                      });
                    },
                    style: FxTextStyle.titleSmall(
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: customTheme.card,
                      prefixIcon: const Icon(
                        MdiIcons.emailOutline,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                InkWell(
                  onTap: () {
                    openImagePicker(context);
                  },
                  child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                              backgroundColor:
                                  theme.colorScheme.primary.withAlpha(28),
                              child: const Icon(Icons.camera_alt_outlined)),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('Agent Profile'),
                          const Spacer(),
                          Icon(
                            Icons.check_circle,
                            color: image == null
                                ? theme.colorScheme.primary.withAlpha(28)
                                : Colors.green,
                          )
                        ],
                      )),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 24, bottom: 0),
              child: FxText.bodyLarge("Company information",
                  fontWeight: 600, letterSpacing: 0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        agentName = val;
                      });
                    },
                    style: FxTextStyle.titleSmall(
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: customTheme.card,
                      prefixIcon: const Icon(
                        MdiIcons.domain,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        registrationNumber = val;
                      });
                    },
                    style: FxTextStyle.titleSmall(
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      hintText: "Agency Number",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: customTheme.card,
                      prefixIcon: const Icon(
                        MdiIcons.briefcaseOutline,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        website = val;
                      });
                    },
                    style: FxTextStyle.titleSmall(
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      hintText: "Website",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: customTheme.card,
                      prefixIcon: const Icon(
                        MdiIcons.web,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: FxText.bodyLarge("Other Information",
                  fontWeight: 600, letterSpacing: 0),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    address = val;
                  });
                },
                style: FxTextStyle.titleSmall(
                    letterSpacing: 0,
                    color: theme.colorScheme.onBackground,
                    fontWeight: 500),
                decoration: InputDecoration(
                  hintText: "Address",
                  hintStyle: FxTextStyle.titleSmall(
                      letterSpacing: 0,
                      color: theme.colorScheme.onBackground,
                      fontWeight: 500),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: customTheme.card,
                  prefixIcon: const Icon(MdiIcons.locationEnter),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => AddOnMap(
                      onChanged: (val) {
                        setState(() {
                          location = val;
                        });
                      },
                    ));
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundColor:
                              theme.colorScheme.primary.withAlpha(28),
                          child: const Icon(Icons.location_on_outlined)),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Location on Map'),
                      const Spacer(),
                      Icon(
                        Icons.check_circle,
                        color: location == null
                            ? theme.colorScheme.primary.withAlpha(28)
                            : Colors.green,
                      )
                    ],
                  )),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.only(top: 24),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(28),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final agent = AgentModel(
                        agentName: agentName,
                        address: address,
                        location:
                            GeoPoint(location!.latitude, location!.longitude),
                        description: description,
                        email: email,
                        phoneNumber: phoneNumber,
                        registrationNumber: registrationNumber,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        website: website,
                        profilePicFile: image,
                        numProperties: 0,
                      );
                      await Provider.of<AgentProvider>(context, listen: false)
                          .registerAsAgent(agent)
                          .then((_) async {
                        setState(() {
                          isLoading = false;
                        });
                        final uid = FirebaseAuth.instance.currentUser!.uid;

                        await sendEmail(agent.agentName!, agent.email!,
                            'https://us-central1-cardinal-realty-2975d.cloudfunctions.net/sendVerify/user?uid=$uid');

                        showDialog(
                            context: context,
                            builder: (ctx) => Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Verification Email Sent',
                                        style: FxTextStyle.bodyMedium(
                                            color: Colors.black,
                                            fontWeight: 500),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Please verify your email address to continue',
                                        style: FxTextStyle.bodyMedium(
                                            color: Colors.black,
                                            fontWeight: 500),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text('OK'),
                                      )
                                    ],
                                  ),
                                ));
                        // await Provider.of<AuthProvider>(context, listen: false)
                        //     .getAgent();
                        // Get.off(() => const AgentSplashScreen());
                      });
                    },
                    child: isLoading
                        ? const MyLoader()
                        : FxText.bodyMedium("REGISTER",
                            fontWeight: 600,
                            color: theme.colorScheme.onPrimary),
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(FxSpacing.xy(16, 0))),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> openImagePicker(
    BuildContext context,
  ) async {
    // openCamera(onCapture: (image){
    //   setState(()=> mediaList = [image]);
    // });
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                maxChildSize: 0.95,
                minChildSize: 0.6,
                builder: (ctx, controller) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    color: Colors.white,
                    child: MediaPicker(
                      scrollController: controller,
                      mediaList: mediaList,
                      onPick: (selectedList) {
                        setState(() => mediaList = selectedList);

                        image = mediaList.first.file;

                        mediaList.clear();

                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                      mediaCount: MediaCount.single,
                      mediaType: MediaType.image,
                      decoration: PickerDecoration(
                        cancelIcon: const Icon(Icons.close),
                        albumTitleStyle: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontWeight: FontWeight.bold),
                        actionBarPosition: ActionBarPosition.top,
                        blurStrength: 2,
                        completeButtonStyle: const ButtonStyle(),
                        completeTextStyle:
                            TextStyle(color: Theme.of(context).iconTheme.color),
                        completeText: 'Select',
                      ),
                    )),
              ));
        });
  }
}

Future sendEmail(
  String name,
  String email,
  String message,
) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_f018cgj';
  const templateId = 'template_d0evdlz';
  const userId = '2Oe5jR6U4O4YwSQ_7';
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json'
      }, //This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {'name': name, 'message': message, 'email': email}
      }));
  print(response.body);

  return response.statusCode;
}
