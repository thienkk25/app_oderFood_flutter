import 'package:flutter/material.dart';
import '../services/authencation.dart';
import 'signin.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  // Regular expression for email validation
  final RegExp _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "Quên mật khẩu",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              Flexible(
                  flex: 8,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: _email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Vui lòng nhập email";
                              } else if (!_emailRegExp.hasMatch(value)) {
                                return "Email không hợp lệ";
                              }
                              return null;
                            },
                            cursorColor: const Color.fromARGB(
                                255, 162, 255, 0), // Màu sắc nháy
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 162, 255, 0),
                                ),
                                // Màu sắc của khung khi chưa focus
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                // Màu sắc của khung khi focus
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                labelText: "Email",
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 162, 255, 0)),
                                filled: true,
                                fillColor: Colors.black12),
                            style: const TextStyle(color: Colors.yellowAccent),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  forgot();
                                }
                              },
                              child: const Text(
                                "Xác nhận",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              )),
                        )
                      ],
                    ),
                  )),
            ],
          )),
        ],
      ),
    );
  }

  void forgot() async {
    String result = await AuthServices().forgotUser(email: _email.text);
    if (result == "Success") {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignIn()),
          (Route<dynamic> route) => false,
        );
        if (!mounted) return;
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Đã gửi thành công, vui lòng kiểm tra thư")),
        );
      });
    } else {
      if (!mounted) return;
      // Hiển thị thông báo thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thất bại, vui lòng thử lại"),
        ),
      );
    }
  }
}
