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

  static const List<String> _titles = <String>[
    'Shopping List',
    'Add Item',
    'Messages',
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
        title: Text(_titles[_selectedIndex], style: const TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authService.logOut();
              if (result) {
                _navigationService.pushReplacementNamed("/login");
              }
            },
            color: Colors.white,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '', // Empty label
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple.shade300,
        onTap: _onItemTapped,
        showSelectedLabels: false, 
        showUnselectedLabels: false, 
        iconSize: 30.0,
      ),
    );
  }
}