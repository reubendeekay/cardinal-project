import 'package:cardinal/controllers/property_controller.dart';
import 'package:cardinal/models/category.dart';
import 'package:cardinal/providers/search_provider.dart.dart';
import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/screens/home/widgets/search_property_card.dart';
import 'package:cardinal/screens/home_screen.dart';
import 'package:cardinal/screens/search_screen.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  SearchResultScreen(
      {Key? key, required this.searchTerm, this.isDetailed = false})
      : super(key: key);
  String searchTerm;
  final bool isDetailed;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  late PropertyController estateHomeController;

  @override
  void initState() {
    super.initState();
    estateHomeController = FxControllerStore.putOrFind(PropertyController());

    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  List<Widget> filterCategory() {
    List<Widget> list = [];
    list.add(FxSpacing.width(24));
    for (Category category in estateHomeController.categories!) {
      list.add(filterCategoryList(category));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PropertyModel>>(
        future: widget.isDetailed
            ? Provider.of<SearchProvider>(context, listen: false)
                .detailedSearchProperty(
                baths: estateHomeController.selectedBathRooms,
                beds: estateHomeController.selectedBedRooms,
                minprice: estateHomeController.selectedRange.start.toString(),
                maxPrice: estateHomeController.selectedRange.end.toString(),
                term: widget.searchTerm,
                type: estateHomeController.categories!
                    .map((e) => e.category.toLowerCase())
                    .toList(),
              )
            : Provider.of<SearchProvider>(context, listen: false)
                .searchData(widget.searchTerm),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                  margin: FxSpacing.top(16),
                  child: LoadingEffect.getSearchLoadingScreen(
                    context,
                  )),
            );
          }
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: FxSpacing.fromLTRB(15, 15, 15, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FxTextField(
                              textFieldStyle: FxTextFieldStyle.outlined,
                              filled: true,
                              onSubmitted: (val) {
                                setState(() {
                                  widget.searchTerm = val;
                                });
                              },
                              fillColor: customTheme.card,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              autoFocusedBorder: true,
                              prefixIcon: Icon(
                                CupertinoIcons.search,
                                color: customTheme.estatePrimary,
                                size: 20,
                              ),
                              labelTextColor: customTheme.estatePrimary,
                              cursorColor: customTheme.estatePrimary,
                              labelText: widget.searchTerm,
                              labelStyle: TextStyle(
                                  fontSize: 12,
                                  color: customTheme.estatePrimary),
                              focusedBorderColor: customTheme.estatePrimary,
                              enabledBorderColor: customTheme.estatePrimary,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          FxContainer.bordered(
                            onTap: () {
                              _selectSizeSheet(context);
                            },
                            paddingAll: 10,
                            child: Icon(
                              Icons.more_horiz_outlined,
                              color: customTheme.estatePrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FxText.titleSmall('${snapshot.data!.length} RESULTS'),
                      Expanded(
                        child: ListView(
                          children: [
                            const SizedBox(height: 10),
                            ...snapshot.data!
                                .map((e) => SearchPropertyCard(property: e))
                                .toList(),
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          );
        });
  }

  void _selectSizeSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return FxContainer(
                padding: FxSpacing.top(24),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxCard.rounded(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            paddingAll: 6,
                            color: customTheme.border,
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          FxText.bodyMedium(
                            'Filters',
                            fontWeight: 600,
                          ),
                          FxText.bodySmall(
                            'Reset',
                            color: customTheme.estatePrimary,
                          ),
                        ],
                      ),
                    ),
                    FxSpacing.height(8),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: FxText.bodyMedium(
                        'Category',
                        fontWeight: 700,
                      ),
                    ),
                    FxSpacing.height(8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: filterCategory(),
                      ),
                    ),
                    FxSpacing.height(16),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: FxText.bodyMedium(
                        'Price Range ( '
                        '${estateHomeController.selectedRange.start.toInt().toString()} - '
                        '${estateHomeController.selectedRange.end.toInt().toString()} )',
                        fontWeight: 700,
                      ),
                    ),
                    RangeSlider(
                        activeColor: customTheme.estatePrimary,
                        inactiveColor: customTheme.estatePrimary.withAlpha(100),
                        max: 10000,
                        min: 0,
                        values: estateHomeController.selectedRange,
                        onChanged: (RangeValues newRange) {
                          setState(() =>
                              estateHomeController.selectedRange = newRange);
                        }),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: FxText.bodyMedium(
                        'Bed Rooms',
                        fontWeight: 700,
                      ),
                    ),
                    FxSpacing.height(8),
                    SingleChildScrollView(
                      padding: FxSpacing.x(24),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children:
                              ['Any', '1', '2', '3', '4', '5'].map((element) {
                        return InkWell(
                            onTap: () {
                              setState(() {
                                if (estateHomeController.selectedBedRooms
                                    .contains(element)) {
                                  estateHomeController.selectedBedRooms
                                      .remove(element);
                                } else {
                                  estateHomeController.selectedBedRooms
                                      .add(element);
                                }
                              });
                            },
                            child: SingleBed(
                              bed: element,
                              selected: estateHomeController.selectedBedRooms
                                  .contains(element),
                            ));
                      }).toList()),
                    ),
                    FxSpacing.height(16),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: FxText.bodyMedium(
                        'Bath Rooms',
                        fontWeight: 700,
                      ),
                    ),
                    FxSpacing.height(8),
                    SingleChildScrollView(
                      padding: FxSpacing.x(24),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children:
                              ['Any', '1', '2', '3', '4', '5'].map((element) {
                        return InkWell(
                            onTap: () {
                              setState(() {
                                if (estateHomeController.selectedBathRooms
                                    .contains(element)) {
                                  estateHomeController.selectedBathRooms
                                      .remove(element);
                                } else {
                                  estateHomeController.selectedBathRooms
                                      .add(element);
                                }
                              });
                            },
                            child: SingleBath(
                              bath: element,
                              selected: estateHomeController.selectedBathRooms
                                  .contains(element),
                            ));
                      }).toList()),
                    ),
                    FxSpacing.height(16),
                    Padding(
                      padding: FxSpacing.horizontal(24),
                      child: FxButton.block(
                        borderRadiusAll: 8,
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(context);
                        },
                        backgroundColor: customTheme.estatePrimary,
                        child: FxText.titleSmall(
                          "Apply Filters",
                          fontWeight: 700,
                          color: customTheme.estateOnPrimary,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    FxSpacing.height(16),
                  ],
                ),
              );
            },
          );
        });
  }

  Widget filterCategoryList(Category category) {
    return FxContainer(
      paddingAll: 8,
      borderRadiusAll: 8,
      margin: FxSpacing.right(8),
      bordered: true,
      splashColor: customTheme.medicarePrimary.withAlpha(40),
      color: customTheme.card,
      child: Row(
        children: [
          Icon(
            category.categoryIcon,
            color: customTheme.estatePrimary,
            size: 16,
          ),
          FxSpacing.width(8),
          FxText.bodySmall(
            category.category,
            fontWeight: 600,
          ),
        ],
      ),
    );
  }
}
