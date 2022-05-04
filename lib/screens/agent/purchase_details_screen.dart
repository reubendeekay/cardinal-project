import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/models/request_model.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:intl/intl.dart';

class PurchaseDetailsScreen extends StatefulWidget {
  const PurchaseDetailsScreen({Key? key, required this.purchase})
      : super(key: key);
  final PurchaseModel purchase;

  @override
  State<PurchaseDetailsScreen> createState() => _PurchaseDetailsScreenState();
}

class _PurchaseDetailsScreenState extends State<PurchaseDetailsScreen> {
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
          title: FxText.titleMedium("Details", fontWeight: 600),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        widget.purchase.property.coverImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                FxText.titleMedium(widget.purchase.property.name!,
                    fontWeight: 700),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  color: customTheme.estatePrimary,
                  child: FxText.bodySmall(
                    '4.5',
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            FxText.titleMedium('KES ' + widget.purchase.request.amount!),
            const SizedBox(height: 20),
            Row(
              children: [
                Hero(
                  tag: 'user-profile',
                  transitionOnUserGestures: true,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: CachedNetworkImageProvider(
                        widget.purchase.user.profilePic!),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.bodyMedium(widget.purchase.user.fullName!,
                        fontWeight: 700),
                    const SizedBox(height: 5),
                    FxText.bodySmall(widget.purchase.user.phoneNumber!),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FxText.titleMedium('Purchase Details', fontWeight: 700),
            const SizedBox(
              height: 20,
            ),
            paymentWidget(
              'Payment Status',
              widget.purchase.request.status!,
            ),
            paymentWidget(
              'Payment Method',
              widget.purchase.request.paymentMethod!,
            ),
            paymentWidget(
              'Paid on',
              DateFormat('ddd MMM yyyy')
                  .format(widget.purchase.request.createdAt!.toDate()),
            ),
            paymentWidget(
              'Transaction ID',
              widget.purchase.request.id!,
            ),
          ],
        ));
  }

  Widget paymentWidget(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.bodySmall(
            title,
            color: Colors.grey,
          ),
          const SizedBox(height: 5),
          FxText.bodyMedium(value, fontWeight: 700),
        ],
      ),
    );
  }
}
