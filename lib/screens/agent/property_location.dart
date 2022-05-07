import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cardinal/models/property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PropertyLocation extends StatefulWidget {
  final PropertyModel? property;
  const PropertyLocation({Key? key, this.property}) : super(key: key);
  @override
  _PropertyLocationState createState() => _PropertyLocationState();
}

class _PropertyLocationState extends State<PropertyLocation> {
  final GlobalKey globalKey = GlobalKey();
  GoogleMapController? mapController;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    mapController!.setMapStyle(value);

    _markers.add(
      Marker(
        icon: BitmapDescriptor.fromBytes(await getBytesFromAsset(
            'assets/images/apps/estate/marker.png', 64)),
        markerId: MarkerId(widget.property!.id!),
        position: LatLng(widget.property!.location!.latitude,
            widget.property!.location!.longitude),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GoogleMap(
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.property!.location!.latitude,
                        widget.property!.location!.longitude),
                    zoom: 13),
              ),
            ),
          ),
        ),
      ],
    );
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
