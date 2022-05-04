import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/screens/property_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchPropertyCard extends StatefulWidget {
  final PropertyModel property;

  const SearchPropertyCard({Key? key, required this.property})
      : super(key: key);

  @override
  _SearchPropertyCardState createState() => _SearchPropertyCardState();
}

class _SearchPropertyCardState extends State<SearchPropertyCard> {
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) =>
                    FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                pageBuilder: (_, __, ___) => PropertyDetailsScreen(
                      widget.property,
                    )));
      },
      child: FxContainer(
        paddingAll: 0,
        margin: const EdgeInsets.only(bottom: 10),
        borderRadiusAll: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                child: Image(
                  image:
                      CachedNetworkImageProvider(widget.property.coverImage!),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                )),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FxText.titleMedium(widget.property.name!,
                          fontWeight: 600),
                      FxText.titleMedium("KES " + widget.property.price!,
                          fontWeight: 600),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  MdiIcons.mapMarker,
                                  color: theme.colorScheme.onBackground,
                                  size: 14,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(left: 2),
                                    child: FxText.bodySmall(
                                        widget.property.address!,
                                        fontWeight: 500)),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: <Widget>[
                                  Icon(MdiIcons.star,
                                      color: theme.colorScheme.onBackground,
                                      size: 14),
                                  Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    child: FxText.bodySmall("4.5 Ratings",
                                        fontWeight: 500),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                      transitionsBuilder: (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) =>
                                          FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          ),
                                      pageBuilder: (_, __, ___) =>
                                          PropertyDetailsScreen(
                                              widget.property)));
                            },
                            child: FxText.bodySmall("BOOK NOW",
                                fontWeight: 600,
                                color: theme.colorScheme.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
