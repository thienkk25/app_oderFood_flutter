// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'manage_account.dart';
import 'notifications.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int _selectedIndex = 0; // Chỉ số tab hiện tại
  // Danh sách các widget (trang màn hình)
  final List<Widget> _pages = [
    const HomePage(), // Trang Home
    const ManageAccount(), // Trang ManageAccount
    const Notifications(), // Trang Notifications
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(icon: Icon(Icons.home), label: "Trang chủ"),
              NavigationDestination(
                  icon: Icon(Icons.manage_accounts), label: "Các tài khoản"),
              NavigationDestination(
                  icon: Icon(Icons.notifications), label: "Thông báo"),
            ]));
  }
}
