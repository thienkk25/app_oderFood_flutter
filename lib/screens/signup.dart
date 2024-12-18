import 'package:flutter/material.dart';
import '../screens/signin.dart';

import '../services/authencation.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _againPassword = TextEditingController();
  // Regular expression for email validation
  final RegExp _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool _isPasswordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      "Đăng ký",
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
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: _password,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Vui lòng nhập mật khẩu";
                              } else if (value.length < 6) {
                                return "Mật khẩu quá ngắn";
                              }
                              return null;
                            },
                            cursorColor: const Color.fromARGB(255, 162, 255, 0),
                            obscureText: _isPasswordVisible,
                            obscuringCharacter: '*',
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 162, 255, 0),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible =
                                          !_isPasswordVisible; // Toggle the state
                                    });
                                  },
                                  child: _isPasswordVisible
                                      ? const Icon(
                                          Icons.visibility_off_outlined,
                                          color:
                                              Color.fromARGB(255, 162, 255, 0),
                                        )
                                      : const Icon(
                                          Icons.visibility_rounded,
                                          color:
                                              Color.fromARGB(255, 162, 255, 0),
                                        ),
                                ),
                                // Màu sắc của khung khi chưa focus
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                // Màu sắc của khung khi focus
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                labelText: "Mật khẩu",
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 162, 255, 0)),
                                filled: true,
                                fillColor: Colors.black12),
                            style: const TextStyle(color: Colors.yellowAccent),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: _againPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Vui lòng nhập mật khẩu";
                              } else if (value.length < 6) {
                                return "Mật khẩu quá ngắn";
                              } else if (value != _password.text) {
                                return "Mật khẩu không khớp, vui lòng kiểm tra lại";
                              }
                              return null;
                            },
                            cursorColor: const Color.fromARGB(255, 162, 255, 0),
                            obscureText: _isPasswordVisible,
                            obscuringCharacter: '*',
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 162, 255, 0),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible =
                                          !_isPasswordVisible; // Toggle the state
                                    });
                                  },
                                  child: _isPasswordVisible
                                      ? const Icon(
                                          Icons.visibility_off_outlined,
                                          color:
                                              Color.fromARGB(255, 162, 255, 0),
                                        )
                                      : const Icon(
                                          Icons.visibility_rounded,
                                          color:
                                              Color.fromARGB(255, 162, 255, 0),
                                        ),
                                ),
                                // Màu sắc của khung khi chưa focus
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                // Màu sắc của khung khi focus
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                labelText: "Nhập lại mật khẩu",
                                labelStyle: const TextStyle(
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
                                  signUp();
                                }
                              },
                              child: const Text(
                                "Đăng ký",
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

  void signUp() async {
    String result = await AuthServices()
        .signUpUser(email: _email.text, password: _password.text);
    if (result == "Success") {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignIn()),
          (Route<dynamic> route) => false,
        );
        if (!mounted) return;
        // Hiển thị thông báo nếu đăng ký thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký thành công")),
        );
      });
    } else {
      if (!mounted) return;
      // Hiển thị thông báo lỗi nếu đăng nhập thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đăng ký thất bại, vui lòng thử lại"),
        ),
      );
    }
  }
}
