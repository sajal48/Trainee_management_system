import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/controller/app_controller.dart';
import 'package:front/controller/auth_controller.dart';
import 'package:front/models/user_type.dart';
import 'package:front/pages/layout.dart';
import 'package:front/pages/signup_page.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'pages/login_page.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  LocalStorage store = LocalStorage('ems');
  await store.ready;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthController(store)),
      ChangeNotifierProvider(create: (context) => AppController(store)),
    ],
    child: MyApp(), // Don't need to wrap with MaterialApp here
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<AuthController>().checkLoggedInStatus();
    return MaterialApp(
      navigatorKey: navigatorKey,
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/login': (context) => LoginPage(),
        '/register/admin': (context) => SignupPage(userType: UserType.admin),
        '/register/trainer': (context) =>
            SignupPage(userType: UserType.trainer),
        '/register/trainee': (context) =>
            SignupPage(userType: UserType.trainee),
        '/home': (context) => Layout(),
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        auth.checkLoggedInStatus();

        Future.delayed(Duration.zero, () {
          if (auth.isLoggedIn) {
            Navigator.pushReplacementNamed(context, "/home");
          } else {
            Navigator.pushReplacementNamed(context, "/login");
          }
        });

        return Scaffold();
      },
    );
  }
}
