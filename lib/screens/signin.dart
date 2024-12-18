import 'package:flutter/material.dart';
import '../screens/home.dart';
import 'package:app_oderfood/services/authencation.dart';

import '../services/user_service.dart';
import 'admin/home_admin.dart';
import 'clients/home_client.dart';
import 'forgot.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
// Regular expression for email validation
  final RegExp _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool _isPasswordVisible = true;
  bool _value = false;
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
                      "Đăng nhập",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Vui long nhap email";
                              } else if (!_emailRegExp.hasMatch(value)) {
                                return "Email khong hop le";
                              }
                              return null;
                            },
                            controller: _email,
                            cursorColor: const Color.fromARGB(255, 162, 255, 0),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color.fromARGB(255, 162, 255, 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 162, 255, 0),
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                            ),
                            style: const TextStyle(color: Colors.yellowAccent),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Vui lòng nhập mật khẩu";
                              }
                              return null;
                            },
                            controller: _password,
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
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                child: _isPasswordVisible
                                    ? const Icon(
                                        Icons.visibility_off_outlined,
                                        color: Color.fromARGB(255, 162, 255, 0),
                                      )
                                    : const Icon(
                                        Icons.visibility_rounded,
                                        color: Color.fromARGB(255, 162, 255, 0),
                                      ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              labelText: "Mật khẩu",
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 162, 255, 0),
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                            ),
                            style: const TextStyle(color: Colors.yellowAccent),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value!;
                                      });
                                    },
                                    shape: const CircleBorder(),
                                    activeColor: Colors.black,
                                    checkColor:
                                        const Color.fromARGB(255, 162, 255, 0),
                                  ),
                                  const Text("Đồng ý và điều khoản")
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                const Forgot()));
                                  },
                                  child: const Text(
                                    "Quên mật khẩu",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (!_value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Vui lòng tích đồng ý và điều khoản")));
                                } else {
                                  signIn();
                                }
                              }
                            },
                            child: const Text(
                              "Đăng nhập",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void signIn() async {
    String result = await AuthServices()
        .signInUser(email: _email.text, password: _password.text);
    String? role = await UserService().getData("role");
    if (result == "Success") {
      if (role == "0" || role == null) {
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const Home(
                      bodyHome: HomeClient(),
                      title: "Trang chủ",
                    )),
            (Route<dynamic> route) => false,
          );
          if (!mounted) return;
          // Hiển thị thông báo nếu đăng nhập thành công
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đăng nhập thành công"),
            ),
          );
        });
      } else {
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const Home(
                    bodyHome: HomeAdmin(), title: "Trang chủ Admin")),
            (Route<dynamic> route) => false,
          );
          if (!mounted) return;
          // Hiển thị thông báo nếu đăng nhập thành công
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đăng nhập thành công"),
            ),
          );
        });
      }
    } else {
      if (!mounted) return;
      // Hiển thị thông báo lỗi nếu đăng nhập thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đăng nhập thất bại, vui lòng thử lại"),
        ),
      );
    }
  }
}
