import 'package:flutter/material.dart';

// --- Écran de Sélection du Thème ---
class AppearanceScreen extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode)
      onThemeModeChanged; // Fonction pour changer le thème

  const AppearanceScreen({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        children: [
          // Option pour le mode Système
          RadioListTile<ThemeMode>(
            title: const Text('System Default'),
            subtitle: const Text('Follow device settings'),
            value:
                ThemeMode.system, // La valeur représentée par ce bouton radio
            groupValue: currentThemeMode, // La valeur actuellement sélectionnée
            onChanged: (ThemeMode? value) {
              // Appelé quand on clique
              if (value != null) {
                onThemeModeChanged(
                    value); // Appelle la fonction passée en paramètre
              }
            },
          ),
          // Option pour le mode Clair
          RadioListTile<ThemeMode>(
            title: const Text('Light Mode'),
            value: ThemeMode.light,
            groupValue: currentThemeMode,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                onThemeModeChanged(value);
              }
            },
          ),
          // Option pour le mode Sombre
          RadioListTile<ThemeMode>(
            title: const Text('Dark Mode'),
            value: ThemeMode.dark,
            groupValue: currentThemeMode,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                onThemeModeChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
