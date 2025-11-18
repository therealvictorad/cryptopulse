import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistProvider extends ChangeNotifier {
  List<String> _watchlist = [];

  List<String> get watchlist => _watchlist;

  WatchlistProvider() {
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    _watchlist = prefs.getStringList('watchlist') ?? [];
    notifyListeners();
  }

  Future<void> toggleWatchlist(String coinId) async {
    final prefs = await SharedPreferences.getInstance();

    if (_watchlist.contains(coinId)) {
      _watchlist.remove(coinId);
    } else {
      _watchlist.add(coinId);
    }

    await prefs.setStringList('watchlist', _watchlist);
    notifyListeners();
  }

  bool isInWatchlist(String coinId) {
    return _watchlist.contains(coinId);
  }
}
