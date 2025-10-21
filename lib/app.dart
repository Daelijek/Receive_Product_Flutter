import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/HomeScreen.dart';
import 'package:flutter_application_1/screens/LoginScreen.dart';
import 'package:flutter_application_1/screens/OrderScreen.dart';
import 'package:flutter_application_1/screens/ProfileScreen.dart';
import 'package:flutter_application_1/screens/OrderHistoryScreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/orders': (context) => OrderScreen(),
        '/profile': (context) => ProfileScreen(),
        '/order-history': (context) => OrderHistoryScreen(),
      },
    );
  }
}
