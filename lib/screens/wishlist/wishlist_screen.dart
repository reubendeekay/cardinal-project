import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/providers/property_provider.dart';
import 'package:cardinal/screens/home/widgets/search_property_card.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late CustomTheme customTheme;

  late ThemeData theme;

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
        backgroundColor: AppTheme.theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 20,
            color: AppTheme.theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        title: FxText.titleMedium("Wishlist", fontWeight: 600),
      ),
      body: FutureBuilder<List<PropertyModel>>(
        future: Provider.of<PropertyProvider>(
          context,
          listen: false,
        ).fetchYourWishlist(),
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return LoadingEffect.getSearchLoadingScreen(context);
          }

          return RefreshIndicator(
            onRefresh: () {
              setState(() {});
              return Provider.of<PropertyProvider>(
                context,
                listen: false,
              ).fetchYourWishlist();
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: data.data!.length,
              itemBuilder: (ctx, i) {
                return Column(
                  children: [
                    SearchPropertyCard(property: data.data![i]),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
