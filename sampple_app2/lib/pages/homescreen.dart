import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sampple_app2/pages/details.dart';
import 'package:sampple_app2/pages/form.dart';
import 'package:sampple_app2/pages/messages.dart';
import 'package:sampple_app2/services/auth_service.dart';
import 'package:sampple_app2/services/navigation_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DetailsScreen(),
    MyForm(),
    MessagesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        title: const Text("EasyShop"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authService.logOut();
              if (result) {
                _navigationService.pushReplacementNamed("/login");
              }
            },
            color: Colors.black,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}