import 'package:cardinal/models/user_model.dart';
import 'package:cardinal/screens/payment/shipping_address.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

class Tab {
  String name;
  IconData iconData;

  Tab(this.name, this.iconData);
}

class CheckOutController extends FxController {
  PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  int numPages = 3;
  int paymentMethodSelected = 1;
  UserModel? contactSelected;
  CheckOutController(this.user);
  final UserModel user;

  List<Tab> tabs = [];

  @override
  initState() {
    super.initState();
    currentPage = 0;
    contactSelected = user;
    tabs = [
      Tab('Contact', Icons.person_outline),
      // Tab('Payment', Icons.payment),
      Tab('Placed', Icons.check_circle_outline),
    ];
  }

  void goBack() {
    Navigator.pop(context);
  }

  void selectPaymentMethod(int method) {
    paymentMethodSelected = method;
    update();
  }

  void selectContactDetails(UserModel user) {
    contactSelected = user;
    update();
  }

  nextPage() async {
    if (currentPage == numPages) {
      /*   Navigator.push(
          context, MaterialPageRoute(builder: (context) => FullApp()));*/
    } else {
      await pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  previousPage() async {
    if (currentPage == 0) {
      /*   Navigator.push(
          context, MaterialPageRoute(builder: (context) => FullApp()));*/
    } else {
      await pageController.animateToPage(
        currentPage - 1,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    }
  }

  onPageChanged(int page, {bool fromUser = false}) async {
    if (!fromUser) currentPage = page;
    update();
    if (fromUser) {
      await pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    if (pageController.hasClients) pageController.dispose();
    super.dispose();
  }

  @override
  String getTag() {
    return "checkout_controller";
  }
}
