import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sampple_app2/services/auth_service.dart';
import 'package:sampple_app2/services/navigation_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;

  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final bool obscureText = true;
  String? name, email, password;

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
          key: _registerFormKey,
          child: Column(
            children: [
              const Text('Sign Up', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                }
              ),
              const SizedBox(height: 10),
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
                  if (_registerFormKey.currentState?.validate() ?? false) {
                    _registerFormKey.currentState?.save();
                    print('Email: $email, Password: $password'); // Debug print
                    bool result = await _authService.signup(email!, password!);
                    print('signup result: $result'); // Debug print

                    if (result) {
                      print('Navigating to home'); // Debug print
                      _navigationService.pushReplacementNamed('/home');
                    } else {
                      print('signup failed'); // Debug print
                    }
                  }
                },
                child: const Text('Sign Up'),
              ),
              _goBackToLogin(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _goBackToLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?'),
        TextButton(
          onPressed: () {
            _navigationService.pushNamed('/login');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }

}

