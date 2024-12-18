import 'package:flutter/material.dart';

import '../../models/food_model.dart';
import '../../services/food_service.dart';
import 'custome/alert_dialog_view.dart';
import 'custome/list_title_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [];

  @override
  void initState() {
    getAllFood();
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
                onAdd: () => getAllFood(),
                textName: "Thêm",
                textFunction: "addFood",
                id: "null",
                foodModel: FoodModel(id: '', imageUrl: '', name: '', price: 0),
              ),
            );
          },
          tooltip: "Thêm món ăn",
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
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialogView(
                        onAdd: () {
                          getAllFood(); // cập nhật lại màn hình
                        },
                        textName: "Sửa",
                        textFunction: "editFood",
                        id: item['id'],
                        foodModel: FoodModel(
                            id: item['id'],
                            name: item['name'],
                            price: item['price'],
                            imageUrl: item['imageUrl']),
                      ),
                    );
                  },
                  child: Padding(
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
                        page: "foodNameList",
                        id: item['id'],
                        name: item['name']!,
                        name1: item['price'].toString(),
                        name2: item['imageUrl'],
                        onEdit: () => getAllFood(),
                        onDel: () => getAllFood(),
                        foodModel: FoodModel(
                            id: item['id'],
                            name: item['name'],
                            price: item['price'],
                            imageUrl: item['imageUrl']),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ));
  }

  Future<void> getAllFood() async {
    List data = await FoodService.instance.getAllFood();
    setState(() {
      items = data;
    });
    // print(data[0]['price']);
  }
}
