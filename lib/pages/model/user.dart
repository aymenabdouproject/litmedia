import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  final String uid;
  final String email;
  final String? username;
  final String? photoURL;

  CustomUser({
    required this.uid,
    required this.email,
    this.username,
    this.photoURL,
  });

  // Factory constructor to convert a Firebase User to a CustomUser
  factory CustomUser.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CustomUser(
      uid: document.id,
      email: data["email"],
      username: data["username"],
      photoURL: data["photoURL"],
    );
  }
}
