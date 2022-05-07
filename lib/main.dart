import 'package:cardinal/helpers/loading_effect.dart';
import 'package:cardinal/providers/agent_provider.dart';
import 'package:cardinal/providers/payment_provider.dart';
import 'package:cardinal/providers/search_provider.dart.dart';
import 'package:cardinal/firebase_options.dart';
import 'package:cardinal/providers/auth_provider.dart';
import 'package:cardinal/providers/chat_provider.dart';
import 'package:cardinal/providers/location_provider.dart';
import 'package:cardinal/providers/property_provider.dart';
import 'package:cardinal/screens/auth_screen/login_screen.dart';
import 'package:cardinal/screens/main_page.dart';
import 'package:cardinal/screens/splash_screen.dart';
import 'package:cardinal/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ErrorWidget.builder = (FlutterErrorDetails details) => GlobalErroe();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => LocationProvider()),
        ChangeNotifierProvider(create: (ctx) => SearchProvider()),
        ChangeNotifierProvider(create: (ctx) => PropertyProvider()),
        ChangeNotifierProvider(create: (ctx) => ChatProvider()),
        ChangeNotifierProvider(create: (ctx) => AgentProvider()),
        ChangeNotifierProvider(create: (ctx) => PaymentProvider()),
      ],
      child: GetMaterialApp(
        title: 'Cardinal Realty',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.estateTheme,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const MainPage();
              } else {
                return const EstateSplashScreen();
              }
            }),
      ),
    );
  }
}

class GlobalErroe extends StatefulWidget {
  const GlobalErroe({Key? key}) : super(key: key);

  @override
  State<GlobalErroe> createState() => _GlobalErroeState();
}

class _GlobalErroeState extends State<GlobalErroe> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      Get.offAll(() => MainPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingEffect.getSearchLoadingScreen(context);
  }
}
