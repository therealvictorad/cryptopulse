import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto.dart';

class CryptoApi {
  static const String baseUrl =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h';

  // Returns fully parsed Crypto objects
  Future<List<Crypto>> fetchCryptos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Crypto.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch crypto data');
    }
  }

  // returns raw JSON if needed
  Future<List<dynamic>> fetchCryptosRaw() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch crypto data');
    }
  }
}
