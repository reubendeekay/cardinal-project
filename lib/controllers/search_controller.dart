import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EstateSearchController extends FxController {
  bool showLoading = true, uiLoading = true;
  late GoogleMapController mapController;
  List<PropertyModel>? properties;
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);
  int currentPage = 0;

  final Set<Marker> marker = {};

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMapTheme();
  }

  @override
  void initState() {
    super.save = false;
    super.initState();
    fetchData();
  }

  Future<void> setMapTheme() async {
    if (AppTheme.theme == AppTheme.darkTheme) {
      String mapStyle =
          await rootBundle.loadString('assets/map/map-dark-style.txt');
      mapController.setMapStyle(mapStyle);
    }
  }

  Future fetchData() async {
    final propertyData = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
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

  Future<List<PropertyModel>> searchData(
    String term,
  ) async {
    final results = await FirebaseFirestore.instance
        .collection('propertyData/propertyListing/properties')
        .get();

    List<PropertyModel> properties = [];
    results.docs
        .where((e) =>
            e['name'].toLowerCase().contains(term.toLowerCase()) ||
            e['type'].toLowerCase().contains(term.toLowerCase()) ||
            e['description'].toLowerCase().contains(term.toLowerCase()) ||
            e['address'].toLowerCase().contains(term.toLowerCase()) ||
            e['type'].toLowerCase().contains(term.toLowerCase()) ||
            e['price'].toLowerCase().contains(term.toLowerCase()))
        .forEach((element) {
      properties.add(PropertyModel.fromJson(element));
    });
    uiLoading = false;
    showLoading = false;

    update();
    return properties;
  }

  @override
  String getTag() {
    return "search_controller";
  }

  onMarkerTap(int position) {
    currentPage = position;
    update();

    pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 800),
      curve: Curves.ease,
    );
  }

  onPageChange(int position) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: marker.toList()[position].position, zoom: 18)));
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  addMarkers() async {
    for (int i = 0; i < properties!.length; i++) {
      marker.add(
        Marker(
          icon: BitmapDescriptor.fromBytes(await getBytesFromAsset(
              'assets/images/apps/estate/marker.png', 64)),
          markerId: MarkerId(properties![i].id!),
          position: LatLng(properties![i].location!.latitude,
              properties![i].location!.longitude),
          onTap: () {
            onMarkerTap(i);
          },
        ),
      );
    }

    update();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
