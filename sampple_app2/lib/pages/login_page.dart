import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sampple_app2/services/auth_service.dart';
import 'package:sampple_app2/services/navigation_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;

  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final bool obscureText = true;
  String? email, password;

  late AuthService _authService;
  late NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            children: [
              const Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value != null && _emailRegExp.hasMatch(value)) {
                    return null;
                  }
                  return 'Enter a valid email';
                },
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                }
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: obscureText,
                validator: (value) {
                  if (value != null && value.length >= 6) {
                    return null;
                  }
                  return 'Enter a valid password';
                },
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                }
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_loginFormKey.currentState?.validate() ?? false) {
                    _loginFormKey.currentState?.save();
                    print('Email: $email, Password: $password'); // Debug print
                    bool result = await _authService.login(email!, password!);
                    print('Login result: $result'); // Debug print

                    if (result) {
                      print('Navigating to home'); // Debug print
                      _navigationService.pushReplacementNamed('/home');
                    } else {
                      print('Login failed'); // Debug print
                    }
                  }
                },
                child: const Text('Login'),
              ),
              _createAnAccountLink(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _createAnAccountLink() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Don\'t have an account?'),
      TextButton(
        onPressed: () {},
        child: const Text('Sign Up'),
      ),
    ],
  );
}