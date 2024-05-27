import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_mobile_123210111/service/DBHelper.dart';
import 'package:tugas_akhir_mobile_123210111/page/saran_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences prefs;

  int _savedId = 0;
  String _savedEmail = "";
  String _savedPassword = "";
  String _imagePath = "";
  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedId = prefs.getInt('id')!;
      _savedEmail = prefs.getString('email')!;
      _savedPassword = prefs.getString('password')!;
      _imagePath = prefs.getString('image')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _imagePath.isEmpty ?
                  Container() : Image.file(
                      File(_imagePath),
                      height: 300,
                      width: 300),
                ),

                Text(
                  'Email: $_savedEmail',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Password: $_savedPassword',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>?>(
                        future: DBHelper().getPurchases(_savedId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No purchases found.'));
                          } else {
                            final purchases = snapshot.data!;
                            return ListView.builder(
                              itemCount: purchases.length,
                              itemBuilder: (context, index) {
                                final purchase = purchases[index];
                                return ListTile(
                                  title: Text(purchase['vehicle']),
                                  subtitle: Text('Date: ${purchase['date_arrival']}'),
                                  trailing: Text('User ID: ${purchase['userid']}'),
                                );
                              },
                            );
                          }
                        }
                    )
                ),
              ],
            ),
          )
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  // // Clear user session and navigate to login page
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.note),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const SaranPage()), // Change LoginPage to your actual login page
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
