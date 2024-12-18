import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Hàm đăng ký
  Future<String> signUpUser(
      {required String email,
      required String password,
      String role = "0"}) async {
    String res = "Error";
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final userModel = UserModel(
          uid: _firebaseAuth.currentUser!.uid,
          email: email,
          password: password,
          role: role,
          createDate: DateTime.now());

      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .set(userModel.toMap());

      res = "Success";
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  //Hàm đăng nhập
  Future<String> signInUser(
      {required String email, required String password}) async {
    String res = "Error";
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "Success";
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  //Hàm quên mật khẩu
  Future<String> forgotUser({required String email}) async {
    String res = "Error";
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      res = "Success";
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  //Hàm đăng xuất
  Future<String> signOutUser() async {
    try {
      await _firebaseAuth.signOut();
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  //Hàm thay đổi mật khẩu
  Future<String> changePasswordUser(String newPassword) async {
    try {
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .set({
        'password': newPassword,
        'lastUpdate': DateTime.now().toIso8601String()
      }, SetOptions(merge: true));
      await _firebaseAuth.signOut();
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }
}
