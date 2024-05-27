import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir_mobile_123210111/page/home_page.dart';
import 'package:tugas_akhir_mobile_123210111/service/local_notification.dart';

class PurchasePage extends StatefulWidget {
  final DateTime shipment;
  const PurchasePage({super.key, required this.shipment});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  TextEditingController _dateController = TextEditingController();
  String formattedShipmentDate = '';

  @override
  void initState() {
    super.initState();
    // Initialize the text field with the current date and time
    formattedShipmentDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.shipment);
    _dateController.text = formattedShipmentDate;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Thank You"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Terima Kasih telah membeli!"),
              const Text("Kendaraan anda akan tiba pada:"),
              Row(
                children: [
                  Text('$formattedShipmentDate UTC'),
                  ElevatedButton(
                      onPressed: () => _convertDialogBuilder(context),
                      child: const Text("Kapan?"))
                ],
              ),
              ElevatedButton(onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) => HomePage()), (route) => false);
              }, child: const Text("OK!"))
            ],
          ),
        ));
  }

  Future<void> _convertDialogBuilder(BuildContext context) {
    DateTime utc = widget.shipment;
    DateTime london = utc.add(const Duration(hours: 1));
    DateTime wib = utc.add(const Duration(hours: 7));
    DateTime wita = utc.add(const Duration(hours: 8));
    DateTime wit = utc.add(const Duration(hours: 9));

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Time Converter'),
              content: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller:
                            _dateController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: const Icon(
                              Icons.calendar_today),
                          labelText: "Tanggal & Waktu (UTC)",
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: widget.shipment,
                            firstDate: DateTime(1945),
                            lastDate: DateTime(2025),
                          );

                          if (pickedDate != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(widget.shipment),
                            );

                            if (pickedTime != null) {
                              DateTime finalDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );

                              String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(finalDateTime);

                              setState(() {
                                _dateController.text = formattedDate;
                                utc = finalDateTime;
                                london = utc.add(const Duration(hours: 1));
                                wib = utc.add(const Duration(hours: 7));
                                wita = utc.add(const Duration(hours: 8));
                                wit = utc.add(const Duration(hours: 9));
                              });
                            }
                          }
                        },
                      ),
                      Text('${DateFormat('yyyy-MM-dd HH:mm:ss').format(utc)} UTC'),
                      Text('${DateFormat('yyyy-MM-dd HH:mm:ss').format(london)} London Time'),
                      Text('${DateFormat('yyyy-MM-dd HH:mm:ss').format(wib)} WIB'),
                      Text('${DateFormat('yyyy-MM-dd HH:mm:ss').format(wita)} WITA'),
                      Text('${DateFormat('yyyy-MM-dd HH:mm:ss').format(wit)} WIT'),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
