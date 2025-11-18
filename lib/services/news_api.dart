import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsApi {
  final String baseUrl = 'https://min-api.cryptocompare.com/data/v2/news/';

  // General crypto news
  Future<List<NewsArticle>> fetchGeneralNews() async {
    final uri = Uri.parse('$baseUrl?lang=EN');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> articles = data['Data'];
      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch general news: ${response.body}');
    }
  }

  // Coin-specific news (filter by coin symbol)
  Future<List<NewsArticle>> fetchCoinNews(String coinSymbol) async {
    final uri = Uri.parse('$baseUrl?lang=EN&categories=$coinSymbol');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> articles = data['Data'];
      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch coin news: ${response.body}');
    }
  }
}
