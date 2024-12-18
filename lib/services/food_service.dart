import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/food_model.dart';

class FoodService {
  static FoodService? _instance;
  static void overrideService(FoodService service) {
    _instance = service;
  }

  static FoodService get instance {
    // Đảm bảo Firebase đã được khởi tạo trước khi gọi FoodService
    // Firebase.initializeApp();
    return _instance ?? FoodService();
  }

  final FirebaseFirestore firestore;
// Khởi tạo mặc định khi không có mock
  FoodService({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> hasNetworkConnection() async {
    try {
      if (kIsWeb) {
        return true;
      } else {
        if (Platform.isAndroid) {
          // Thử phân giải tên miền "google.com"
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true; // Có mạng
          }
        }
        return false;
      }
    } on SocketException catch (_) {
      return false; // Không có mạng
    }
  }

  //Hàm thêm đồ ăn
  // c1
  Future<String?> addFood(String name, double price, String imageUrl) async {
    try {
      final docRef = firestore.collection('food').doc();
      final food = FoodModel(
          id: docRef.id, name: name, price: price, imageUrl: imageUrl);
      await docRef.set(food.toMap());
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }
  //c2
  // Future<String?> addFood(String name, double price, String imageUrl) async {
  //   try {
  //     final docRef = await firestore.collection('food').add(
  //         FoodModel(id: "", name: name, price: price, imageUrl: imageUrl)
  //             .toMap());
  //     await docRef.update({'id': docRef.id});
  //     return "Success";
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

  //Hàm lấy all dữ liệu đồ ăn
  //c1
  // Future<List<Map<String, dynamic>>> getAllFood() async {
  //   try {
  //     final data = await firestore.collection('food').get();
  //     QuerySnapshot querySnapshot = data;
  //     return querySnapshot.docs
  //         .map((e) => e.data() as Map<String, dynamic>)
  //         .toList();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //c2
  Future<List<Map<String, dynamic>>> getAllFood() async {
    try {
      // Kiểm tra kết nối mạng
      if (!await hasNetworkConnection()) {
        // throw Exception('Không có kết nối mạng. Vui lòng kiểm tra lại.');
        return [];
      }
      final data = await firestore.collection('food').get();
      List<Map<String, dynamic>> foodList = [];
      for (var doc in data.docs) {
        foodList.add(doc.data());
      }
      return foodList;
    } catch (e) {
      // throw Exception('Đã xảy ra lỗi: $e');
      return [];
    }
  }

  //Hàm xoá đồ ăn
  Future<String?> delFood(String id) async {
    try {
      await firestore.collection('food').doc(id).delete();
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  //Hàm cập nhật sửa đồ ăn
  //c1
  Future<String?> updateFood(
      String id, String name, double price, String imageUrl) async {
    try {
      await firestore.collection('food').doc(id).set(
          {'name': name, 'price': price, 'imageUrl': imageUrl},
          SetOptions(merge: true));
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }
  //c2
  // Future<String?> updateFood(
  //     String id, String name, double price, String imageUrl) async {
  //   try {
  //     await firestore.collection('food').doc(id).update(
  //         FoodModel(id: id, name: name, price: price, imageUrl: imageUrl)
  //             .toMap());
  //     return "Success";
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }
}
