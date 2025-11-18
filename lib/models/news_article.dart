class NewsArticle {
  final String title;
  final String source;
  final String url; // link to the full article
  final String urlToImage; // image for the article
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    required this.source,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No title',
      source: json['source'] ?? 'Unknown',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
