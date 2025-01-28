import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<Map<String, dynamic>> _shoppingListItems = [];

  @override
  void initState() {
    super.initState();
    _fetchShoppingListItems();
  }

  Future<void> _fetchShoppingListItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('shoppinglist').get();
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
    _fetchShoppingListItems(); // Refresh the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(4.0),
        child: ListView.builder(
          itemCount: _shoppingListItems.length,
          itemBuilder: (context, index) {
            final item = _shoppingListItems[index];
            return ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, color: Colors.grey.shade300),
              ),
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
            );
          },
        ),
      ),
    );
  }
}
