import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData {
  final String name;
  final String email;
  final String roll;
  final String semester;
  final String shift;
  final bool isAdmin;

  UserData({
    required this.name,
    required this.email,
    required this.roll,
    required this.semester,
    required this.shift,
    required this.isAdmin,
  });
}

class UserDataProvider extends ChangeNotifier {
   UserData? _userData;

  UserData? get userData => _userData;

  Future<void> fetchUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;

        _userData = UserData(
          name: data['name']??'',
          email: data['email']??'',
          roll: data['roll']??'',
          semester: data['semester']??'',
          shift: data['shift']??'',
          isAdmin: data['isadmin']??false,
        );

        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
