import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../services/food_service.dart';
import '../../services/user_service.dart';

class HomeClient extends StatefulWidget {
  const HomeClient({super.key});

  @override
  State<HomeClient> createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  List items = [];
  late Future<void> _loadFoodFuture;
  late FirebaseApp app;
  late FirebaseDatabase databaseReference;
  final _searchController = SearchController();
  @override
  void initState() {
    _loadFoodFuture = getAllFood();
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    // Ensure Firebase is initialized
    app = await Firebase.initializeApp();
    databaseReference = FirebaseDatabase.instanceFor(
      app: app,
      databaseURL:
          "https://oderfood2525-default-rtdb.asia-southeast1.firebasedatabase.app/",
      // "<link_your_databaseURL>",
    );
    setState(() {}); // Trigger rebuild after Firebase initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Image.asset(
        'assets/images/bg_home.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.fill,
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SearchAnchor.bar(
              searchController: _searchController,
              suggestionsBuilder: (context, controller) {
                final String input = controller.value.text;

                final List<String> listNameFood = List.generate(
                    items.length, (index) => items[index]['name']);

                // Lọc danh sách dựa trên đầu vào của người dùng
                final List<String> suggestions = listNameFood
                    .where((element) =>
                        element.toLowerCase().contains(input.toLowerCase()))
                    .toList();
                // Hiển thị danh sách gợi ý
                return suggestions.map((element) {
                  final food =
                      items.firstWhere((item) => item['name'] == element);
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      leading: SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: CachedNetworkImage(
                            imageUrl: food['imageUrl'],
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(food['name']),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text(food['name']),
                                ),
                                body: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: food['imageUrl'],
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ))));

                        controller.clear();
                      },
                    ),
                  );
                }).toList();
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: getAllFood,
              child: FutureBuilder(
                  future: _loadFoodFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (items.isNotEmpty) {
                        return GridView.builder(
                          itemCount: items.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return GridtitleView(
                              id: item['id'],
                              name: item['name'],
                              price: item['price'].toString(),
                              imageUrl: item['imageUrl'],
                              databaseReference: databaseReference,
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Vui lòng kết nối mạng",
                                style: TextStyle(
                                    backgroundColor: Colors.black54,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const CircularProgressIndicator(),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      getAllFood();
                                    });
                                  },
                                  child: const Text("Làm mới")),
                            ],
                          ),
                        );
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ),
        ],
      ),
    ]));
  }

  Future<void> getAllFood() async {
    List data = await FoodService.instance.getAllFood();
    setState(() {
      items = data;
    });
    // print(data[0]['price']);
  }
}

class GridtitleView extends StatefulWidget {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final FirebaseDatabase databaseReference;
  const GridtitleView({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.databaseReference,
  });

  @override
  State<GridtitleView> createState() => _GridtitleViewState();
}

class _GridtitleViewState extends State<GridtitleView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridTile(
        footer: Container(
          decoration: const BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: Column(
            children: [
              Text(
                "Tên món: ${widget.name}",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "Giá: \$ ${widget.price}",
                style: const TextStyle(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 124, 124, 105)),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              title: const Text("Bạn chắc chắn gọi?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Không")),
                                TextButton(
                                    onPressed: () {
                                      callFood(
                                          "Món: ${widget.name}, giá: \$ ${widget.price}");
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Xác nhận")),
                              ])),
                  label: const Text(
                    "Gọi món",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.call,
                    color: Colors.yellow,
                  ),
                ),
              )
            ],
          ),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Future<void> callFood(String message) async {
    try {
      final user = await UserService.instance.getData("email");
      widget.databaseReference.ref('notifications').push().set({
        "title": "Thông báo $user gọi món",
        "message": message,
        "timestamp": DateTime.now().toIso8601String(),
      });
      if (user != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Gọi thành công")));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
