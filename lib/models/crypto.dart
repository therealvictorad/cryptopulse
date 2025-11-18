class Crypto {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCap;
  final double totalVolume;
  final double circulatingSupply;
  final List<double> sparklineIn7d;
  final List<double> sparklineIn30d;
  final List<double> sparklineIn90d;

  Crypto({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
    required this.circulatingSupply,
    this.sparklineIn7d = const [],
    this.sparklineIn30d = const [],
    this.sparklineIn90d = const [],
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'] ?? 'unknown',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? 'Unknown',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChange24h: (json['price_change_24h'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      totalVolume: (json['total_volume'] ?? 0).toDouble(),
      circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
      sparklineIn7d: json['sparkline_in_7d']?['price'] != null
          ? List<double>.from(json['sparkline_in_7d']['price'].map((e) => (e ?? 0).toDouble()))
          : [],
      sparklineIn30d: json['sparkline_in_30d']?['price'] != null
          ? List<double>.from(json['sparkline_in_30d']['price'].map((e) => (e ?? 0).toDouble()))
          : [],
      sparklineIn90d: json['sparkline_in_90d']?['price'] != null
          ? List<double>.from(json['sparkline_in_90d']['price'].map((e) => (e ?? 0).toDouble()))
          : [],
    );
  }
}
