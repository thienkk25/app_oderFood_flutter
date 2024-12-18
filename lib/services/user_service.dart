import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:app_oderfood/services/authencation.dart';

class UserService {
  static UserService? _instance;

  static void overrideService(UserService service) {
    _instance = service;
  }

  static UserService get instance {
    // Đảm bảo Firebase đã được khởi tạo trước khi gọi UserService
    Firebase.initializeApp();
    return _instance ?? UserService();
  }

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  // Khởi tạo mặc định khi không có mock
  UserService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : auth = auth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance;
  Future<bool> hasNetworkConnection() async {
    try {
      if (kIsWeb) {
        return true;
      } else {
        if (Platform.isAndroid) {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        }
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<String?> getData(String req) async {
    try {
      final data =
          await firestore.collection("users").doc(auth.currentUser!.uid).get();
      if (data.exists) {
        return data.data()![req];
      }
    } catch (e) {
      return e.toString();
    }
    return "";
  }

  Stream<List> checkUserStatus() {
    return auth.authStateChanges().asyncMap((User? user) async {
      if (user != null) {
        String? role = await getData('role');
        return ['yes', role];
      }
      return ['no', 'null'];
    });
  }

  String checkSession() {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      return "Success";
    } else {
      return "";
    }
  }

  Future<List<Map<String, dynamic>>> getAllUser() async {
    try {
      if (!await hasNetworkConnection()) {
        return [];
      }
      final data = await firestore.collection('users').get();
      List<Map<String, dynamic>> usersList = [];
      for (var doc in data.docs) {
        usersList.add(doc.data());
      }
      return usersList;
    } catch (e) {
      return [];
    }
  }

  Future<String?> addUsers(String email, String password, String role) async {
    try {
      String? result = await AuthServices()
          .signUpUser(email: email, password: password, role: role);
      return result;
    } catch (e) {
      return e.toString();
    }
  }
}
