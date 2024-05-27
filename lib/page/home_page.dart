import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:tugas_akhir_mobile_123210111/model/starship.dart';
import 'package:tugas_akhir_mobile_123210111/page/login_page.dart';
import 'package:tugas_akhir_mobile_123210111/page/profile_page.dart';
import 'package:tugas_akhir_mobile_123210111/page/saran_page.dart';
import 'package:tugas_akhir_mobile_123210111/page/starship_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePagePageState();
}

class _HomePagePageState extends State<HomePage> {
  // Future<StarshipsResult>? starships;
  late Future<List<Starship>> starships;
  final _searchController = TextEditingController();
  String pageTitle =  'Starships Catalogs';
  String baseUrl = 'https://swapi.dev/api/starships/?format=json';

  @override
  void initState() {
    super.initState();
    starships = getAllStarships();
  }

  Future<List<Starship>> getAllStarships() async {
    List<Starship> allStarships = [];
    String? url = baseUrl;

    while (url != null) {
      StarshipsResult result = await getStarships(url);
      if (result.starships != null) {
        allStarships.addAll(result.starships!);
      }
      url = result.next;
    }

    return allStarships;
  }

  Future<StarshipsResult> getStarships(String urla, [String? title]) async {
    var url = Uri.parse(urla);
    // print(url);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return StarshipsResult.fromJson(convert.jsonDecode(response.body));
    } else {
      throw Exception('Failed to load manga images, ${response.statusCode}');
    }
  }

  List<Starship> filterStarship(List<Starship> aseli, String input, List<Starship> orijinal) {
    if(input.isEmpty) return orijinal;

    var kretekFilter = aseli.where((o) => (o.name!.toLowerCase().contains(input.toLowerCase()) || o.model!.toLowerCase().contains(input.toLowerCase()))).toList();
    return kretekFilter;
  }



  Future<void> _clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Starship>>(
                future: starships,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data available'));
                  } else {
                    var nyata = snapshot.data!;
                    var filtered = nyata;
                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  filtered = filterStarship(filtered, value, nyata);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search starship...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              // onSubmitted: (title) {
                              //   setState(() {
                              //     filtered = filterStarship(filtered, _searchController.text);
                              //   });
                              // },
                            ),
                          ),
                          Expanded(
                              child:
                              ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  var starship = filtered[index];
                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              starship.model
                                                  ?? '',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 5),
                                                Text(starship.name ?? ''),
                                                Text(starship.manufacturer ?? ''),
                                              ],
                                            ),
                                            trailing:
                                            const Icon(Icons.keyboard_arrow_right),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => StarshipDetailPage(
                                                      myObject: starship ?? ''),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                          )
                        ],
                      );
                    });
                  }
                },
              ),
            )
          ],
        ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  // // Clear user session and navigate to login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage()), // Change LoginPage to your actual login page
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.note),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SaranPage()), // Change LoginPage to your actual login page
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  _clearSession();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) => LoginPage()), (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     // Important: Remove any padding from the ListView.
      //     padding: EdgeInsets.zero,
      //     children: [
      //       const DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.blue,
      //         ),
      //         child: Text('Nama loe'),
      //       ),
      //       ListTile(
      //         title: const Text('Latest Update'),
      //         onTap: () {
      //           // Update the state of the app.
      //           // ...
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Advanced Search'),
      //         onTap: () {
      //           // Update the state of the app.
      //           // ...
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Random Manga'),
      //         onTap: () {
      //           // Update the state of the app.
      //           // ...
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Favorite Manga'),
      //         onTap: () {
      //           // Update the state of the app.
      //           // ...
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}


