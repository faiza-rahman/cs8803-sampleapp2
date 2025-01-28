import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sampple_app2/services/auth_service.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GetIt getIt = GetIt.instance;
    final AuthService authService = getIt.get<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['to'] == authService.user?.email;
          }).toList();

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index].data() as Map<String, dynamic>;
              return ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, color: Colors.grey.shade300),
                ),
                title: Text(message['text']),
                subtitle: Text('From: ${message['from']}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewMessageDialog(context, authService);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNewMessageDialog(BuildContext context, AuthService authService) {
    final _toController = TextEditingController();
    final _textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Message'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _toController,
                decoration: const InputDecoration(labelText: 'To'),
              ),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Text'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final to = _toController.text;
                final text = _textController.text;
                final from = authService.userEmail;

                if (to.isNotEmpty && text.isNotEmpty && from != null) {
                  await FirebaseFirestore.instance.collection('messages').add({
                    'to': to,
                    'from': from,
                    'text': text,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}