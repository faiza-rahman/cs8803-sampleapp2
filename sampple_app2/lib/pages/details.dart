import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sampple_app2/services/auth_service.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  List<Map<String, dynamic>> _shoppingListItems = [];

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _fetchShoppingListItems();
  }

  Future<void> _fetchShoppingListItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('shoppinglist').where('userId', isEqualTo: _authService.userId)
        .get();
    final data = snapshot.docs.map((doc) {
      final docData = doc.data();
      return {
        'id': doc.id,
        'productName': docData['productName'] ?? 'No Name',
        'productDescription': docData['productDescription'] ?? 'No Description',
      };
    }).toList();
    setState(() {
      _shoppingListItems = data;
    });
  }

  Future<void> _deleteShoppingListItem(String id) async {
    await FirebaseFirestore.instance.collection('shoppinglist').doc(id).delete();
    _fetchShoppingListItems(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Container(
          padding: const EdgeInsets.all(4.0),
          child: _shoppingListItems.isEmpty
            ? const Center(
                child: Text(
                  'Your shopping list is empty!',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              )
            
          : ListView.builder(
            itemCount: _shoppingListItems.length,
            itemBuilder: (context, index) {
              final item = _shoppingListItems[index];
              return Card(
                elevation: 4.0, 
                shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.bookmark_added_rounded, color: Colors.deepPurple.shade300),
                    onPressed: () {},
                  ),
                  
                  title: Text(item['productName']),
                  subtitle: Text(item['productDescription']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      _deleteShoppingListItem(item['id']);
                    },
                  ),
                ),
              );
            },
          ),
      ),
    );
  }
}
