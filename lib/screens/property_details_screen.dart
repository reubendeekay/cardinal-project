import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/helpers/agent_shimer.dart';
import 'package:cardinal/helpers/cached_image.dart';
import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/models/agent_model.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/providers/agent_provider.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/screens/agent/property_location.dart';
import 'package:cardinal/screens/payment/checkout_screen.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../controllers/property_details_contoller.dart';
import 'agent/agent_profile.dart';
import 'package:flutter/material.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final PropertyModel property;

  const PropertyDetailsScreen(this.property, {Key? key}) : super(key: key);

  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  late PropertyDetailsController estateSingleEstateController;

  @override
  void initState() {
    super.initState();
    estateSingleEstateController =
        FxControllerStore.putOrFind(PropertyDetailsController(widget.property));
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<PropertyDetailsController>(
        controller: estateSingleEstateController,
        builder: (estateSingleEstateController) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: FxSpacing.top(5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2,
                      child: estateSingleEstateController.showLoading
                          ? LinearProgressIndicator(
                              color: customTheme.estatePrimary,
                              minHeight: 2,
                            )
                          : Container(
                              height: 2,
                            ),
                    ),
                    Expanded(
                      child: _buildBody(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildBody(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    if (estateSingleEstateController.uiLoading) {
      return Container(
          margin: FxSpacing.top(16),
          child: LoadingEffect.getSearchLoadingScreen(
            context,
          ));
    } else {
      return Container(
        padding: FxSpacing.fromLTRB(24, 8, 24, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: FxContainer.bordered(
                    paddingAll: 4,
                    child: Icon(
                      Icons.chevron_left_outlined,
                      color: theme.colorScheme.onBackground.withAlpha(200),
                    ),
                  ),
                ),
                FxText.bodyLarge(
                  'Details',
                  fontWeight: 700,
                ),
                InkWell(
                  onTap: () {
                    estateSingleEstateController.addWishList(
                        widget.property.id!,
                        user!.wishList!.contains(widget.property.id!));
                    setState(() {
                      user.wishList!.contains(widget.property.id!)
                          ? user.wishList!.remove(widget.property.id!)
                          : user.wishList!.add(widget.property.id!);
                    });
                  },
                  child: FxContainer.bordered(
                    paddingAll: 5,
                    child: Icon(
                      user!.wishList!.contains(widget.property.id!)
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: user.wishList!.contains(widget.property.id!)
                          ? Colors.red
                          : Colors.black,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: FxSpacing.y(16),
                children: [
                  FxContainer(
                    paddingAll: 0,
                    borderRadiusAll: 16,
                    clipBehavior: Clip.hardEdge,
                    child: Image(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          estateSingleEstateController.property.coverImage!),
                    ),
                  ),
                  FxSpacing.height(16),
                  FutureBuilder<AgentModel>(
                      future: Provider.of<AgentProvider>(context, listen: false)
                          .getAgent(widget.property.ownerId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const AgentShimmer();
                        }
                        return FxCard(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AgentProfile(snapshot.data!)));
                          },
                          paddingAll: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FxContainer(
                                paddingAll: 0,
                                borderRadiusAll: 8,
                                clipBehavior: Clip.hardEdge,
                                child: Image(
                                  height: 52,
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      snapshot.data!.profilePic!),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FxText.bodyMedium(
                                    snapshot.data!.agentName!,
                                    fontWeight: 700,
                                  ),
                                  FxSpacing.height(8),
                                  FxText.bodySmall(
                                    'View Agent Profile',
                                    xMuted: true,
                                  ),
                                ],
                              ),
                              FxSpacing.width(60),
                              Icon(
                                Icons.chevron_right_sharp,
                                color: theme.colorScheme.onBackground,
                              ),
                            ],
                          ),
                        );
                      }),
                  FxSpacing.height(16),
                  FxContainer(
                    paddingAll: 16,
                    borderRadiusAll: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FxText.bodyLarge(
                              estateSingleEstateController.property.name!,
                              fontWeight: 700,
                            ),
                            FxText.bodyMedium(
                              'KES ' +
                                  estateSingleEstateController.property.price!,
                              fontWeight: 600,
                              color: customTheme.estateSecondary,
                            ),
                          ],
                        ),
                        FxSpacing.height(8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color:
                                  theme.colorScheme.onBackground.withAlpha(180),
                            ),
                            FxSpacing.width(4),
                            FxText.bodySmall(
                              estateSingleEstateController.property.address!,
                              xMuted: true,
                            ),
                          ],
                        ),
                        FxSpacing.height(8),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.king_bed,
                                    size: 16,
                                    color: FxAppTheme
                                        .theme.colorScheme.onBackground
                                        .withAlpha(180),
                                  ),
                                  FxSpacing.width(4),
                                  FxText.bodySmall(
                                    estateSingleEstateController
                                            .property.ammenities!.beds! +
                                        ' Bedrooms',
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
                                    color: FxAppTheme
                                        .theme.colorScheme.onBackground
                                        .withAlpha(180),
                                  ),
                                  FxSpacing.width(4),
                                  FxText.bodySmall(
                                    estateSingleEstateController
                                            .property.ammenities!.bathrooms! +
                                        ' Bathrooms',
                                    xMuted: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        FxSpacing.height(8),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.square_foot,
                                    size: 16,
                                    color: FxAppTheme
                                        .theme.colorScheme.onBackground
                                        .withAlpha(180),
                                  ),
                                  FxSpacing.width(4),
                                  FxText.bodySmall(
                                    estateSingleEstateController
                                            .property.ammenities!.floors! +
                                        ' Floors',
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
                                    color: FxAppTheme
                                        .theme.colorScheme.onBackground
                                        .withAlpha(180),
                                  ),
                                  FxSpacing.width(4),
                                  FxText.bodySmall(
                                    estateSingleEstateController
                                        .property.ammenities!.area!,
                                    xMuted: true,
                                    height: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        FxSpacing.height(20),
                        FxText.bodyMedium(
                          'Description',
                          fontWeight: 700,
                        ),
                        FxSpacing.height(8),
                        ReadMoreText(
                          estateSingleEstateController.property.description!,
                          trimLines: 10,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          style: FxTextStyle.bodyMedium(
                            color: theme.colorScheme.onBackground,
                            xMuted: true,
                            height: 1.5,
                          ),
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          moreStyle: FxTextStyle.bodyMedium(
                            color: customTheme.estateSecondary,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FxText.bodyLarge("Photos", fontWeight: 600, letterSpacing: 0),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 150,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: List.generate(
                                widget.property.images!.length,
                                (i) => Container(
                                      margin: const EdgeInsets.only(right: 15),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: cachedImage(
                                            widget.property.images![i],
                                            fit: BoxFit.cover),
                                      ),
                                    )))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FxText.bodyLarge("Location",
                      fontWeight: 600, letterSpacing: 0),
                  const SizedBox(
                    height: 5,
                  ),
                  PropertyLocation(
                    property: widget.property,
                  )
                ],
              ),
            ),
            FxSpacing.height(16),
            FxButton.block(
              onPressed: () {
                Get.to(() => CheckOutScreen(
                      property: estateSingleEstateController.property,
                      user: Provider.of<AuthProvider>(context, listen: false)
                          .user!,
                    ));
              },
              child: FxText.bodyMedium(
                'Request booking',
                color: customTheme.estateOnPrimary,
                fontWeight: 700,
              ),
              backgroundColor: customTheme.estatePrimary,
              borderRadiusAll: 12,
              elevation: 0,
            ),
            FxSpacing.height(16),
          ],
        ),
      );
    }
  }
}
