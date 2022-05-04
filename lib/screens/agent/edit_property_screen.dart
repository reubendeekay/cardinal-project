import 'dart:io';

import 'package:cardinal/helpers/add_on_map.dart';
import 'package:cardinal/helpers/my_loader.dart';
import 'package:cardinal/models/ammenities_model.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/providers/property_provider.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:provider/provider.dart';

class EditPropertyScreen extends StatefulWidget {
  const EditPropertyScreen({Key? key, required this.property})
      : super(key: key);
  final PropertyModel property;

  @override
  _EditPropertyScreenState createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  LatLng? propertyLocation;
  File? coverImage;
  List<File> imageFiles = [];
  List<Media> mediaList = [];
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  String? ownerId;
  String? type;
  String? name;
  String? description;
  String? address;
  String? price;
  String? beds;
  String? baths;
  String? area;
  String? floors;

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
          title: FxText.titleMedium("Edit a Listing", fontWeight: 600),
        ),
        body: ListView(
          padding: FxSpacing.nTop(20),
          children: <Widget>[
            FxText.bodyLarge("Property information",
                fontWeight: 600, letterSpacing: 0),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter a name";
                        }
                        return null;
                      },
                      initialValue: widget.property.name,
                      style: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      decoration: InputDecoration(
                        labelText: "Property Name",
                        hintStyle: FxTextStyle.titleSmall(
                            letterSpacing: 0,
                            color: theme.colorScheme.onBackground,
                            fontWeight: 500),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: customTheme.card,
                        prefixIcon: const Icon(
                          MdiIcons.account,
                          size: 22,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          description = val;
                        });
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter the prperty description";
                        }
                        return null;
                      },
                      initialValue: widget.property.description,
                      maxLength: null,
                      maxLines: null,
                      style: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      decoration: InputDecoration(
                        labelText: "Description",
                        hintStyle: FxTextStyle.titleSmall(
                            letterSpacing: 0,
                            color: theme.colorScheme.onBackground,
                            fontWeight: 500),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: customTheme.card,
                        prefixIcon: const Icon(
                          MdiIcons.details,
                          size: 22,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          type = val;
                        });
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter a property category";
                        }
                        return null;
                      },
                      initialValue: widget.property.type,
                      style: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      decoration: InputDecoration(
                        labelText: "Property Category",
                        hintStyle: FxTextStyle.titleSmall(
                            letterSpacing: 0,
                            color: theme.colorScheme.onBackground,
                            fontWeight: 500),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: customTheme.card,
                        prefixIcon: const Icon(
                          MdiIcons.officeBuilding,
                          size: 22,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          price = val;
                        });
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter the price";
                        }
                        return null;
                      },
                      initialValue: widget.property.price,
                      style: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      decoration: InputDecoration(
                        labelText: "Price",
                        hintStyle: FxTextStyle.titleSmall(
                            letterSpacing: 0,
                            color: theme.colorScheme.onBackground,
                            fontWeight: 500),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: customTheme.card,
                        prefixIcon: const Icon(
                          MdiIcons.cash,
                          size: 22,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24, bottom: 0),
              child: FxText.bodyLarge("Ammenities",
                  fontWeight: 600, letterSpacing: 0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        beds = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter the number of bedrooms";
                      }
                      return null;
                    },
                    initialValue:
                        widget.property.ammenities!.beds! + ' Bedrooms',
                    style: FxTextStyle.titleSmall(
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      labelText: "Bedrooms",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: customTheme.card,
                      prefixIcon: const Icon(
                        MdiIcons.bedOutline,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        baths = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter the number of bathrooms";
                      }
                      return null;
                    },
                    initialValue:
                        widget.property.ammenities!.bathrooms! + ' Bathrooms',
                    style: FxTextStyle.titleSmall(
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      labelText: "Bathrooms",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: customTheme.card,
                      prefixIcon: const Icon(
                        MdiIcons.bathtubOutline,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        floors = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter the number of floors";
                      }
                      return null;
                    },
                    initialValue:
                        widget.property.ammenities!.floors! + ' Floors',
                    style: FxTextStyle.titleSmall(
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      labelText: "Floors",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: customTheme.card,
                      prefixIcon: const Icon(
                        MdiIcons.floorPlan,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        area = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter the area";
                      }
                      return null;
                    },
                    initialValue: widget.property.ammenities!.area,
                    style: FxTextStyle.titleSmall(
                        letterSpacing: 0,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      labelText: "Area",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: customTheme.card,
                      prefixIcon: const Icon(
                        MdiIcons.ruler,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child:
                  FxText.bodyLarge("More", fontWeight: 600, letterSpacing: 0),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    address = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter the property address";
                  }
                  return null;
                },
                initialValue: widget.property.address,
                style: FxTextStyle.titleSmall(
                    letterSpacing: 0,
                    color: theme.colorScheme.onBackground,
                    fontWeight: 500),
                decoration: InputDecoration(
                  labelText: "Property Address",
                  hintStyle: FxTextStyle.titleSmall(
                      letterSpacing: 0,
                      color: theme.colorScheme.onBackground,
                      fontWeight: 500),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: customTheme.card,
                  prefixIcon: const Icon(MdiIcons.locationEnter),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => AddOnMap(
                      onChanged: (val) {
                        setState(() {
                          propertyLocation = val;
                        });
                      },
                    ));
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundColor:
                              theme.colorScheme.primary.withAlpha(28),
                          child: const Icon(Icons.location_on_outlined)),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Location on Map'),
                      const Spacer(),
                      Icon(
                        Icons.check_circle,
                        color: propertyLocation == null
                            ? theme.colorScheme.primary.withAlpha(28)
                            : Colors.green,
                      )
                    ],
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24, bottom: 0),
              child:
                  FxText.bodyLarge("Photos", fontWeight: 600, letterSpacing: 0),
            ),
            InkWell(
              onTap: () {
                openImagePicker(context, true);
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundColor:
                              theme.colorScheme.primary.withAlpha(28),
                          child: const Icon(Icons.camera_alt_outlined)),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Cover Image'),
                      const Spacer(),
                      Icon(
                        Icons.check_circle,
                        color: coverImage == null
                            ? theme.colorScheme.primary.withAlpha(28)
                            : Colors.green,
                      )
                    ],
                  )),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      openImagePicker(context, false);
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        color: theme.colorScheme.primary.withAlpha(28),
                        child: const Text(
                          'Add\nPhotos',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        )),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ...List.generate(
                      imageFiles.length,
                      (index) => Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: Image.file(
                                  imageFiles[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  top: -5,
                                  right: -5,
                                  child: GestureDetector(
                                    onTap: () {
                                      imageFiles.remove(imageFiles[index]);
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.cancel,
                                        color: Colors.pinkAccent),
                                  ))
                            ],
                          ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: Center(
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(28),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Provider.of<PropertyProvider>(context,
                              listen: false)
                          .deleteProperty(widget.property.id!);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Property Deleted'),
                        duration: Duration(seconds: 2),
                      ));
                    },
                    child: FxText.bodyMedium("Delete Property",
                        fontWeight: 600, color: theme.colorScheme.onPrimary),
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(FxSpacing.xy(16, 0))),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: Center(
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(28),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: coverImage == null ||
                            imageFiles.isEmpty ||
                            propertyLocation == null
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              final property = PropertyModel(
                                address: address ?? widget.property.address,
                                coverFile: coverImage,
                                description:
                                    description ?? widget.property.description,
                                location: propertyLocation == null
                                    ? widget.property.location
                                    : GeoPoint(propertyLocation!.latitude,
                                        propertyLocation!.longitude),
                                imageFiles: imageFiles,
                                price: price != null
                                    ? price!.replaceAll('KES', '').trim()
                                    : widget.property.price!.trim(),
                                name: name ?? widget.property.name,
                                type: type ?? widget.property.type,
                                ammenities: AmmenitiesModel(
                                    beds != null
                                        ? beds!
                                            .replaceAll('Bedrooms', '')
                                            .trim()
                                        : widget.property.ammenities!.beds,
                                    baths != null
                                        ? baths!
                                            .replaceAll('Bathrooms', '')
                                            .trim()
                                        : widget.property.ammenities!.bathrooms,
                                    floors != null
                                        ? floors!
                                            .replaceAll('Floors', '')
                                            .trim()
                                        : widget.property.ammenities!.floors,
                                    area ?? widget.property.ammenities!.area!),
                                status: 'available',
                              );
                              setState(() {
                                isLoading = true;
                              });

                              await Provider.of<PropertyProvider>(context,
                                      listen: false)
                                  .editProperty(property);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Property Edited'),
                                duration: Duration(seconds: 2),
                              ));
                              setState(() {
                                isLoading = false;
                              });

                              Navigator.pop(context);
                            }
                          },
                    child: isLoading
                        ? const MyLoader()
                        : FxText.bodyMedium("Update Property",
                            fontWeight: 600,
                            color: theme.colorScheme.onPrimary),
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(FxSpacing.xy(16, 0))),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> openImagePicker(
    BuildContext context,
    bool isCover,
  ) async {
    // openCamera(onCapture: (image){
    //   setState(()=> mediaList = [image]);
    // });
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                maxChildSize: 0.95,
                minChildSize: 0.6,
                builder: (ctx, controller) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    color: Colors.white,
                    child: MediaPicker(
                      scrollController: controller,
                      mediaList: mediaList,
                      onPick: (selectedList) {
                        setState(() => mediaList = selectedList);

                        if (isCover) {
                          coverImage = mediaList.first.file;
                          mediaList.clear();
                        }

                        if (!isCover) {
                          for (var element in mediaList) {
                            imageFiles.add(element.file!);
                          }
                          mediaList.clear();
                        }

                        mediaList.clear();

                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                      mediaCount:
                          isCover ? MediaCount.single : MediaCount.multiple,
                      mediaType: MediaType.image,
                      decoration: PickerDecoration(
                        cancelIcon: const Icon(Icons.close),
                        albumTitleStyle: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontWeight: FontWeight.bold),
                        actionBarPosition: ActionBarPosition.top,
                        blurStrength: 2,
                        completeButtonStyle: const ButtonStyle(),
                        completeTextStyle:
                            TextStyle(color: Theme.of(context).iconTheme.color),
                        completeText: 'Select',
                      ),
                    )),
              ));
        });
  }
}
