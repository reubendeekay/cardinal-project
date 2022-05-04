import 'package:cardinal/helpers/my_loader.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/models/request_model.dart';
import 'package:cardinal/models/user_model.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/providers/payment_provider.dart';
import 'package:cardinal/screens/payment/checkout_controller.dart';
import 'package:cardinal/screens/payment/shipping_address.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key, required this.property}) : super(key: key);
  final PropertyModel property;

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  late ThemeData theme;

  late CheckOutController controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.estateTheme;
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    controller = FxControllerStore.put(CheckOutController(user!));
  }

  Widget buildTabs() {
    List<Widget> tabs = [];

    for (int i = 0; i < controller.tabs.length; i++) {
      bool selected = controller.currentPage == i;
      tabs.add(Expanded(
        flex: selected ? 4 : 3,
        child: FxContainer(
          onTap: () {
            controller.onPageChanged(i, fromUser: true);
          },
          color: selected ? theme.colorScheme.primary : theme.cardTheme.color,
          paddingAll: 12,
          borderRadiusAll: 0,
          child: Column(
            children: [
              Icon(
                controller.tabs[i].iconData,
                size: 20,
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onBackground,
              ),
              FxText.bodySmall(
                controller.tabs[i].name,
                fontWeight: 600,
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ));
    }

    return Row(
      children: tabs,
    );
  }

  Widget contactWidget(UserModel userContact) {
    bool selected = controller.contactSelected == userContact;
    return FxContainer.bordered(
      onTap: () {
        controller.selectContactDetails(userContact);
      },
      borderRadiusAll: 4,
      margin: FxSpacing.bottom(20),
      border: Border.all(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onBackground),
      color: selected
          ? theme.colorScheme.primary.withAlpha(40)
          : theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FeatherIcons.user,
                size: 20,
                color: theme.colorScheme.onBackground.withAlpha(220),
              ),
              FxSpacing.width(12),
              FxText.bodyMedium(
                'Personal',
                fontWeight: 700,
              ),
              FxSpacing.width(12),
              FxContainer(
                borderRadiusAll: 4,
                padding: FxSpacing.xy(8, 4),
                color: theme.colorScheme.primary,
                child: FxText.bodySmall(
                  'Default',
                  color: theme.colorScheme.onPrimary,
                  fontSize: 11,
                ),
              ),
              selected
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FxContainer.roundBordered(
                          paddingAll: 4,
                          border: Border.all(color: theme.colorScheme.primary),
                          color: theme.colorScheme.primary.withAlpha(40),
                          child: Icon(
                            Icons.check,
                            color: theme.colorScheme.primary,
                            size: 10,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          FxSpacing.height(8),
          FxText.bodySmall(
            userContact.fullName!,
            fontWeight: 600,
          ),
          FxSpacing.height(4),
          FxText.bodySmall(
            userContact.email!,
            fontWeight: 600,
          ),
          FxSpacing.height(8),
          FxText.bodySmall(
            userContact.phoneNumber!,
            muted: true,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<CheckOutController>(
        controller: controller,
        builder: (controller) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: FxText.titleMedium(
                'Payment',
                fontWeight: 600,
              ),
              leading: InkWell(
                onTap: () {
                  controller.goBack();
                },
                child: const Icon(
                  FeatherIcons.chevronLeft,
                  size: 20,
                ),
              ),
            ),
            body: Column(
              children: [
                FxSpacing.height(8),
                FxContainer(
                  margin: FxSpacing.x(20),
                  paddingAll: 0,
                  color: Colors.transparent,
                  borderRadiusAll: 4,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: buildTabs(),
                ),
                FxSpacing.height(20),
                Expanded(
                  child: PageView(
                    allowImplicitScrolling: true,
                    pageSnapping: true,
                    physics: const ClampingScrollPhysics(),
                    controller: controller.pageController,
                    onPageChanged: (int page) {
                      controller.onPageChanged(page);
                    },
                    children: [
                      contactInformation(),
                      paymentInfo(),
                      placedInfo()
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget contactInformation() {
    return Container(
      padding: FxSpacing.x(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FxText.labelLarge(
          'Contact Information',
          fontWeight: 600,
        ),
        FxSpacing.height(20),
        contactWidget(controller.contactSelected!),
        Row(
          children: [
            FxButton(
              padding: FxSpacing.xy(16, 12),
              onPressed: () {
                Navigator.of(context).pop();
              },
              borderRadiusAll: 4,
              elevation: 0,
              splashColor: theme.colorScheme.primary.withAlpha(30),
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FeatherIcons.chevronLeft,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  FxSpacing.width(8),
                  FxText.labelMedium(
                    'Cancel',
                    color: theme.colorScheme.primary,
                    fontWeight: 600,
                  ),
                ],
              ),
            ),
            FxSpacing.width(20),
            Expanded(
              child: FxButton(
                padding: FxSpacing.y(12),
                onPressed: () {
                  controller.nextPage();
                },
                borderRadiusAll: 4,
                elevation: 0,
                splashColor: theme.colorScheme.onPrimary.withAlpha(30),
                backgroundColor: theme.colorScheme.primary,
                child: FxText.labelMedium(
                  'Proceed to Payment',
                  color: theme.colorScheme.onPrimary,
                  fontWeight: 600,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget paymentInfo() {
    return Container(
      padding: FxSpacing.x(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.labelLarge(
            'Select payment method',
            fontWeight: 600,
          ),
          FxSpacing.height(20),
          FxContainer.bordered(
            onTap: () {
              controller.selectPaymentMethod(1);
            },
            borderRadiusAll: 4,
            margin: FxSpacing.bottom(20),
            border: Border.all(
                color: controller.paymentMethodSelected == 1
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onBackground),
            color: controller.paymentMethodSelected == 1
                ? theme.colorScheme.primary.withAlpha(40)
                : theme.scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      FeatherIcons.creditCard,
                      size: 20,
                      color: theme.colorScheme.onBackground.withAlpha(220),
                    ),
                    FxSpacing.width(8),
                    FxText.bodyMedium(
                      'Credit Card',
                      fontWeight: 700,
                    ),
                    controller.paymentMethodSelected == 1
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FxContainer.roundBordered(
                                paddingAll: 4,
                                border: Border.all(
                                    color: theme.colorScheme.primary),
                                color: theme.colorScheme.primary.withAlpha(40),
                                child: Icon(
                                  Icons.check,
                                  color: theme.colorScheme.primary,
                                  size: 10,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                FxSpacing.height(8),
                FxText.bodySmall(
                  'Nency AnGhan',
                  fontWeight: 600,
                ),
                FxSpacing.height(4),
                FxText.bodySmall(
                  '**** **** **** 7865',
                  fontWeight: 600,
                ),
                FxSpacing.height(4),
                FxText.bodySmall(
                  'Expiry: 06/25',
                  fontWeight: 600,
                ),
                FxSpacing.height(20),
                FxText.bodySmall(
                  'Secure checkout powered by OnePay',
                  muted: true,
                ),
              ],
            ),
          ),
          FxContainer.bordered(
            onTap: () {
              controller.selectPaymentMethod(2);
            },
            borderRadiusAll: 4,
            margin: FxSpacing.bottom(20),
            border: Border.all(
                color: controller.paymentMethodSelected == 2
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onBackground),
            color: controller.paymentMethodSelected == 2
                ? theme.colorScheme.primary.withAlpha(40)
                : theme.scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      FeatherIcons.dollarSign,
                      size: 18,
                      color: theme.colorScheme.onBackground.withAlpha(220),
                    ),
                    FxSpacing.width(8),
                    FxText.bodyMedium(
                      'Cash on premise',
                      fontWeight: 700,
                    ),
                    controller.paymentMethodSelected == 2
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FxContainer.roundBordered(
                                paddingAll: 4,
                                border: Border.all(
                                    color: theme.colorScheme.primary),
                                color: theme.colorScheme.primary.withAlpha(40),
                                child: Icon(
                                  Icons.check,
                                  color: theme.colorScheme.primary,
                                  size: 10,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                FxSpacing.height(8),
                FxText.bodySmall(
                  'Deposit 20% for COP services.',
                  muted: true,
                ),
              ],
            ),
          ),
          FxText.labelLarge(
            'Do you have promo code?',
            fontWeight: 700,
          ),
          FxSpacing.height(20),
          FxContainer(
            paddingAll: 12,
            borderRadiusAll: 4,
            child: Row(
              children: [
                Icon(
                  FeatherIcons.creditCard,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                FxSpacing.width(16),
                Expanded(
                    child: FxText.labelLarge(
                  'Black Friday Promo',
                  fontWeight: 600,
                )),
                FxSpacing.width(16),
                FxContainer(
                  borderRadiusAll: 2,
                  padding: FxSpacing.xy(8, 4),
                  color: theme.colorScheme.primary.withAlpha(40),
                  child: FxText.bodySmall(
                    'BLCK20',
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          FxContainer(
            paddingAll: 12,
            borderRadiusAll: 4,
            child: Row(
              children: [
                Icon(
                  FeatherIcons.creditCard,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                FxSpacing.width(16),
                Expanded(
                    child: FxText.labelLarge(
                  'Cyber Week Deal',
                  fontWeight: 600,
                )),
                FxSpacing.width(16),
                FxContainer(
                  borderRadiusAll: 2,
                  padding: FxSpacing.xy(8, 4),
                  color: theme.colorScheme.primary.withAlpha(40),
                  child: FxText.bodySmall(
                    'CYBR00',
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          FxButton.block(
            onPressed: () async {
              final request = RequestModel(
                  amount: widget.property.price,
                  createdAt: Timestamp.now(),
                  ownerId: widget.property.ownerId,
                  paymentMethod: controller.paymentMethodSelected == 0
                      ? 'Credit Card'
                      : 'Cash on premise',
                  propertyId: widget.property.id,
                  status: 'Successful',
                  userId: uid);
              setState(() {
                isLoading = true;
              });

              await Provider.of<PaymentProvider>(context, listen: false)
                  .purchaseProperty(request);
              setState(() {
                isLoading = false;
              });
              controller.nextPage();
            },
            borderRadiusAll: 4,
            elevation: 0,
            splashColor: theme.colorScheme.onPrimary.withAlpha(30),
            backgroundColor: theme.colorScheme.primary,
            child: isLoading
                ? const MyLoader()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FxText.bodyMedium(
                        'Proceed to pay',
                        fontWeight: 600,
                        color: theme.colorScheme.onPrimary,
                      ),
                      FxText.bodyMedium(
                        'KES ' + widget.property.price!,
                        fontWeight: 700,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget placedInfo() {
    return Padding(
      padding: FxSpacing.x(20),
      child: Column(
        children: [
          Container(
              margin: FxSpacing.all(20),
              child: const Image(
                image: AssetImage('assets/images/order_success.png'),
              )),
          FxSpacing.height(20),
          FxText.titleLarge(
            'Payment Success',
            fontWeight: 700,
          ),
          FxSpacing.height(8),
          FxText.labelLarge(
            'You can reach out to the owner to\n get into your new premise',
            textAlign: TextAlign.center,
            xMuted: true,
          ),
          FxSpacing.height(24),
          FxButton.block(
            onPressed: () {
              controller.goBack();
            },
            borderRadiusAll: 4,
            elevation: 0,
            splashColor: theme.colorScheme.onPrimary.withAlpha(30),
            backgroundColor: theme.colorScheme.primary,
            child: FxText.labelLarge(
              'Back To Home',
              color: theme.colorScheme.onPrimary,
              fontWeight: 600,
            ),
          ),
        ],
      ),
    );
  }
}
