import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardinal/models/agent_model.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

class AgentAvatar extends StatelessWidget {
  const AgentAvatar({Key? key, required this.agent}) : super(key: key);
  final AgentModel agent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 15,
      ),
      child: Column(children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: CachedNetworkImageProvider(agent.profilePic!),
        ),
        FxSpacing.height(8),
        FxText.bodySmall(
          agent.agentName!.split(' ')[0],
        ),
      ]),
    );
  }
}
