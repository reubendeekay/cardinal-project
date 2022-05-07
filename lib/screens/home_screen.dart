import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/providers/location_provider.dart';
import 'package:cardinal/screens/home/widgets/property_card.dart';
import 'package:cardinal/screens/search/search_property_screen.dart';
import 'package:cardinal/screens/search_results_screen.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:cardinal/helpers/loading_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import '../controllers/property_controller.dart';
import '../models/category.dart';

class EstateHomeScreen extends StatefulWidget {
  const EstateHomeScreen({Key? key}) : super(key: key);

  @override
  _EstateHomeScreenState createState() => _EstateHomeScreenState();
}

class _EstateHomeScreenState extends State<EstateHomeScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  late PropertyController estateHomeController;

  @override
  void initState() {
    super.initState();
    estateHomeController = FxControllerStore.putOrFind(PropertyController());
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  List<Widget> allProperty() {
    List<Widget> list = [];
    list.add(FxSpacing.width(24));

    for (Category category in estateHomeController.categories!) {
      list.add(categories(category));
    }
    return list;
  }

  List<Widget> propertyList() {
    List<Widget> list = [];
    list.add(FxSpacing.width(24));

    for (PropertyModel property in estateHomeController.properties) {
      list.add(PropertyCard(
          customTheme: customTheme, theme: theme, property: property));
    }
    return list;
  }

  Widget categories(Category category) {
    return InkWell(
      onTap: () {
        Get.to(() => SearchResultScreen(searchTerm: category.category));
      },
      child: Container(
        margin: FxSpacing.right(16),
        child: Column(
          children: [
            FxContainer.rounded(
              color: customTheme.card.withAlpha(180),
              child: Icon(
                category.categoryIcon,
                color: customTheme.estatePrimary,
              ),
            ),
            FxSpacing.height(8),
            FxText.labelSmall(
              category.category,
              xMuted: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<PropertyController>(
        controller: estateHomeController,
        builder: (estateHomeController) {
          return SafeArea(
            child: Scaffold(
              body: RefreshIndicator(
                onRefresh: () async {
                  return await estateHomeController.fetchProperties();
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 2,
                      child: estateHomeController.showLoading
                          ? LinearProgressIndicator(
                              color: customTheme.estatePrimary,
                              minHeight: 2,
                            )
                          : Container(
                              height: 2,
                            ),
                    ),
                    Expanded(
                      child: _buildBody(),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildBody() {
    if (estateHomeController.uiLoading) {
      return Container(
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            context,
          ));
    } else {
      return ListView(
        padding: FxSpacing.top(16),
        children: [
          Padding(
            padding: FxSpacing.horizontal(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.bodySmall(
                      'Location',
                      xMuted: true,
                    ),
                    FxSpacing.height(2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: customTheme.estatePrimary,
                          size: 14,
                        ),
                        FxSpacing.width(4),
                        FutureBuilder(
                            future: Provider.of<LocationProvider>(context,
                                    listen: false)
                                .getCurrentLocation(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final loc = Provider.of<LocationProvider>(
                                        context,
                                        listen: false)
                                    .userLocation;
                                return FxText.bodyMedium(
                                    loc!.state! + ', ' + loc.country!);
                              }
                              return FxText.bodyMedium(
                                'Nairobi, KE',
                                fontWeight: 600,
                              );
                            }),
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: customTheme.estatePrimary,
                        ),
                      ],
                    ),
                  ],
                ),
                FxContainer.bordered(
                  onTap: () {
                    // _selectSizeSheet(context);
                    Get.to(() => const SearchPropertyScreen());
                  },
                  paddingAll: 6,
                  child: Icon(
                    CupertinoIcons.search,
                    color: customTheme.estatePrimary,
                  ),
                ),
              ],
            ),
          ),
          FxSpacing.height(24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: allProperty(),
            ),
          ),
          FxSpacing.height(24),
          Padding(
            padding: FxSpacing.horizontal(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FxText.bodyLarge(
                  'Recommended',
                  fontWeight: 600,
                ),
                // FxText.bodySmall(
                //   'More',
                //   xMuted: true,
                // ),
              ],
            ),
          ),
          FxSpacing.height(16),
          Column(
            children: propertyList(),
          ),
        ],
      );
    }
  }
}

class SingleBed extends StatefulWidget {
  final String bed;
  final bool selected;

  const SingleBed({Key? key, required this.bed, required this.selected})
      : super(key: key);

  @override
  _SingleBedState createState() => _SingleBedState();
}

class _SingleBedState extends State<SingleBed> {
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    bool selected = widget.selected;

    return FxContainer(
      padding: FxSpacing.symmetric(horizontal: 16, vertical: 8),
      borderRadiusAll: 8,
      margin: FxSpacing.right(12),
      bordered: true,
      border: Border.all(
          color: selected ? customTheme.estatePrimary : customTheme.border),
      splashColor: customTheme.medicarePrimary.withAlpha(40),
      color: selected ? customTheme.estatePrimary : customTheme.border,
      child: FxText.bodySmall(
        widget.bed,
        fontWeight: 600,
        color: selected
            ? customTheme.estateOnPrimary
            : theme.colorScheme.onBackground,
      ),
    );
  }
}

class SingleBath extends StatefulWidget {
  final String bath;
  final bool selected;

  const SingleBath({Key? key, required this.bath, required this.selected})
      : super(key: key);

  @override
  _SingleBathState createState() => _SingleBathState();
}

class _SingleBathState extends State<SingleBath> {
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    bool selected = widget.selected;

    return FxContainer(
      padding: FxSpacing.symmetric(horizontal: 16, vertical: 8),
      borderRadiusAll: 8,
      margin: FxSpacing.right(12),
      bordered: true,
      border: Border.all(
          color: selected ? customTheme.estatePrimary : customTheme.border),
      splashColor: customTheme.medicarePrimary.withAlpha(40),
      color: selected ? customTheme.estatePrimary : customTheme.border,
      child: FxText.bodySmall(
        widget.bath,
        fontWeight: 600,
        color: selected
            ? customTheme.estateOnPrimary
            : theme.colorScheme.onBackground,
      ),
    );
  }
}
