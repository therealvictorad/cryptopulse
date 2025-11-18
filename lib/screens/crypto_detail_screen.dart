import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/crypto.dart';
import '../providers/watchlist_provider.dart';
import '../providers/news_provider.dart';

class CryptoDetailScreen extends StatefulWidget {
  final Crypto coin;

  const CryptoDetailScreen({super.key, required this.coin});

  @override
  State<CryptoDetailScreen> createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends State<CryptoDetailScreen> {
  String selectedTimeframe = '7d';
  List<double> chartPrices = [];

  @override
  void initState() {
    super.initState();
    _loadChartData();

    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.fetchCoinNews(widget.coin.symbol);
  }

  void _loadChartData() {
    chartPrices = widget.coin.sparklineIn7d.isNotEmpty
        ? widget.coin.sparklineIn7d
        : [widget.coin.currentPrice];
  }

  void _changeTimeframe(String timeframe) {
    setState(() {
      selectedTimeframe = timeframe;
      switch (timeframe) {
        case '7d':
          chartPrices = widget.coin.sparklineIn7d.isNotEmpty
              ? widget.coin.sparklineIn7d
              : [widget.coin.currentPrice];
          break;
        case '30d':
          chartPrices = widget.coin.sparklineIn30d.isNotEmpty
              ? widget.coin.sparklineIn30d
              : [widget.coin.currentPrice];
          break;
        case '90d':
          chartPrices = widget.coin.sparklineIn90d.isNotEmpty
              ? widget.coin.sparklineIn90d
              : [widget.coin.currentPrice];
          break;
        default:
          chartPrices = widget.coin.sparklineIn7d.isNotEmpty
              ? widget.coin.sparklineIn7d
              : [widget.coin.currentPrice];
      }
    });
  }

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    final isInWatchlist = watchlistProvider.watchlist.contains(widget.coin.id);
    final coin = widget.coin;

    final priceChange = coin.priceChange24h;
    final priceChangePercentage = coin.priceChangePercentage24h;

    final newsProvider = Provider.of<NewsProvider>(context);
    final isLoadingNews = newsProvider.isLoadingForCoin(widget.coin.symbol);
    final articles = newsProvider.getCoinNews(widget.coin.symbol);

    return Scaffold(
      appBar: AppBar(
        title: Text(coin.name),
        actions: [
          IconButton(
            icon: Icon(
              isInWatchlist ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
            onPressed: () => watchlistProvider.toggleWatchlist(coin.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Chart + overlay
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: chartPrices
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                                  .toList(),
                              isCurved: true,
                              color: priceChange >= 0 ? Colors.green : Colors.red,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: (priceChange >= 0 ? Colors.green : Colors.red).withValues(alpha: 0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coin.symbol.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${coin.currentPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${priceChange >= 0 ? '+' : ''}${priceChange.toStringAsFixed(2)} '
                              '(${priceChangePercentage >= 0 ? '+' : ''}${priceChangePercentage.toStringAsFixed(2)}%)',
                          style: TextStyle(
                            fontSize: 18,
                            color: priceChange >= 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Timeframe Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['7d', '30d', '90d'].map((tf) {
                final isSelected = tf == selectedTimeframe;
                return GestureDetector(
                  onTap: () => _changeTimeframe(tf),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary : theme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Text(
                      tf,
                      style: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Quick Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard('Market Cap', '\$${coin.marketCap}', theme),
                  _buildStatCard('Volume', '\$${coin.totalVolume}', theme),
                  _buildStatCard('Circulating', '${coin.circulatingSupply}', theme),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // News Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'News',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyMedium?.color),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: isLoadingNews
                  ? const Center(child: CircularProgressIndicator())
                  : articles.isEmpty
                  ? Center(
                child: Text(
                  'No news available for this coin.',
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                ),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Card(
                    color: theme.cardColor,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: SizedBox(
                      width: 200,
                      child: Row(
                        children: [
                          if (article.urlToImage.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                article.urlToImage,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  article.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: theme.textTheme.bodyMedium?.color),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  article.source,
                                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                                ),
                                Text(
                                  timeAgo(article.publishedAt),
                                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, ThemeData theme) {
    return Expanded(
      child: Card(
        color: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 14, color: theme.hintColor)),
              const SizedBox(height: 8),
              Text(value,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyMedium?.color)),
            ],
          ),
        ),
      ),
    );
  }
}
