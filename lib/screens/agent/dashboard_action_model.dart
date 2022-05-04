import 'package:cardinal/screens/agent/analytics/analytics_screen.dart';
import 'package:cardinal/screens/agent/edit_agent_screen.dart';
import 'package:cardinal/screens/agent/post_property_screen.dart';
import 'package:cardinal/screens/agent/purchases_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class DashboardActionModel {
  String name;
  Function? onTap;
  IconData icon;

  DashboardActionModel({required this.name, required this.icon, this.onTap});
}

List<DashboardActionModel> getAgentActions() {
  return [
    DashboardActionModel(
        name: 'Post',
        icon: Icons.add,
        onTap: () {
          Get.to(() => const PostPropertyScreen());
        }),
    DashboardActionModel(
        name: 'Purchases',
        icon: Icons.sell_outlined,
        onTap: () {
          Get.to(() => const PurchasesScreen());
        }),
    DashboardActionModel(
        name: 'Analytics',
        icon: Icons.bar_chart_outlined,
        onTap: () {
          Get.to(() => const AnalyticsScreen());
        }),
    DashboardActionModel(
        name: 'Profile',
        icon: Icons.person_outline,
        onTap: () {
          Get.to(() => const EditAgentScreen());
        }),
  ];
}
