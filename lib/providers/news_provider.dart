import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/news_api.dart';

class NewsProvider with ChangeNotifier {
  final NewsApi newsApi;

  NewsProvider({required this.newsApi});

  List<NewsArticle> generalNews = [];
  Map<String, List<NewsArticle>> coinNews = {};
  bool isLoadingGeneral = false;
  Map<String, bool> isLoadingCoin = {};

  // Fetch general news
  Future<void> fetchGeneralNews() async {
    isLoadingGeneral = true;
    notifyListeners();

    try {
      generalNews = await newsApi.fetchGeneralNews();
    } catch (e) {
      rethrow;
    } finally {
      isLoadingGeneral = false;
      notifyListeners();
    }
  }

  // Fetch coin-specific news
  Future<void> fetchCoinNews(String coinSymbol) async {
    isLoadingCoin[coinSymbol] = true;
    notifyListeners();

    try {
      coinNews[coinSymbol] = await newsApi.fetchCoinNews(coinSymbol);
    } catch (e) {
      rethrow;
    } finally {
      isLoadingCoin[coinSymbol] = false;
      notifyListeners();
    }
  }

  List<NewsArticle> getCoinNews(String coinSymbol) {
    return coinNews[coinSymbol] ?? [];
  }

  bool isLoadingForCoin(String coinSymbol) {
    return isLoadingCoin[coinSymbol] ?? false;
  }
}
