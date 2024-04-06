import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dart_mysql/dart_mysql.dart';

import '../global/toast.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final String baseUrl = 'http://localhost:8086/api'; // Replace with your backend IP address

  Future<bool> isEmailExistsInDatabase(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/customers/isEmailExists'),
      body: json.encode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final bool exists = json.decode(response.body);
      return exists;
    } else {
      throw Exception('Failed to check email existence');
    }
  }

  Future<User?> signupWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email is already in use') {
        showToast(message: 'Email already in use');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signinWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password');
      } else {
        showToast(message: ': ${e.code}');
      }
    }
    return null;
  }
}
