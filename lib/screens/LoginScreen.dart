import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/Login/LoginForm.dart';
import 'package:flutter_application_1/widgets/Login/LoginHeader.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [LoginHeader(), SizedBox(height: 40), LoginForm()],
          ),
        ),
      ),
    );
  }
}
