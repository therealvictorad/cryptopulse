import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:cryptopulse/providers/currency_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    List<String> currencies = ['USD', 'NGN', 'EUR', 'GBP'];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Dark / Light mode toggle
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.isDarkMode,
            onChanged: (val) {
              themeProvider.toggleTheme();
            },
            secondary: Icon(
              themeProvider.isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),

          const Divider(),

          // Currency selector
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Currency'),
            trailing: DropdownButton<String>(
              value: currencyProvider.selectedCurrency,
              items: currencies
                  .map((currency) =>
                  DropdownMenuItem(value: currency, child: Text(currency)))
                  .toList(),
              onChanged: (val) {
                if (val != null) currencyProvider.changeCurrency(val);
              },
            ),
          ),

          const Divider(),

          // About section
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('CryptoPulse v1.0\nCredits: Victor Adesina'),
          ),

          const Divider(),

          // Privacy Policy
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Placeholder for now, open webpage or dialog later
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Privacy Policy'),
                  content: const Text(
                      'placeholder for privacy policy.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
