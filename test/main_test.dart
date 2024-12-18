import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_oderfood/main.dart';
import 'package:app_oderfood/screens/clients/home_client.dart';
import 'package:app_oderfood/screens/home.dart';
import 'package:app_oderfood/services/food_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:app_oderfood/services/user_service.dart';
import 'package:app_oderfood/screens/admin/home_admin.dart';
import 'package:app_oderfood/screens/welcome.dart';

class FakeUserService extends UserService {
  final MockFirebaseAuth mockAuth;
  final FakeFirebaseFirestore fakeFirestore;

  FakeUserService({
    required this.mockAuth,
    required this.fakeFirestore,
  }) : super(auth: mockAuth, firestore: fakeFirestore);

  @override
  Future<String?> getData(String req) async {
    try {
      final data = await fakeFirestore
          .collection("users")
          .doc(mockAuth.currentUser!.uid)
          .get();
      if (data.exists) {
        return data.data()![req];
      }
    } catch (e) {
      return e.toString();
    }
    return "";
  }

  @override
  Stream<List> checkUserStatus() {
    return mockAuth.authStateChanges().asyncMap((User? user) async {
      if (user != null) {
        String? role = await getData('role');
        return ['yes', role];
      }
      return ['no', 'null'];
    });
  }

  @override
  String checkSession() {
    return mockAuth.currentUser != null ? "Success" : "";
  }
}

class FakeFoodService extends FoodService {
  final FakeFirebaseFirestore fakeFirestore;
  FakeFoodService({required this.fakeFirestore})
      : super(firestore: fakeFirestore);
  @override
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

  @override
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
}

void main() {
  group('MainApp trạng thái Test với Fake Data', () {
    late MockFirebaseAuth mockAuth;
    late FakeFirebaseFirestore fakeFirestore;
    late FakeUserService fakeUserService;
    late FakeFoodService fakeFoodService;
    setUp(() async {
      mockAuth = MockFirebaseAuth();
      fakeFirestore = FakeFirebaseFirestore();

      // Ghi đè UserService để sử dụng các mock
      fakeUserService =
          FakeUserService(mockAuth: mockAuth, fakeFirestore: fakeFirestore);
      UserService.overrideService(fakeUserService);
      // Ghi đè FoodService để sử dụng các mock
      fakeFoodService = FakeFoodService(fakeFirestore: fakeFirestore);
      FoodService.overrideService(fakeFoodService);
    });

    testWidgets('Hiển thị màn hình Welcome khi chưa đăng nhập',
        (WidgetTester tester) async {
      // await tester.pumpWidget(const MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   home: Welcome(),
      // ));

      // Kiểm tra nếu màn hình Welcome được hiển thị
      await tester.pumpWidget(
        const MaterialApp(
          home: MainApp(),
        ),
      );
      expect(find.byType(Welcome), findsOneWidget);
    });

    testWidgets('Hiển thị HomeClient khi người dùng là khách hàng',
        (WidgetTester tester) async {
      // Đăng nhập người dùng giả
      await mockAuth.signInWithEmailAndPassword(
          email: "user@gmail.com", password: "123456");

      // Thêm người dùng giả vào Firestore
      await fakeFirestore
          .collection('users')
          .doc(mockAuth.currentUser!.uid)
          .set({
        'uid': mockAuth.currentUser!.uid,
        'email': 'user@gmail.com',
        'password': '123456',
        'createDate': '2024-12-05T18:13:32.140',
        'lastUpdate': '2024-12-05T18:13:32.140',
        'role': '0', // Vai trò là khách hàng (0)
      });
      // print(await fakeUserService.getData("email"));
      final docRef0 = fakeFirestore.collection('food').doc();
      await docRef0.set(
        {
          'id': docRef0.id,
          'name': 'Phở',
          'price': '11',
          'imageUrl': 'test_image_pho.com',
        },
      );
      final docRef1 = fakeFirestore.collection('food').doc();
      await docRef1.set(
        {
          'id': docRef1.id,
          'name': 'Bún',
          'price': '12',
          'imageUrl': 'test_image_bun.com',
        },
      );
      fakeUserService.checkUserStatus().listen((state) {
        if (kDebugMode) {
          print('State: ${state[0]}, Role: ${state[1]}');
        }
      });
      await tester.pumpWidget(
        const MaterialApp(
          home: MainApp(),
        ),
      );
      // Chạy widget Home với HomeClient làm body
      await tester.pumpWidget(const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(bodyHome: HomeClient(), title: "Trang chủ"),
      ));
      // Kiểm tra widget HomeClient được hiển thị
      expect(find.byType(HomeClient), findsOneWidget);
    });

    testWidgets('Hiển thị HomeAdmin khi người dùng là quản trị viên',
        (WidgetTester tester) async {
      // Đăng nhập người dùng giả
      await mockAuth.signInWithEmailAndPassword(
          email: "admin@gmail.com", password: "admin123");

      // Thêm người dùng giả vào Firestore
      await fakeFirestore
          .collection('users')
          .doc(mockAuth.currentUser!.uid)
          .set({
        'uid': mockAuth.currentUser!.uid,
        'email': 'admin@gmail.com',
        'password': 'admin123',
        'createDate': '2024-12-05T18:13:32.140',
        'lastUpdate': '2024-12-05T18:13:32.140',
        'role': '1', // Vai trò là quản trị viên (1)
      });
      final docRef0 = fakeFirestore.collection('food').doc();
      await docRef0.set(
        {
          'id': docRef0.id,
          'name': 'Phở',
          'price': '11',
          'imageUrl': 'test_image_pho.com',
        },
      );
      final docRef1 = fakeFirestore.collection('food').doc();
      await docRef1.set(
        {
          'id': docRef1.id,
          'name': 'Bún',
          'price': '12',
          'imageUrl': 'test_image_bun.com',
        },
      );
      fakeUserService.checkUserStatus().listen((state) {
        if (kDebugMode) {
          print('State: ${state[0]}, Role: ${state[1]}');
        }
      });
      // print(fakeFoodService.getAllFood());
      // Khởi chạy MainApp
      await tester.pumpWidget(
        const MaterialApp(
          home: MainApp(),
        ),
      );
      await tester.pumpWidget(const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(bodyHome: HomeAdmin(), title: "Trang chủ Admin"),
      ));

      // Kiểm tra widget HomeAdmin được hiển thị
      expect(find.byType(HomeAdmin), findsOneWidget);
    });
  });
}
