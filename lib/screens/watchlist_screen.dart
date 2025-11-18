import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/currency_provider.dart';
import '../services/crypto_api.dart';
import '../models/crypto.dart';
import 'crypto_detail_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<Crypto> allCoins = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    allCoins = await CryptoApi().fetchCryptos();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final watchlist = Provider.of<WatchlistProvider>(context).watchlist;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    final isDark = themeProvider.isDarkMode;
    final currency = currencyProvider.selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchlist"),
        backgroundColor: isDark ? Colors.grey[900] : null,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : watchlist.isEmpty
          ? const Center(
        child: Text(
          "Your watchlist is empty.\nAdd some coins ⭐",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: watchlist.length,
        itemBuilder: (context, index) {
          final coinId = watchlist[index];
          final coin = allCoins.firstWhere(
                (c) => c.id == coinId,
            orElse: () => Crypto(
              id: coinId,
              symbol: "",
              name: "Unknown",
              image: "",
              currentPrice: 0,
              priceChange24h: 0,
              priceChangePercentage24h: 0,
              marketCap: 0,
              totalVolume: 0,
              circulatingSupply: 0,
              sparklineIn7d: [],
            ),
          );

          return Card(
            color: isDark ? Colors.grey[850] : Colors.white,
            margin: const EdgeInsets.symmetric(
                vertical: 6, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: coin.image.isNotEmpty
                  ? Image.network(coin.image, width: 40)
                  : const Icon(Icons.currency_bitcoin),
              title: Text(
                coin.name,
                style:
                TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              subtitle: Text(
                '${coin.symbol.toUpperCase()} • $currency ${coin.currentPrice.toStringAsFixed(2)}',
                style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[800]),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.star, color: Colors.yellow),
                onPressed: () {
                  Provider.of<WatchlistProvider>(context,
                      listen: false)
                      .toggleWatchlist(coin.id);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CryptoDetailScreen(coin: coin),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
