import 'package:flutter/material.dart';
import 'main.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeModeChanged;
  final Currency currentCurrency;
  final Function(Currency) onCurrencyChanged;

  const SettingsScreen({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    required this.currentCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
            context,
            title: 'Apparence',
            children: [
              _buildThemeSelector(context),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: 'Devise',
            children: [
              _buildCurrencySelector(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('Système'),
          value: ThemeMode.system,
          groupValue: currentThemeMode,
          onChanged: (ThemeMode? value) {
            if (value != null) onThemeModeChanged(value);
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Clair'),
          value: ThemeMode.light,
          groupValue: currentThemeMode,
          onChanged: (ThemeMode? value) {
            if (value != null) onThemeModeChanged(value);
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Sombre'),
          value: ThemeMode.dark,
          groupValue: currentThemeMode,
          onChanged: (ThemeMode? value) {
            if (value != null) onThemeModeChanged(value);
          },
        ),
      ],
    );
  }

  Widget _buildCurrencySelector(BuildContext context) {
    return Column(
      children: [
        RadioListTile<Currency>(
          title: Text('Euro (€)'),
          subtitle: const Text('Zone Euro'),
          value: Currency.EUR,
          groupValue: currentCurrency,
          onChanged: (Currency? value) {
            if (value != null) onCurrencyChanged(value);
          },
        ),
        RadioListTile<Currency>(
          title: Text('Dollar US (\$)'),
          subtitle: const Text('États-Unis'),
          value: Currency.USD,
          groupValue: currentCurrency,
          onChanged: (Currency? value) {
            if (value != null) onCurrencyChanged(value);
          },
        ),
        RadioListTile<Currency>(
          title: Text('Dollar CA (\$)'),
          subtitle: const Text('Canada'),
          value: Currency.CAD,
          groupValue: currentCurrency,
          onChanged: (Currency? value) {
            if (value != null) onCurrencyChanged(value);
          },
        ),
      ],
    );
  }
}
