import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptopulse/providers/theme_provider.dart';
import 'package:cryptopulse/providers/currency_provider.dart';
import 'package:cryptopulse/screens/main_tabs.dart';
import 'providers/news_provider.dart';
import 'services/news_api.dart';
import 'providers/watchlist_provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => CurrencyProvider()),
          ChangeNotifierProvider(create: (_) => NewsProvider(newsApi: NewsApi())),
          ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CryptoPulse',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainTabs(),
        );
      },
    );
  }
}
