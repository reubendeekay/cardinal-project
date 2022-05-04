import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/models/agent_model.dart';
import 'package:cardinal/models/property_model.dart';
import 'package:cardinal/providers/agent_provider.dart';
import 'package:cardinal/screens/home/widgets/search_property_card.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';

class AllAgentProperies extends StatefulWidget {
  const AllAgentProperies({Key? key, this.agent}) : super(key: key);
  final AgentModel? agent;

  @override
  State<AllAgentProperies> createState() => _AllAgentProperiesState();
}

class _AllAgentProperiesState extends State<AllAgentProperies> {
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
        title: FxText.titleMedium(widget.agent!.agentName! + " Listings",
            fontWeight: 600),
      ),
      body: FutureBuilder<List<PropertyModel>>(
          future: Provider.of<AgentProvider>(context, listen: false)
              .getAgentProperties(widget.agent!.userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingEffect.getSearchLoadingScreen(context);
            }
            if (snapshot.hasError) {
              return Center(
                child: FxText.bodySmall(
                    "Something went wrong, please try again later",
                    color: theme.colorScheme.onBackground),
              );
            }

            if (snapshot.data!.isEmpty) {
              return Center(
                child: FxText.bodySmall("No properties found",
                    color: theme.colorScheme.onBackground),
              );
            }

            return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: List.generate(
                    snapshot.data!.length,
                    (index) => SearchPropertyCard(
                          property: snapshot.data![index],
                        )));
          }),
    );
  }
}
