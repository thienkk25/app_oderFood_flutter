import 'package:flutter/material.dart';

import '../../../models/food_model.dart';
import '../../../services/food_service.dart';
import 'alert_dialog_view.dart';

class ListTitleView extends StatefulWidget {
  final String page;
  final String id;
  final String name;
  final String name1;
  final String name2;
  final VoidCallback onEdit;
  final VoidCallback onDel;
  final FoodModel foodModel;

  const ListTitleView({
    super.key,
    required this.id,
    required this.name,
    required this.name1,
    required this.onEdit,
    required this.onDel,
    required this.name2,
    required this.page,
    required this.foodModel,
  });

  @override
  State<ListTitleView> createState() => _ListTitleViewState();
}

class _ListTitleViewState extends State<ListTitleView> {
  List textList = [];
  @override
  void initState() {
    if (widget.page == "foodNameList") {
      textList = ["Tên món:", "Giá:", "Link ảnh:", "món ăn"];
    } else {
      textList = ["Email:", "Mật khẩu:", "Quyền:", "tài khoản"];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        title: Text("${textList[0]} ${widget.name}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${textList[1]} ${widget.name1}"),
            Text("${textList[2]} ${widget.name2}")
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.page == "foodNameList"
                ? GestureDetector(
                    child: const Icon(Icons.edit),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialogView(
                          onAdd: () {
                            widget.onEdit(); // cập nhật lại màn hình
                          },
                          textName: "Sửa",
                          textFunction: "editFood",
                          id: widget.id,
                          foodModel: FoodModel(
                              id: widget.id,
                              name: widget.name,
                              price: double.parse(widget.name1),
                              imageUrl: widget.name2),
                        ),
                      );
                    },
                  )
                : const SizedBox(),
            const SizedBox(width: 10),
            widget.page == "foodNameList"
                ? GestureDetector(
                    child: const Icon(Icons.delete),
                    onTap: () {
                      delFood();
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  void delFood() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Bạn chắc chắn xoá?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Huỷ")),
                TextButton(
                    onPressed: () async {
                      String? result = await FoodService().delFood(widget.id);
                      if (result == "Success") {
                        setState(() {
                          Navigator.of(context).pop();
                          widget.onDel(); // cập nhật lại màn hình
                          if (!mounted) return;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Xoá thành công"),
                            duration: Duration(seconds: 2),
                          ));
                        });
                      } else {
                        setState(() {
                          Navigator.of(context).pop();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("Xoá thát bại, vùi long kiểm tra lại"),
                            duration: Duration(seconds: 2),
                          ));
                        });
                      }
                    },
                    child: const Text("Xác nhận")),
              ],
            ));
  }
}
