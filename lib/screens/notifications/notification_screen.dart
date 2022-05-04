import 'package:cardinal/helpers/launc_email.dart';
import 'package:cardinal/screens/notifications/notification_controller.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ThemeData theme;

  late NotificationController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.estateTheme;

    controller = FxControllerStore.put(NotificationController());
  }

  Widget _buildSingleCoupon(
      String icon, String coupon, String time, String couponCode) {
    return FxContainer(
      paddingAll: 16,
      margin: FxSpacing.bottom(20),
      borderRadiusAll: 4,
      child: Row(
        children: [
          FxContainer(
            child: Image(
              height: 24,
              width: 24,
              image: AssetImage(icon),
              color: theme.colorScheme.onPrimary,
            ),
            color: theme.colorScheme.primary,
            paddingAll: 10,
            borderRadiusAll: 4,
          ),
          FxSpacing.width(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(
                  coupon,
                  fontWeight: 700,
                ),
                FxSpacing.height(8),
                FxText.bodySmall(
                  time,
                  muted: true,
                ),
                FxSpacing.height(2),
              ],
            ),
          ),
          FxSpacing.width(20),
          FxContainer(
            borderRadiusAll: 4,
            padding: FxSpacing.xy(8, 4),
            color: theme.colorScheme.primary.withAlpha(40),
            child: FxText.bodySmall(
              couponCode,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<NotificationController>(
        controller: controller,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                InkWell(
                    onTap: () {
                      controller.goBack();
                    },
                    child: Container(
                        margin: FxSpacing.x(16),
                        child: const Icon(Icons.clear_all))),
              ],
              title: FxText.bodyLarge(
                'Notifications',
                fontWeight: 600,
              ),
            ),
            body: ListView(
              padding: FxSpacing.nTop(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.bodyMedium(
                      'TODAY',
                      muted: true,
                      fontWeight: 600,
                    ),
                    FxText.bodyMedium(
                      'Mark as read',
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
                FxSpacing.height(16),
                InkWell(
                  onTap: () async {
                    await launchEmail('husseinny1705@gmail.com');
                  },
                  child: FxContainer(
                    paddingAll: 16,
                    borderRadiusAll: 4,
                    color: theme.colorScheme.primaryContainer,
                    child: Row(
                      children: [
                        FxContainer(
                          child: Image(
                            height: 24,
                            width: 24,
                            image: const AssetImage(
                                'assets/images/apps/shopping2/icons/discount_bubble_outline.png'),
                            color: theme.colorScheme.onPrimary,
                          ),
                          color: theme.colorScheme.primary,
                          paddingAll: 10,
                          borderRadiusAll: 4,
                        ),
                        FxSpacing.width(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FxText.bodyMedium(
                              'We Care About You',
                              fontWeight: 700,
                              color: theme.colorScheme.primary,
                            ),
                            FxSpacing.height(2),
                            FxText.bodySmall(
                              'Talk to us whenever you have a question',
                              xMuted: true,
                              color: theme.colorScheme.primary,
                            ),
                            FxSpacing.height(2),
                            Row(
                              children: [
                                FxText.bodySmall(
                                  'Contact us',
                                  color: theme.colorScheme.primary,
                                ),
                                FxSpacing.width(4),
                                Icon(
                                  FeatherIcons.chevronRight,
                                  color: theme.colorScheme.primary,
                                  size: 16,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                FxSpacing.height(20),
                FxText.bodyMedium(
                  'YESTERDAY',
                  muted: true,
                  fontWeight: 600,
                ),
                FxSpacing.height(20),
                _buildSingleCoupon(
                    'assets/images/apps/shopping2/icons/discount_coupon_outline.png',
                    'Daily Cashback',
                    '8:00 AM',
                    '#DAILY'),
                _buildSingleCoupon(
                    'assets/images/apps/shopping2/icons/discount_circle_outline.png',
                    'Use BLCK10 Promo Code',
                    '3:40 PM',
                    '#BLCK10'),
                _buildSingleCoupon(
                    'assets/images/apps/shopping2/icons/discount_bubble_outline.png',
                    'Cyber Monday Deal',
                    '10:39 AM',
                    '#MON'),
                FxText.bodyMedium(
                  'LAST 7 DAYS',
                  muted: true,
                  fontWeight: 600,
                ),
                FxSpacing.height(20),
                _buildSingleCoupon(
                    'assets/images/apps/shopping2/icons/discount_coupon_outline.png',
                    'Use NOV10 Promo Code',
                    '3:40 PM',
                    '#NOV10'),
                _buildSingleCoupon(
                    'assets/images/apps/shopping2/icons/discount_bubble_outline.png',
                    '30% Black friday deal',
                    '12:50 PM',
                    '#FRI30'),
              ],
            ),
          );
        });
  }
}
