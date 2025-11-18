import 'package:flutter/material.dart';

class CurrencyProvider with ChangeNotifier {
  String _selectedCurrency = 'USD';

  String get selectedCurrency => _selectedCurrency;

  void changeCurrency(String newCurrency) {
    _selectedCurrency = newCurrency;
    notifyListeners();
  }
}
