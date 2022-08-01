import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/login_screen.dart';
import 'widgets/menu_bar.dart';

// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() {
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(34, 157, 77, 1)));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primaryColor: const Color.fromRGBO(34, 157, 77, 1),
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        '/homescreen': (context) => const MenuBar(),
      },
    );
  }
}
