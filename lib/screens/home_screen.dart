import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../services/crypto_api.dart';
import '../models/crypto.dart';
import '../providers/watchlist_provider.dart';
import '../providers/news_provider.dart';
import 'crypto_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Crypto> cryptos = [];
  List<Crypto> filteredCryptos = [];
  bool isLoading = true;
  bool sortByGainers = true;

  @override
  void initState() {
    super.initState();
    _fetchCryptos();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.fetchGeneralNews();
  }

  Future<void> _fetchCryptos() async {
    setState(() => isLoading = true);

    // Fetch raw data from API
    final rawData = await CryptoApi().fetchCryptosRaw();

    // Parse into Crypto objects with sparkline
    cryptos = rawData.map((json) => Crypto.fromJson(json)).toList();
    filteredCryptos = List.from(cryptos);
    _sortCryptos();

    setState(() => isLoading = false);
  }

  void _sortCryptos() {
    filteredCryptos.sort((a, b) =>
    sortByGainers
        ? b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h)
        : a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h));
  }

  void _filterCryptos(String query) {
    setState(() {
      filteredCryptos = cryptos
          .where((coin) =>
      coin.name.toLowerCase().contains(query.toLowerCase()) ||
          coin.symbol.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _sortCryptos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.currency_bitcoin),
        actions: [
          IconButton(
            icon: Icon(sortByGainers ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                sortByGainers = !sortByGainers;
                _sortCryptos();
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              onChanged: _filterCryptos,
              decoration: InputDecoration(
                hintText: 'Search coin...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 6,
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Card(
              child: ListTile(
                leading: Container(width: 40, height: 40, color: Colors.white),
                title: Container(width: double.infinity, height: 16, color: Colors.white),
                subtitle: Container(width: 80, height: 14, color: Colors.white),
              ),
            ),
          ))
          : RefreshIndicator(
        onRefresh: _fetchCryptos,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: filteredCryptos.map((coin) {
            final isInWatchlist = watchlistProvider.watchlist.contains(coin.id);

            return Card(
              child: ListTile(
                leading: Image.network(coin.image, width: 40),
                title: Text(coin.name),
                subtitle: Text(coin.symbol.toUpperCase()),
                trailing: IconButton(
                  icon: Icon(isInWatchlist ? Icons.star : Icons.star_border,
                      color: Colors.yellow),
                  onPressed: () => watchlistProvider.toggleWatchlist(coin.id),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CryptoDetailScreen(coin: coin),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
