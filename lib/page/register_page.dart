import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_mobile_123210111/service/DBHelper.dart';
import 'package:tugas_akhir_mobile_123210111/page/home_page.dart';
import 'package:tugas_akhir_mobile_123210111/page/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password1Controller = TextEditingController();
  String _errorMessage = "";

  late SharedPreferences prefs;
  String _savedEmail = "";
  String _savedPassword = "";

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedEmail = prefs.getString('email')!;
      _savedPassword = prefs.getString('password')!;
      if(_savedEmail.isNotEmpty || _savedPassword.isNotEmpty) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()));
      }
    });
  }

  bool _isEmailValid(String email) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    return email.isNotEmpty && !regex.hasMatch(email) ? false : true;
  }

  Future<void> _registerUser(String email, String password) async {
    var bytes1 = utf8.encode(email); // data being hashed
    var digest1 = sha512.convert(bytes1);

    var bytes2 = utf8.encode(password); // data being hashed
    var digest2 = sha512.convert(bytes2);

    await DBHelper().insertUser(
        digest1.toString(),
        digest2.toString()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(60),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20), // Padding
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Border radius
                      ),
                      hintText: "Masukkan Email"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20), // Padding
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Border radius
                      ),
                      hintText: "Masukkan password"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _password1Controller,
                  obscureText: true,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20), // Padding
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Border radius
                      ),
                      hintText: "Masukkan password lagi"),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_passwordController.text.isEmpty ||
                          _password1Controller.text.isEmpty ||
                          _emailController.text.isEmpty) {
                        _errorMessage = "Masih ada yang kosong!";
                        return;
                      }

                      if (_passwordController.text !=
                          _password1Controller.text) {
                        _errorMessage = "Password harus sama";
                        return;
                      }
                      String password = _passwordController.text;

                      String email = _emailController.text;
                      if (!_isEmailValid(email)) {
                        _errorMessage = "email tdk valid";
                        return;
                      }

                      _registerUser(email, password);
                      _errorMessage = "";
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Register berhasil! Silakan Login")));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Make button squarer
                    ),
                  ),
                  child: Container(
                    width: double
                        .infinity, // Set button width to match parent width
                    height: 55, // Set button height
                    padding: const EdgeInsets.all(10), // Set padding
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Make button squarer
            ),
          ),
          child: Container(
            width: double.infinity, // Set button width to match parent width
            height: 55, // Set button height
            padding: const EdgeInsets.all(10), // Set padding
            child: const Center(
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ));
  }
}
