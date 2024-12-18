import 'package:flutter/material.dart';
import '../screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/admin/home_admin.dart';
import 'screens/clients/home_client.dart';
import 'screens/home.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  String onState = "no"; // Mặc định là người dùng chưa đăng nhập
  String onRole = "null";
  @override
  void initState() {
    if (UserService.instance.checkSession() != "") {
      // Lắng nghe trạng thái đăng nhập của người dùng
      UserService.instance.checkUserStatus().listen((state) {
        setState(() {
          onState = state[0]; // Cập nhật trạng thái
          onRole = state[1];
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (onState == "no") {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Welcome(),
      );
    } else {
      if (onRole == "0") {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Home(bodyHome: HomeClient(), title: "Trang chủ"),
        );
      }
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(bodyHome: HomeAdmin(), title: "Trang chủ Admin"),
      );
    }
  }
}
