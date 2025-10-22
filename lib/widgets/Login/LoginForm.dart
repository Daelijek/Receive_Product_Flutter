import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/Login/LoginButton.dart';
import 'package:flutter_application_1/widgets/Login/LoginInput.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;
    form.save();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Enter your email' : null,
            onSaved: (v) => _email = v ?? '',
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) => (v == null || v.length < 6)
                ? 'Password must be 6+ chars'
                : null,
            onSaved: (v) => _password = v ?? '',
          ),
          const SizedBox(height: 24),
          LoginButton(formKey: _formKey),
        ],
      ),
    );
  }
}
