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
  bool obscureText = true; // State variable to manage password visibility
  String? email, password;
  String? errorMessage; // State variable to manage error message

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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0), // Add padding to the top
                  child: Align(
                    alignment: Alignment.centerLeft, // Align text to the left
                    child: Text(
                      'EasyShop',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
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
                            email = value;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureText ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || value.length < 6) {
                              setState(() {
                                errorMessage = 'Incorrect email or password';
                              });
                              return 'Enter a valid password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            password = value;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        if (errorMessage != null)
                          Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade300,
                          ),
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
                                setState(() {
                                  errorMessage = 'Incorrect email or password';
                                });
                                print('Login failed'); // Debug print
                              }
                            }
                          },
                          child: const Text('LOGIN', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                _navigationService.pushNamed('/register');
                              },
                              child: const Text('Signup'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

