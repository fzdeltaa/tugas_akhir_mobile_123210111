import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_mobile_123210111/service/DBHelper.dart';
import 'dart:convert' as convert;

import 'package:tugas_akhir_mobile_123210111/model/currency.dart';
import 'package:tugas_akhir_mobile_123210111/model/starship.dart';
import 'package:tugas_akhir_mobile_123210111/page/purchase_page.dart';
import 'package:tugas_akhir_mobile_123210111/service/local_notification.dart';

class StarshipDetailPage extends StatefulWidget {
  var myObject;
  StarshipDetailPage({super.key, this.myObject});

  @override
  State<StarshipDetailPage> createState() => _StarshipDetailPageState();
}

class _StarshipDetailPageState extends State<StarshipDetailPage> {
  late Starship starship;
  final ExpansionTileController _expansionTileController = ExpansionTileController();
  late Future<Currency> currencies;
  late SharedPreferences prefs;
  int _savedId = 0;

  @override
  void initState() {
    super.initState();
    starship = widget.myObject;
    currencies = getCurrency();
    getPrefs();
    LocalNotificationService.initialize();
  }

  Future<Currency> getCurrency() async {
    var url = Uri.parse('https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return Currency.fromJson(convert.jsonDecode(response.body));
    } else {
      throw Exception('Failed to load manga images, ${response.statusCode}');
    }
  }

  void getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedId = prefs.getInt('id')!;
    });
  }

  Future<void> _insertPurchase(int userId, String vehicleName, String date) async {
    await DBHelper().insertPurchases(userId, vehicleName, date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ship Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              // clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    title: Text(starship.model ?? '',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (starship.name!.isNotEmpty && starship.name != starship.model)
                          Text(
                            '(${starship.name})',
                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        starship.starshipClass!.isNotEmpty ? Text(
                          '${starship.starshipClass}-class Starship',
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        ) : const Text(''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                              'Price: ${NumberFormat.decimalPatternDigits(
                                  locale: 'en_us',
                                  decimalDigits: 0)
                                  .format(double.parse('${starship.costInCredits}'))} Credits',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(1),
                                  fontSize: 20)
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () => _convertDialogBuilder(context),
                            child: Text("Convert"))
                      ],
                    ),
                  ),
                  ExpansionTile(
                    title: const Text("Specifications"),
                    controller: _expansionTileController,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Card(
                                child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFABBC2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          title: const Text('Length',
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          subtitle: Text(
                                            '${starship.length} meters',
                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFABBC2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          title: const Text('Max Speed in Atmosphere',
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          subtitle: Text(
                                            '${starship.maxAtmospheringSpeed}',
                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFABBC2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          title: const Text('HyperDrive Class Rating',
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          subtitle: Text(
                                            '${starship.hyperdriveRating}',
                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFABBC2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          title: const Text('Crew Size',
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          subtitle: Text(
                                            '${starship.crew} people',
                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFABBC2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'MGLT',
                                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => _mgltDialog(context),
                                                child: Text('?'),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                            '${starship.mGLT}',
                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFABBC2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          title: const Text('Passengers',
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          subtitle: Text(
                                            '${starship.passengers}',
                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFABBC2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          title: const Text(
                                            'Cargo Capacity',
                                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            '${starship.cargoCapacity} kg',
                                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ),
                                      )

                                    ]
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            // TODO: purchase
            ElevatedButton(
              onPressed: () => _konfirmasiDialog(context),
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
                    "Purchase",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      )
    );
  }

  Decimal getCurrencyValue(String key, Currency? currency) {
    // return BigDecimal.parse('16035.72979908');
    return Decimal.parse('${currency?.usd?.rates[key] ?? 0}');
  }

  // TODO: convertDialog
  Future<void> _convertDialogBuilder(BuildContext context) {
    final converterController = TextEditingController(
        text: starship.costInCredits);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
            future: currencies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No data available'));
              } else {

                // TODO: https://stackoverflow.com/questions/62580280/how-to-format-numbers-as-thousands-separators-in-dart

                var formatter123 = NumberFormat.decimalPattern('en-US');
                Decimal convertedPrice = Decimal.parse('${starship.costInCredits}')*Decimal.parse('4');
                Decimal idrPrice = convertedPrice*getCurrencyValue('idr', snapshot.data);
                Decimal yuanPrice = convertedPrice*getCurrencyValue('cny', snapshot.data);
                Decimal rubelPrice = convertedPrice*getCurrencyValue('rub', snapshot.data);

                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return AlertDialog(
                      title: const Text('Price Converter'),
                      content: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              enabled: true,
                              controller: converterController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Nilai Credits',
                                hintText: 'Masukkan nilai uang',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  convertedPrice = Decimal.parse(value) * Decimal.parse('4');
                                  idrPrice = convertedPrice * getCurrencyValue('idr', snapshot.data);
                                  yuanPrice = convertedPrice * getCurrencyValue('cny', snapshot.data);
                                  rubelPrice = convertedPrice * getCurrencyValue('rub', snapshot.data);
                                });
                              },
                            ),
                            const Text('Nilai terkonversi: '),
                            const Text('1 Credits = 4\$'),
                            Text('USD: ${formatter123.format(DecimalIntl(convertedPrice))}\$'),
                            Text('IDR: Rp${formatter123.format(DecimalIntl(idrPrice))}'),
                            Text('Chinese Yuan: ${formatter123.format(DecimalIntl(yuanPrice))}¥'),
                            Text('Russian Ruble: ${formatter123.format(DecimalIntl(rubelPrice))}₽'),

                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .labelLarge,
                          ),
                          child: const Text('Close'),
                          onPressed: () {
                            converterController.clear();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
        );
      },
    );
  }

  Future<void> _mgltDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('MGLT'),
          content: Text("MGLT adalah jarak Megalight yang dapat ditempuh kapal ini dalam waktu satu jam."),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  // TODO: konfirmasi Dialog
  Future<void> _konfirmasiDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text("Anda yakin ingin beli?"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ya'),
              onPressed: () {
                DateTime now = DateTime.now();
                DateTime shipment = now.toUtc().add(const Duration(days: 7));

                _insertPurchase(_savedId, '${starship.name}', DateFormat('yyyy-MM-dd HH:mm:ss').format(shipment));
                LocalNotificationService.showTextNotification(title: "Pembelian Berhasil", body: "Anda telah membeli ${starship.name}");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PurchasePage(shipment: shipment),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}