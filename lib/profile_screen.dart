import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abonneezy/appearance_screen.dart';
import 'package:abonneezy/currency_screen.dart';
import 'main.dart';

// --- Écran de Profil ---
class ProfileScreen extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeModeChanged;
  final Currency currentCurrency;
  final Function(Currency) onCurrencyChanged;

  const ProfileScreen({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    required this.currentCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section Avatar et Nom
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // TODO: Implémenter le changement de photo
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Sam The User',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'sam.the.user@email.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSection(
            context,
            title: 'Compte',
            children: [
              _buildProfileOption(
                context: context,
                icon: Icons.palette_outlined,
                title: 'Apparence',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppearanceScreen(
                      currentThemeMode: currentThemeMode,
                      onThemeModeChanged: onThemeModeChanged,
                    ),
                  ),
                ),
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.currency_exchange,
                title: 'Devise',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CurrencyScreen(
                      currentCurrency: currentCurrency,
                      onCurrencyChanged: onCurrencyChanged,
                    ),
                  ),
                ),
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.lock_outline,
                title: 'Changer le mot de passe',
                onTap: () {
                  // TODO: Implémenter le changement de mot de passe
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: 'Aide & Support',
            children: [
              _buildProfileOption(
                context: context,
                icon: Icons.help_outline,
                title: 'Centre d\'aide',
                onTap: () {
                  // TODO: Implémenter le centre d'aide
                },
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.logout,
                title: 'Déconnexion',
                color: Colors.red,
                onTap: () {
                  // TODO: Implémenter la déconnexion
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
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

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
} // <<<=== FIN DE LA CLASSE ProfileScreen ===>>>
