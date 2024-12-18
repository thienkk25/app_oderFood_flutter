import 'package:flutter/material.dart';

import '../../models/food_model.dart';
import '../../services/user_service.dart';
import 'custome/alert_dialog_view.dart';
import 'custome/list_title_view.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({super.key});

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  List items = [];

  @override
  void initState() {
    getAllUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialogView(
                onAdd: () => getAllUser(),
                textName: "Thêm",
                textFunction: "addUsers",
                id: "null",
                foodModel: FoodModel(id: '', imageUrl: '', name: '', price: 0),
              ),
            );
          },
          tooltip: "Thêm tài khoản",
          child: const Icon(
            Icons.add,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Stack(
          children: [
            Image.asset(
              'assets/images/bg_home.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            ListView(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70, // Màu nền
                      border: Border.all(
                        color: Colors.black, // Màu viền
                        width: 2.0, // Độ dày viền
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTitleView(
                      page: "usersNameList",
                      id: item['uid'],
                      name: item['email'],
                      name1: item['password'],
                      name2: item['role'],
                      onEdit: () => getAllUser(),
                      onDel: () => getAllUser(),
                      foodModel:
                          FoodModel(id: '', imageUrl: '', name: '', price: 0),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ));
  }

  Future<void> getAllUser() async {
    List data = await UserService().getAllUser();
    setState(() {
      items = data;
    });
    // print(data[0]['price']);
  }
}
