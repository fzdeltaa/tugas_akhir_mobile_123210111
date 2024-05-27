import 'package:flutter/material.dart';
import 'package:tugas_akhir_mobile_123210111/page/login_page.dart';
import 'package:tugas_akhir_mobile_123210111/page/profile_page.dart';

class SaranPage extends StatelessWidget {
  const SaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saran & Kesan'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ListTile(
                  title: Text('Saran',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bila memang tugas akhir kuliah memiliki banyak kemiripan dengan praktikum,'
                            ' dapat dipertimbangkan untuk menggabungkan keduanya.\nMempermudah '
                            'mahasiswa dan penilai.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )
              )
            ),
            Card(
                child: ListTile(
                    title: Text('Kesan',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deadline ngebut tapi mahasiswanya ketawa nge-iyain.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    )
                )
            ),
          ],
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
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  // // Clear user session and navigate to login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage()), // Change LoginPage to your actual login page
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
