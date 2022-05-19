import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({Key? key}) : super(key: key);

  @override
  _AccountSettingScreenState createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  bool _passwordVisible = false;
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
    final user = Provider.of<AuthProvider>(context, listen: false).user;
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
          title: FxText.titleMedium("User Profile", fontWeight: 600),
        ),
        body: ListView(
          padding: FxSpacing.nTop(20),
          children: <Widget>[
            FxText.bodyLarge("Personal information",
                fontWeight: 600, letterSpacing: 0),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                style: FxTextStyle.titleSmall(
                    letterSpacing: 0,
                    color: theme.colorScheme.onBackground,
                    fontWeight: 500),
                initialValue: user!.fullName!,
                decoration: InputDecoration(
                  labelText: "Full name",
                  labelStyle: FxTextStyle.titleSmall(
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
                    MdiIcons.emailOutline,
                    size: 22,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      initialValue: user.email!,
                      style: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: FxTextStyle.titleSmall(
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
                          MdiIcons.emailOutline,
                          size: 22,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      initialValue: user.phoneNumber!,
                      style: FxTextStyle.titleSmall(
                          letterSpacing: 0,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      decoration: InputDecoration(
                        labelText: "Number",
                        labelStyle: FxTextStyle.titleSmall(
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
                          MdiIcons.phoneOutline,
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
              margin: const EdgeInsets.only(top: 24),
              child: FxText.bodyLarge("Change Password",
                  fontWeight: 600, letterSpacing: 0),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                style: FxTextStyle.titleSmall(
                    letterSpacing: 0,
                    color: theme.colorScheme.onBackground,
                    fontWeight: 500),
                decoration: InputDecoration(
                  labelText: "Old Password",
                  labelStyle: FxTextStyle.titleSmall(
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
                  prefixIcon: const Icon(MdiIcons.lockOutline),
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible
                        ? MdiIcons.eyeOutline
                        : MdiIcons.eyeOffOutline),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                textCapitalization: TextCapitalization.sentences,
                obscureText: _passwordVisible,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: TextFormField(
                style: FxTextStyle.titleSmall(
                    letterSpacing: 0,
                    color: theme.colorScheme.onBackground,
                    fontWeight: 500),
                decoration: InputDecoration(
                  labelText: " Password",
                  labelStyle: FxTextStyle.titleSmall(
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
                  prefixIcon: const Icon(MdiIcons.lockOutline),
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible
                        ? MdiIcons.eyeOutline
                        : MdiIcons.eyeOffOutline),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                textCapitalization: TextCapitalization.sentences,
                obscureText: _passwordVisible,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: Center(
                child: Container(
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: FxText.bodyMedium("SAVE",
                        fontWeight: 600, color: theme.colorScheme.onPrimary),
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
}
