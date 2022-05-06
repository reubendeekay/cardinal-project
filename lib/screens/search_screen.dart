import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/providers/location_provider.dart';
import 'package:cardinal/screens/agent/edit_property_screen.dart';
import 'package:cardinal/screens/property_details_screen.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/search_controller.dart';

class EstateSearchScreen extends StatefulWidget {
  const EstateSearchScreen({Key? key}) : super(key: key);

  @override
  _EstateSearchScreenState createState() => _EstateSearchScreenState();
}

class _EstateSearchScreenState extends State<EstateSearchScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;
  late EstateSearchController estateSearchController;

  @override
  void initState() {
    super.initState();

    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    estateSearchController =
        FxControllerStore.putOrFind(EstateSearchController());
  }

  List<Widget> _buildHouseList() {
    List<Widget> properties = [];

    for (PropertyModel property in estateSearchController.properties!) {
      properties.add(PropertyTile(property));
    }
    estateSearchController.addMarkers();

    return properties;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<EstateSearchController>(
        controller: estateSearchController,
        builder: (estateSearchController) {
          return Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 2,
                  child: estateSearchController.showLoading
                      ? LinearProgressIndicator(
                          color: customTheme.estatePrimary,
                          minHeight: 2,
                        )
                      : Container(
                          height: 0,
                        ),
                ),
                Expanded(
                  child: _buildBody(context),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildBody(BuildContext context) {
    final loc =
        Provider.of<LocationProvider>(context, listen: false).locationData;

    if (estateSearchController.uiLoading) {
      return Container(
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            context,
          ));
    } else {
      return Stack(
        children: [
          GoogleMap(
            markers: estateSearchController.marker,
            onMapCreated: estateSearchController.onMapCreated,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(loc!.latitude!, loc.longitude!),
              zoom: 15.0,
            ),
          ),
          Positioned(
            top: FxSpacing.safeAreaTop(context) + 20,
            left: 24,
            right: 24,
            child: Row(
              children: [
                Expanded(
                  child: FxTextField(
                    onSubmitted: (value) async {
                      if (value.isNotEmpty) {
                        await estateSearchController.searchData(value);
                        setState(() {});
                      }
                    },
                    textFieldStyle: FxTextFieldStyle.outlined,
                    filled: true,
                    fillColor: customTheme.card,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    autoFocusedBorder: true,
                    textInputAction: TextInputAction.search,
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: customTheme.estatePrimary,
                      size: 20,
                    ),
                    labelTextColor: customTheme.estatePrimary,
                    cursorColor: customTheme.estatePrimary,
                    labelText: 'Search Location',
                    labelStyle: TextStyle(
                        fontSize: 12, color: customTheme.estatePrimary),
                    focusedBorderColor: customTheme.estatePrimary,
                    enabledBorderColor: customTheme.estatePrimary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              height: 100,
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              child: PageView(
                pageSnapping: true,
                physics: const ClampingScrollPhysics(),
                controller: estateSearchController.pageController,
                onPageChanged: estateSearchController.onPageChange,
                children: _buildHouseList(),
              ),
            ),
          ),
        ],
      );
    }
  }
}

class PropertyTile extends StatelessWidget {
  final PropertyModel property;
  final bool isAgent;

  const PropertyTile(this.property, {Key? key, this.isAgent = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Get.to(() => !isAgent
            ? EditPropertyScreen(property: property)
            : PropertyDetailsScreen(property));
      },
      child: FxCard(
        shadow: !isAgent ? FxShadow.none() : null,
        color: !isAgent ? themeData.cardColor : themeData.backgroundColor,
        borderRadiusAll: 8,
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
        margin: !isAgent
            ? const EdgeInsets.only(bottom: 8)
            : const EdgeInsets.only(bottom: 8, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                image: CachedNetworkImageProvider(property.coverImage!),
                fit: BoxFit.cover,
                width: 72,
                height: 72,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FxText.bodyLarge(property.name!,
                        fontWeight: 600, overflow: TextOverflow.ellipsis),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            MdiIcons.mapMarker,
                            color: themeData.colorScheme.onBackground,
                            size: 14,
                          ),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(left: 2),
                                child: FxText.bodySmall(property.address!,
                                    fontWeight: 400)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FxText.bodySmall('KES ${property.price}',
                        fontWeight: 600, color: themeData.primaryColor),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
