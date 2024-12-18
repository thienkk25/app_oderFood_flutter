import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  FirebaseApp? app;
  FirebaseDatabase? databaseReference;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    app = await Firebase.initializeApp();
    databaseReference = FirebaseDatabase.instanceFor(
      app: app!,
      databaseURL:
          "https://oderfood2525-default-rtdb.asia-southeast1.firebasedatabase.app/",
    );
    setState(() {});
  }

  // Phương thức để lấy dữ liệu từ snapshot
  List<dynamic> _getNotifications(DataSnapshot snapshot) {
    if (snapshot.value == null) {
      return [];
    }
    // Ép kiểu dữ liệu thành Map<String, dynamic>
    final notifications = snapshot.value as Map<dynamic, dynamic>;
    return notifications.values.toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (app == null || databaseReference == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: StreamBuilder<DatabaseEvent>(
        stream: databaseReference!
            .ref('notifications')
            .orderByChild('timestamp')
            // .limitToLast(5)
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // Kiểm tra dữ liệu có hợp lệ không
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Không có thông báo'));
          }

          // Lấy danh sách thông báo từ phương thức
          final notificationList = _getNotifications(snapshot.data!.snapshot);

          return ListView.builder(
            itemCount: notificationList.length,
            itemBuilder: (context, index) {
              final notification = notificationList[index];
              return ListTile(
                title: Text(notification['title']),
                subtitle: Text(
                    "${notification['message']}, Thời gian gọi ${notification['timestamp']}"),
              );
            },
          );
        },
      ),
    );
  }
}
