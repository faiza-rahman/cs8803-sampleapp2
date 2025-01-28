import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sampple_app2/services/auth_service.dart';
import 'package:sampple_app2/services/navigation_service.dart';
import 'package:sampple_app2/pages/details.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;

  final _productController = TextEditingController();
  final _productDesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  void dispose() {
    _productController.dispose();
    _productDesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Container(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                MyTextField(
                    myController: _productController,
                    fieldName: "Item Name",
                    myIcon: Icons.account_balance,
                    prefixIconColor: Colors.deepPurple.shade300),
                const SizedBox(height: 10.0),
                //Use to add space between Textfields
                MyTextField(
                    myController: _productDesController,
                    fieldName: "Item Store",
                    prefixIconColor: Colors.deepPurple.shade300),
                const SizedBox(height: 20.0),
                myBtn(context),
                
              ],
              
            ),
          ),
    );
  }

  //Function that returns OutlinedButton Widget also it pass data to Details Screen
  OutlinedButton myBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
      onPressed: () async {
        CollectionReference colRef = FirebaseFirestore.instance.collection("shoppinglist");
        await colRef.add({
          "userId": _authService.userId,
          "productName": _productController.text,
          "productDescription": _productDesController.text
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return DetailsScreen();
          }),
        );
      },
      child: Text(
        "Add Item".toUpperCase(),
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }
}

//Custom STateless WIdget Class that helps re-usability
// You can learn it in Tutorial (2.13) Custom Widget in Flutter
class MyTextField extends StatelessWidget {
  MyTextField({
    super.key,
    required this.fieldName,
    required this.myController,
    this.myIcon = Icons.verified_user_outlined,
    this.prefixIconColor = Colors.blueAccent,
  });

  final TextEditingController myController;
  String fieldName;
  final IconData myIcon;
  Color prefixIconColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      decoration: InputDecoration(
          labelText: fieldName,
          prefixIcon: Icon(myIcon, color: prefixIconColor),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple.shade300),
          ),
          labelStyle: const TextStyle(color: Colors.deepPurple)),
    );
  }
}