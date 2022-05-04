import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/screens/property_details_screen.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    Key? key,
    required this.customTheme,
    required this.theme,
    required this.property,
  }) : super(key: key);

  final CustomTheme customTheme;
  final ThemeData theme;
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    return FxCard(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PropertyDetailsScreen(property)));
      },
      margin: FxSpacing.nTop(24),
      paddingAll: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadiusAll: 16,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image(
              image: NetworkImage(property.coverImage!),
              fit: BoxFit.cover,
            ),
          ),
          FxContainer(
            paddingAll: 16,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.bodyMedium(
                      property.name!,
                      fontWeight: 700,
                    ),
                    FxText.bodyMedium(
                      'KES ' + property.price!,
                      fontWeight: 600,
                      color: customTheme.estateSecondary,
                    ),
                  ],
                ),
                FxSpacing.height(4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: theme.colorScheme.onBackground.withAlpha(180),
                    ),
                    FxSpacing.width(4),
                    FxText.bodySmall(
                      property.address!,
                      xMuted: true,
                    ),
                  ],
                ),
                FxSpacing.height(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.king_bed,
                            size: 16,
                            color:
                                theme.colorScheme.onBackground.withAlpha(180),
                          ),
                          FxSpacing.width(4),
                          FxText.bodySmall(
                            property.ammenities!.beds! + ' Beds',
                            xMuted: true,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bathtub,
                            size: 16,
                            color:
                                theme.colorScheme.onBackground.withAlpha(180),
                          ),
                          FxSpacing.width(4),
                          FxText.bodySmall(
                            property.ammenities!.bathrooms! + ' Bathrooms',
                            xMuted: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                FxSpacing.height(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.square_foot,
                            size: 16,
                            color:
                                theme.colorScheme.onBackground.withAlpha(180),
                          ),
                          FxSpacing.width(4),
                          FxText.bodySmall(
                            property.ammenities!.floors! + ' Floors',
                            xMuted: true,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.aspect_ratio,
                            size: 16,
                            color:
                                theme.colorScheme.onBackground.withAlpha(180),
                          ),
                          FxSpacing.width(4),
                          FxText.bodySmall(
                            property.ammenities!.area!,
                            xMuted: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
