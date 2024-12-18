import 'package:flutter/material.dart';

import '../../../models/food_model.dart';
import '../../../services/food_service.dart';
import '../../../services/user_service.dart';

class AlertDialogView extends StatefulWidget {
  final VoidCallback onAdd;
  final String textName;
  final String textFunction;
  final String id;
  final FoodModel foodModel;

  const AlertDialogView(
      {super.key,
      required this.onAdd,
      required this.textName,
      required this.textFunction,
      required this.id,
      required this.foodModel});

  @override
  State<AlertDialogView> createState() => _AlertDialogViewState();
}

class _AlertDialogViewState extends State<AlertDialogView> {
  final _keyForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final name1Controller = TextEditingController();
  final name2Controller = TextEditingController();
  final RegExp regExpRealNumber = RegExp(r"^[+-]?(\d+(\.\d*)?|\.\d+)$");
  List textList = [];
  @override
  void initState() {
    if (widget.textFunction == "addFood" || widget.textFunction == "editFood") {
      textList = ["Tên món", "Giá", "Link ảnh", "món ăn"];
      if (widget.textFunction == "editFood") {
        nameController.text = widget.foodModel.name;
        name1Controller.text = widget.foodModel.price.toString();
        name2Controller.text = widget.foodModel.imageUrl;
      }
    } else {
      textList = ["Email", "Mật khẩu", "Quyền", "tài khoản"];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${widget.textName} ${textList[3]}"),
      content: SizedBox(
        width: 300,
        height: 200,
        child: Form(
            key: _keyForm,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng không để trống";
                        } else {
                          if (!RegExp(r"^\S.*$").hasMatch(value)) {
                            return "Có kí tự trống ở đầu";
                          }
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(labelText: textList[0]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng không để trống";
                        } else {
                          if (!regExpRealNumber.hasMatch(value)) {
                            return "Vui lòng nhập số";
                          }
                        }
                        return null;
                      },
                      controller: name1Controller,
                      decoration: InputDecoration(labelText: textList[1]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng không để trống";
                        }
                        return null;
                      },
                      controller: name2Controller,
                      decoration: InputDecoration(labelText: textList[2]),
                    ),
                  ),
                ],
              ),
            )),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Huỷ'),
        ),
        TextButton(
          onPressed: () {
            if (_keyForm.currentState!.validate()) {
              switch (widget.textFunction) {
                case "addFood":
                  addFood();
                  break;
                case "editFood":
                  editFood();
                  break;
                case "addUsers":
                  addUsers();
                  break;
              }
            }
          },
          child: Text(widget.textName),
        ),
      ],
    );
  }

  void addFood() async {
    String? result = await FoodService().addFood(nameController.text,
        double.parse(name1Controller.text), name2Controller.text);
    if (result == "Success") {
      setState(() {
        widget.onAdd();
        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${widget.textName} món ăn thành công"),
          duration: const Duration(seconds: 2),
        ));
      });
    }
  }

  void editFood() async {
    String? result = await FoodService().updateFood(
        widget.id,
        nameController.text,
        double.parse(name1Controller.text),
        name2Controller.text);
    if (result == "Success") {
      setState(() {
        widget.onAdd(); // cập nhật lại màn hình
        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${widget.textName} món ăn thành công"),
          duration: const Duration(seconds: 2),
        ));
      });
    }
  }

  void addUsers() async {
    String? result = await UserService().addUsers(
        nameController.text, name1Controller.text, name2Controller.text);
    if (result == "Success") {
      setState(() {
        widget.onAdd();
        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${widget.textName} thêm tài khoản thành công"),
          duration: const Duration(seconds: 2),
        ));
      });
    }
  }
}
