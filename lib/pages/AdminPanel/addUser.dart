import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUserUI extends StatefulWidget {
  const AddUserUI({Key? key}) : super(key: key);

  @override
  _AddUserUIState createState() => _AddUserUIState();
}

class _AddUserUIState extends State<AddUserUI> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _photoURLController = TextEditingController();

  // Function to add a user to Firestore
  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final uid = _uidController.text.trim();
        final email = _emailController.text.trim();
        final username = _usernameController.text.trim();
        final photoURL = _photoURLController.text.trim();

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': email,
          'username': username.isNotEmpty ? username : null,
          'photoURL': photoURL.isNotEmpty ? photoURL : null,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully!')),
        );

        // Clear input fields
        _uidController.clear();
        _emailController.clear();
        _usernameController.clear();
        _photoURLController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding user: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _uidController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _photoURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _uidController,
                decoration: const InputDecoration(
                  labelText: 'UID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a UID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _photoURLController,
                decoration: const InputDecoration(
                  labelText: 'Photo URL (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addUser,
                child: const Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
