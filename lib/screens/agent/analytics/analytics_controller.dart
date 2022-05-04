import 'package:cardinal/screens/agent/analytics/coin.dart';
import 'package:flutx/flutx.dart';

class AnalyticsController extends FxController {
  List<Coin> coins = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    coins = getCoins();
    update();
  }

  @override
  String getTag() {
    return "portfolio_controller";
  }
}
