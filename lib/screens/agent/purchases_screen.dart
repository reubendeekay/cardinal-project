import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/models/request_model.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/providers/payment_provider.dart';
import 'package:cardinal/screens/agent/purchase_details_screen.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({Key? key}) : super(key: key);

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
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
    return FutureBuilder<List<PurchaseModel>>(
        future: Provider.of<PaymentProvider>(context, listen: false)
            .getAllPurchases(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: LoadingEffect.getSearchLoadingScreen(context));
          }
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
              title: FxText.titleMedium("Customer Purchases", fontWeight: 600),
            ),
            body: ListView(
              children: List.generate(snapshot.data!.length,
                  (index) => PurchaseTile(purchase: snapshot.data![index])),
            ),
          );
        });
  }
}

class PurchaseTile extends StatelessWidget {
  const PurchaseTile({Key? key, required this.purchase}) : super(key: key);
  final PurchaseModel purchase;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Hero(
            tag: 'user-profile',
            transitionOnUserGestures: false,
            child: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(purchase.user.profilePic!),
            ),
          ),
          title: FxText.bodyMedium(purchase.user.fullName!, fontWeight: 700),
          subtitle: FxText.bodySmall(purchase.property.name!, muted: true),
          trailing:
              FxText.bodySmall("KES " + purchase.request.amount!, muted: true),
          onTap: () {
            Get.to(() => PurchaseDetailsScreen(
                  purchase: purchase,
                ));
          },
        ),
        const Divider(
          height: 1,
        ),
      ],
    );
  }
}
