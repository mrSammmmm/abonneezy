import 'package:flutter/material.dart';
import 'main.dart';

class CurrencyScreen extends StatelessWidget {
  final Currency currentCurrency;
  final Function(Currency) onCurrencyChanged;

  const CurrencyScreen({
    super.key,
    required this.currentCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devise'),
      ),
      body: ListView(
        children: Currency.values.map((currency) {
          return RadioListTile<Currency>(
            title: Text(currency.name),
            value: currency,
            groupValue: currentCurrency,
            onChanged: (Currency? value) {
              if (value != null) {
                onCurrencyChanged(value);
                Navigator.pop(context);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
