import 'package:flutter/material.dart';
import '../services/authencation.dart';
import '../services/user_service.dart';
import 'signin.dart';
import 'welcome.dart';

class Home extends StatefulWidget {
  final Widget bodyHome;
  final String title;
  const Home({super.key, required this.bodyHome, required this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _userEmail;
  Future<void> userData() async {
    final userEmail = await UserService.instance.getData("email");
    setState(() {
      _userEmail = userEmail;
    });
  }

  @override
  void initState() {
    userData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [Container()],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Bảng điều khiển",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                ListTile(title: Text("Thông tin: $_userEmail")),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text("Đổi mật khẩu"),
                  onTap: _showChangePasswordDialog,
                ),
              ],
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Đăng xuất'),
                  onTap: _showLogoutDialog,
                ),
              ],
            ),
          ],
        ),
      ),
      body: widget.bodyHome,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close dialog
                Navigator.of(context).pop();
              },
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () {
                AuthServices().signOutUser();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Welcome()),
                  (Route<dynamic> route) => false,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Đăng xuất thành công"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Có'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _ChangePasswordDialog();
      },
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  String? passwordOld;
  Future<void> userData() async {
    final userPassword = await UserService().getData("password");
    setState(() {
      passwordOld = userPassword;
    });
  }

  @override
  void initState() {
    userData();
    super.initState();
  }

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  final TextEditingController _passwordOld = TextEditingController();
  final TextEditingController _passwordNew = TextEditingController();
  final TextEditingController _passwordAgainNew = TextEditingController();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Đổi mật khẩu'),
      content: SizedBox(
        width: double.infinity,
        height: 220,
        child: SingleChildScrollView(
          child: Form(
              key: _keyForm,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng nhập mật khẩu";
                        } else if (value != passwordOld) {
                          return "Mật khẩu không chính xác";
                        }
                        return null;
                      },
                      controller: _passwordOld,
                      obscureText: _isPasswordVisible,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        // prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: _isPasswordVisible
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.visibility_rounded),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        labelText: "Mật khẩu cũ",
                        labelStyle: const TextStyle(color: Colors.black),
                        // nền input
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng nhập mật khẩu";
                        } else if (value.length < 6) {
                          return "Mật khẩu quá ngắn";
                        }
                        return null;
                      },
                      controller: _passwordNew,
                      obscureText: _isPasswordVisible,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        // prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: _isPasswordVisible
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.visibility_rounded),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        labelText: "Mật khẩu mới",
                        labelStyle: const TextStyle(color: Colors.black),
                        // nền input
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng nhập mật khẩu";
                        } else if (value.length < 6) {
                          return "Mật khẩu quá ngắn";
                        } else if (value != _passwordNew.text) {
                          return "Mật khẩu không khớp";
                        }
                        return null;
                      },
                      controller: _passwordAgainNew,
                      obscureText: _isPasswordVisible,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        // prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: _isPasswordVisible
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.visibility_rounded),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        labelText: "Nhập lại mật khẩu mới",
                        labelStyle: const TextStyle(color: Colors.black),
                        // nền input
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              )),
        ),
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
              changePasswordUser();
            }
          },
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }

  void changePasswordUser() async {
    String result = await AuthServices().changePasswordUser(_passwordNew.text);
    if (result == "Success") {
      setState(() {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignIn()),
            (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Mật khẩu đã được thay đổi thành công, vui lòng đăng nhập lại"),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }
}
