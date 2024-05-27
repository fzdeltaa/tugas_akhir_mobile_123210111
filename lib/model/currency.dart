import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class Currency {
  final String? date;
  final Usd? usd;

  Currency({
    this.date,
    this.usd,
  });

  Currency.fromJson(Map<String, dynamic> json)
      : date = json['date'] as String?,
        usd = (json['usd'] as Map<String,dynamic>?) != null ? Usd.fromJson(json['usd'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'date' : date,
    'usd' : usd?.toJson()
  };
}

class Usd {
  final Map<String, String?> rates;

  Usd({
    required this.rates,
  });

  Usd.fromJson(Map<String, dynamic> json)
      : rates = {
    for (var key in json.keys) key: json[key].toString()
  };

  Map<String, dynamic> toJson() => rates;
}