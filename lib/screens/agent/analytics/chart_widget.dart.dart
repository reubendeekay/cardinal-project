import 'package:cardinal/screens/agent/analytics/coin.dart';
import 'package:cardinal/screens/agent/analytics/single_coin_controller.dart';
import 'package:cardinal/theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SingleCoinScreen extends StatefulWidget {
  final Coin coin;

  const SingleCoinScreen({Key? key, required this.coin}) : super(key: key);

  @override
  _SingleCoinScreenState createState() => _SingleCoinScreenState();
}

class _SingleCoinScreenState extends State<SingleCoinScreen> {
  late ThemeData theme;
  late SingleCoinController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.estateTheme;
    controller = FxControllerStore.putOrFind(SingleCoinController(widget.coin));
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<SingleCoinController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Padding(
              padding: FxSpacing.nTop(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxSpacing.height(20),
                        intervals(),
                        FxSpacing.height(40),
                        coinChart(),
                        FxSpacing.height(40),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }

  Widget coinChart() {
    return SizedBox(
      height: 240,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: EdgeInsets.zero,
        primaryXAxis: NumericAxis(
            isVisible: false,
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift),
        primaryYAxis: NumericAxis(
            isVisible: true,
            interval: 200,
            axisLine: const AxisLine(width: 0),
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift),
        series: controller.getCoinSeries(),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  Widget intervals() {
    List<Widget> list = [];
    for (int i = 0; i < controller.intervals.length; i++) {
      list.add(FxContainer.rounded(
        onTap: () {
          controller.changeInterval(i);
        },
        paddingAll: 12,
        color: controller.selected == i
            ? theme.colorScheme.primary
            : theme.scaffoldBackgroundColor,
        bordered: true,
        border: Border.all(
            color: controller.selected == i
                ? theme.colorScheme.primary
                : theme.dividerColor),
        child: Center(
            child: FxText.bodySmall(controller.intervals[i],
                fontWeight: 600,
                color: controller.selected == i
                    ? theme.colorScheme.onPrimary
                    : null)),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: list,
    );
  }
}
