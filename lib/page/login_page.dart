import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_mobile_123210111/service/DBHelper.dart';
import 'package:tugas_akhir_mobile_123210111/page/home_page.dart';
import 'package:tugas_akhir_mobile_123210111/page/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences prefs;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _savedEmail = "";
  String _savedPassword = "";
  String _errorMessage = "";
  String _imagePath = "";
  final ImagePicker _picker = ImagePicker();

  Future<String> getImage(bool isCamera) async{
    final XFile? image;
    if(isCamera){
      image = await _picker.pickImage(source:
      ImageSource.camera);
    } else {
      image = await _picker.pickImage(source:
      ImageSource.gallery);
    }
    return image!.path;
  }

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

  Future<void> _setSession(
      int id, String email, String password, String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
    prefs.setString('email', email);
    prefs.setString('password', password);
    prefs.setString('image', imagePath);
  }

  Future<void> login(String username, String password, String imagePath) async {
    var bytes1 = utf8.encode(username); // data being hashed
    var digest1 = sha512.convert(bytes1);

    var bytes2 = utf8.encode(password); // data being hashed
    var digest2 = sha512.convert(bytes2);


    final user =
    await DBHelper().check(digest1.toString(), digest2.toString());

    if(user != null) {
      await _setSession(user['id'], username, password, imagePath);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      setState(() {
        _errorMessage = "Email atau password salah!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(60),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text('$_savedPassword $_savedEmail'),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Border radius
                      ),
                      hintText: "Masukkan email"
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Border radius
                      ),
                      hintText: "Masukkan password"
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                    onPressed: () async {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        setState(() {
                          _errorMessage = "Isi semuanya dahulu!";

                        });
                        return;
                      }
                        _imagePath = await getImage(true);
                        login(_emailController.text, _passwordController.text, _imagePath);
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
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
                "Register",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
    );
  }
}
