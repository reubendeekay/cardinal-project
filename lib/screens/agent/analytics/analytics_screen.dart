import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/providers/property_provider.dart';
import 'package:cardinal/screens/agent/analytics/chart_widget.dart.dart';
import 'package:cardinal/screens/agent/analytics/coin.dart';
import 'package:cardinal/screens/agent/analytics/analytics_controller.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late ThemeData theme;
  late AnalyticsController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.estateTheme;
    controller = FxControllerStore.putOrFind(AnalyticsController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AnalyticsController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: FxSpacing.fromLTRB(
                    20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleRow(),
                    FxSpacing.height(32),
                    statistics(),
                    FxSpacing.height(12),
                    const Divider(),
                    SizedBox(
                        height: 405,
                        child: SingleCoinScreen(coin: controller.coins[0])),
                    FxSpacing.height(12),
                    FxText.titleMedium(
                      "Listing Performance",
                      fontWeight: 700,
                    ),
                    FxSpacing.height(20),
                    FutureBuilder(
                        future: Provider.of<PropertyProvider>(context,
                                listen: false)
                            .fetchAgentProperties(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingEffect.getSearchLoadingScreen(
                                context);
                          }
                          return assetsView(context);
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleLarge(
              "KES 25,0000,587.56",
              fontWeight: 700,
            ),
            FxText.titleSmall(
              "Portfolio balance",
              fontWeight: 600,
              xMuted: true,
            ),
          ],
        ),
        FxContainer.rounded(
            paddingAll: 8,
            color: theme.colorScheme.primaryContainer,
            child: Icon(
              FeatherIcons.arrowUpRight,
              size: 20,
              color: theme.colorScheme.onPrimaryContainer,
            )),
      ],
    );
  }

  Widget statistics() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FxText.bodySmall(
              "Today\'s Results",
              xMuted: true,
              fontWeight: 600,
            ),
            FxText.bodyMedium(
              "KES 5,513.65",
              fontWeight: 700,
            ),
          ],
        ),
        FxSpacing.height(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FxText.bodySmall(
              "Estimated Profit",
              xMuted: true,
              fontWeight: 600,
            ),
            FxText.bodyMedium(
              "KES 10,001.40",
              fontWeight: 700,
            ),
          ],
        ),
        FxSpacing.height(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FxText.bodySmall(
              "Realized Profit",
              xMuted: true,
              fontWeight: 600,
            ),
            FxText.bodyMedium(
              "KES 100,020.55",
              fontWeight: 700,
            ),
          ],
        ),
      ],
    );
  }

  Widget assetsView(
    BuildContext context,
  ) {
    List<Widget> list = [];
    final properties =
        Provider.of<PropertyProvider>(context, listen: false).properties;

    for (int i = 0; i < properties.length; i++) {
      PropertyModel property = properties[i];
      list.add(
        FxContainer(
          onTap: () {},
          margin: FxSpacing.bottom(20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(property.coverImage!),
              ),
              FxSpacing.width(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.bodySmall(
                      property.name!.toUpperCase(),
                      fontWeight: 700,
                    ),
                    FxText.bodySmall(
                      property.address!,
                      fontSize: 10,
                    ),
                  ],
                ),
              ),
              FxSpacing.width(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.bodySmall(
                    'Views',
                    fontWeight: 600,
                    fontSize: 10,
                  ),
                  FxText.bodySmall(
                    property.views.toString(),
                    color: property.views < 10 ? Colors.red : Colors.green,
                    fontSize: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: list,
    );
  }
}
