import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' show lerpDouble;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'profile_screen.dart';
import 'subscription_model.dart';
import 'add_subscription_screen.dart';
import 'edit_subscription_screen.dart';
import 'appearance_screen.dart';
import 'package:rxdart/rxdart.dart';

const String _themePrefsKey = 'appThemeMode';
const String _currencyPrefsKey = 'appCurrency';

enum Currency {
  EUR,
  USD,
  CAD;

  String formatAmount(double amount) {
    final formattedAmount = amount.toStringAsFixed(2);
    switch (this) {
      case Currency.EUR:
        return '$formattedAmount €';
      case Currency.USD:
        return '\$$formattedAmount';
      case Currency.CAD:
        return '$formattedAmount \$';
    }
  }

  String get name {
    switch (this) {
      case Currency.EUR:
        return 'Euro';
      case Currency.USD:
        return 'Dollar US';
      case Currency.CAD:
        return 'Dollar CA';
    }
  }
}

// =============================================================================
// MAIN FUNCTION
// =============================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AbonneezyApp());
}

// =============================================================================
// ROOT WIDGET (AbonneezyApp) - Stateful
// =============================================================================
class AbonneezyApp extends StatefulWidget {
  const AbonneezyApp({super.key});

  @override
  State<AbonneezyApp> createState() => _AbonneezyAppState();
}

class _AbonneezyAppState extends State<AbonneezyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Currency _currency = Currency.EUR;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _loadCurrency();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themePrefsKey) ?? 'system';
    if (mounted) {
      setState(() {
        _themeMode = _getThemeModeFromString(themeString);
      });
    }
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePrefsKey, _getStringFromThemeMode(mode));
  }

  void _changeThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      if (mounted) {
        setState(() {
          _themeMode = mode;
        });
      }
      _saveThemeMode(mode);
    }
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyString = prefs.getString(_currencyPrefsKey) ?? 'EUR';
    if (mounted) {
      setState(() {
        _currency = Currency.values.firstWhere(
          (c) => c.name == currencyString,
          orElse: () => Currency.EUR,
        );
      });
    }
  }

  Future<void> _saveCurrency(Currency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyPrefsKey, currency.name);
  }

  void _changeCurrency(Currency currency) {
    if (_currency != currency) {
      if (mounted) {
        setState(() {
          _currency = currency;
        });
      }
      _saveCurrency(currency);
    }
  }

  ThemeMode _getThemeModeFromString(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _getStringFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- Light Theme Definition ---
    final lightColorScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF3DBAA2),
        primary: const Color(0xFF3DBAA2),
        secondary: const Color(0xFFF9A826),
        brightness: Brightness.light,
        surface: Colors.white,
        onSurface: const Color(0xFF1F2937));
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
      ).apply(
          bodyColor: lightColorScheme.onSurface,
          displayColor: lightColorScheme.onSurface),
      appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.surface,
          foregroundColor: lightColorScheme.onSurface,
          elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style:
              TextButton.styleFrom(foregroundColor: lightColorScheme.primary)),
      cardTheme: CardTheme(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: EdgeInsets.zero,
          color: lightColorScheme.surface),
      dividerTheme: DividerThemeData(
          color: Colors.grey.shade200,
          thickness: 1,
          space: 0,
          indent: 16,
          endIndent: 16),
    );

    // --- Dark Theme Definition ---
    final darkColorScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF3DBAA2),
        primary: const Color(0xFF3DBAA2),
        secondary: const Color(0xFFF9A826),
        brightness: Brightness.dark);
    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
      ).apply(
          bodyColor: darkColorScheme.onSurface,
          displayColor: darkColorScheme.onSurface),
      appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.surface,
          foregroundColor: darkColorScheme.onSurface,
          elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style:
              TextButton.styleFrom(foregroundColor: darkColorScheme.primary)),
      cardTheme: CardTheme(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: EdgeInsets.zero,
          color: darkColorScheme.surfaceContainerHighest),
      dividerTheme: DividerThemeData(
          color: Colors.grey.shade700,
          thickness: 1,
          space: 0,
          indent: 16,
          endIndent: 16),
    );

    return MaterialApp(
      title: 'Abonneezy',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: DashboardScreen(
        currentThemeMode: _themeMode,
        onThemeModeChanged: _changeThemeMode,
        currentCurrency: _currency,
        onCurrencyChanged: _changeCurrency,
      ),
    );
  }
}

// =============================================================================
// DASHBOARD SCREEN - Stateful
// =============================================================================
class DashboardScreen extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeModeChanged;
  final Currency currentCurrency;
  final Function(Currency) onCurrencyChanged;
  const DashboardScreen({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    required this.currentCurrency,
    required this.onCurrencyChanged,
  }); // Added key
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Subscription> _subscriptions = [];
  bool _isLoading = true;
  double _monthlyTotal = 0;
  double _yearlyTotal = 0;
  double _lastMonthTotal = 0;
  double _savingsPercentage = 0.0;
  static const String _prefsKey = 'subscriptions';
  final String _filterBy = 'all';
  String _selectedFilter = 'Tous';

  // Cache pour les abonnements filtrés
  List<Subscription>? _filteredSubscriptionsCache;
  String? _lastFilter;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadSubscriptions();
  }

  @override
  void dispose() {
    super.dispose();
  } // No animation controller to dispose

  // --- Data Management Functions (Corrected Signatures if needed) ---
  Future<void> _loadSubscriptions() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final String? subscriptionsString = prefs.getString(_prefsKey);
    List<Subscription> loadedSubs = [];
    if (subscriptionsString != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(subscriptionsString);
        loadedSubs =
            decodedList.map((item) => Subscription.fromJson(item)).toList();
      } catch (e) {
        debugPrint("Erreur de décodage JSON: $e");
        await prefs.remove(_prefsKey);
      }
    }
    if (mounted) {
      setState(() {
        _subscriptions = loadedSubs;
        _calculateTotals();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> encodedList =
        _subscriptions.map((sub) => sub.toJson()).toList();
    final String subscriptionsString = jsonEncode(encodedList);
    await prefs.setString(_prefsKey, subscriptionsString);
    debugPrint("Abonnements sauvegardés !");
  }

  void _updateSubscriptionList({Subscription? toAdd, Subscription? toUpdate}) {
    if (!mounted) return;
    setState(() {
      if (toAdd != null) {
        _subscriptions.add(toAdd);
      }
      if (toUpdate != null) {
        final index = _subscriptions.indexWhere((sub) => sub.id == toUpdate.id);
        if (index != -1) {
          _subscriptions[index] = toUpdate;
        }
      }
      _subscriptions
          .sort((a, b) => a.nextRenewalDate.compareTo(b.nextRenewalDate));
      _calculateTotals();
    });
    _saveSubscriptions();
  }

  void _deleteSubscription(String id) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cet abonnement ?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            onPressed: () {
              if (mounted) {
                setState(() {
                  _subscriptions.removeWhere((sub) => sub.id == id);
                  _calculateTotals();
                });
                _saveSubscriptions();
              }
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Optimisation du calcul des totaux
  void _calculateTotals() {
    var monthlyTotal = 0.0;
    var yearlyTotal = 0.0;

    for (var sub in _subscriptions) {
      if (sub.frequency == 'Monthly') {
        monthlyTotal += sub.amount;
      } else if (sub.frequency == 'Yearly') {
        yearlyTotal += sub.amount / 12;
      }
    }

    setState(() {
      _monthlyTotal = monthlyTotal;
      _yearlyTotal = yearlyTotal;
      _lastMonthTotal = monthlyTotal;
      _savingsPercentage = yearlyTotal > 0 ? yearlyTotal / monthlyTotal : 0.0;
      // Réinitialiser le cache lors du recalcul
      _filteredSubscriptionsCache = null;
      _lastFilter = null;
    });
  }

  // Optimisation du filtrage des abonnements
  List<Subscription> _getFilteredSubscriptions() {
    // Utiliser le cache si le filtre n'a pas changé
    if (_filteredSubscriptionsCache != null && _lastFilter == _filterBy) {
      return _filteredSubscriptionsCache!;
    }

    final filtered = _filterBy == 'all'
        ? _subscriptions
        : _subscriptions.where((sub) => sub.frequency == _filterBy).toList();

    // Mettre à jour le cache
    _filteredSubscriptionsCache = filtered;
    _lastFilter = _filterBy;

    return filtered;
  }

  // --- Navigation Functions ---
  void _navigateToAddScreen() async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddSubscriptionScreen()));
    if (result != null && result is Subscription) {
      _updateSubscriptionList(toAdd: result);
    }
  }

  void _navigateToEditScreen(Subscription subscriptionToEdit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditSubscriptionScreen(existingSubscription: subscriptionToEdit)),
    );
    if (result != null && result is Subscription) {
      _updateSubscriptionList(toUpdate: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final filteredSubscriptions = _getFilteredSubscriptions();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Image.asset(
            'assets/images/logo.png',
            height: 28,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.all_inclusive, color: colorScheme.primary),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  currentThemeMode: widget.currentThemeMode,
                  onThemeModeChanged: widget.onThemeModeChanged,
                  currentCurrency: widget.currentCurrency,
                  onCurrencyChanged: widget.onCurrencyChanged,
                ),
              ),
            ),
            child: const Text('Profil'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(60, 30),
              ),
              child: const Text('Déconnexion'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddScreen,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: CustomScrollView(
        cacheExtent: 1000,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSummarySection(context),
                const SizedBox(height: 24),
                _buildFilterSection(context),
                const SizedBox(height: 16),
                Text(
                  'Vos abonnements',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
              ]),
            ),
          ),
          if (filteredSubscriptions.isEmpty)
            SliverToBoxAdapter(child: _buildEmptyState(context))
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList.builder(
                itemCount: filteredSubscriptions.length,
                itemBuilder: (context, index) {
                  final subscription = filteredSubscriptions[index];
                  return RepaintBoundary(
                    child: SubscriptionCard(
                      key: ValueKey(subscription.id),
                      subscription: subscription,
                      onEdit: () => _navigateToEditScreen(subscription),
                      onDelete: () => _deleteSubscription(subscription.id),
                      currency: widget.currentCurrency,
                    ),
                  );
                },
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: _buildMonthlyTotalSection(context),
            ),
          ),
          // Ajouter un espace en bas pour le FAB
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 80.0),
            sliver: SliverToBoxAdapter(child: SizedBox()),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final totalSpending = _monthlyTotal + _yearlyTotal;
    final potentialSavings = totalSpending * 0.2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Économies potentielles',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: potentialSavings / totalSpending,
                    child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dépenses actuelles',
                      style: textTheme.bodySmall,
                    ),
                    Text(
                      widget.currentCurrency.formatAmount(totalSpending),
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Économies possibles',
                      style: textTheme.bodySmall,
                    ),
                    Text(
                      widget.currentCurrency.formatAmount(potentialSavings),
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyTotalSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Total mensuel',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Abonnements mensuels',
                      style: textTheme.bodySmall,
                    ),
                    Text(
                      widget.currentCurrency.formatAmount(_monthlyTotal),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Abonnements annuels',
                      style: textTheme.bodySmall,
                    ),
                    Text(
                      widget.currentCurrency.formatAmount(_yearlyTotal),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(context, 'Tous'),
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Streaming'),
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Cloud'),
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Musique'),
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Jeux'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    return FilterChip(
      selected: _selectedFilter == label,
      label: Text(label),
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = label;
          // Réinitialiser le cache lors du changement de filtre
          _filteredSubscriptionsCache = null;
          _lastFilter = null;
        });
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          children: [
            Icon(
              Icons.subscriptions_outlined,
              size: 48,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              "Aucun abonnement",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Ajoutez votre premier abonnement pour commencer le suivi",
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// WIDGET RÉUTILISABLE SummaryCard
// =============================================================================
class SummaryCard extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String amount;
  final Color titleColor;
  final Color amountColor;
  final double amountSize;
  const SummaryCard(
      {super.key,
      required this.backgroundColor,
      required this.title,
      required this.amount,
      this.titleColor = Colors.white,
      this.amountColor = Colors.white,
      this.amountSize = 36.0});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: textTheme.bodyMedium?.copyWith(color: titleColor)),
            const SizedBox(height: 8),
            Text(amount,
                style: textTheme.headlineMedium?.copyWith(
                    fontFamily: 'Poppins',
                    color: amountColor,
                    fontSize: amountSize)),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SAVINGS CARD WIDGET
// =============================================================================
class SavingsCard extends StatefulWidget {
  final double currentSpending;
  final double potentialSavings;

  const SavingsCard({
    super.key,
    required this.currentSpending,
    required this.potentialSavings,
  });

  @override
  State<SavingsCard> createState() => _SavingsCardState();
}

class _SavingsCardState extends State<SavingsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final percent = widget.currentSpending > 0
        ? (widget.potentialSavings / widget.currentSpending).clamp(0.0, 1.0)
        : 0.0;

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: percent,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\$${widget.potentialSavings.toStringAsFixed(2)}',
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Économies potentielles par mois',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 179),
          ),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: colorScheme.secondary,
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dépenses actuelles',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 179),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${widget.currentSpending.toStringAsFixed(2)}/mois',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Après économies',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 179),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${(widget.currentSpending - widget.potentialSavings).toStringAsFixed(2)}/mois',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// Widget pour afficher une carte d'abonnement
class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Currency currency;

  const SubscriptionCard({
    Key? key,
    required this.subscription,
    required this.onEdit,
    required this.onDelete,
    required this.currency,
  }) : super(key: key);

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'divertissement':
        return Icons.movie_outlined;
      case 'musique':
        return Icons.music_note_outlined;
      case 'jeux':
        return Icons.sports_esports_outlined;
      case 'productivité':
        return Icons.work_outline;
      case 'stockage cloud':
        return Icons.cloud_outlined;
      case 'santé et fitness':
        return Icons.fitness_center_outlined;
      case 'éducation':
        return Icons.school_outlined;
      case 'actualités et médias':
        return Icons.article_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Color _getRenewalColor(DateTime renewalDate) {
    final daysUntilRenewal = renewalDate.difference(DateTime.now()).inDays;
    if (daysUntilRenewal <= 3) return Colors.red;
    if (daysUntilRenewal <= 7) return Colors.orange;
    return Colors.green;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) return "Aujourd'hui";
    if (difference == 1) return "Demain";
    if (difference < 7) return "Dans $difference jours";

    return date.toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final renewalColor = _getRenewalColor(subscription.nextRenewalDate);
    final daysUntilRenewal =
        subscription.nextRenewalDate.difference(DateTime.now()).inDays;

    return Dismissible(
      key: Key(subscription.id),
      background: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: Icon(
          Icons.edit_outlined,
          color: colorScheme.primary,
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(
          Icons.delete_outline,
          color: Colors.red.shade700,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          onDelete();
          return false;
        } else if (direction == DismissDirection.startToEnd) {
          onEdit();
          return false;
        }
        return false;
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 26),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(subscription.category),
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  if (daysUntilRenewal <= 7)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.white,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: renewalColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Contenu principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        subscription.frequency == 'Monthly'
                            ? 'Mensuel'
                            : subscription.frequency,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.event,
                          size: 14,
                          color: renewalColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Prochain : ${_formatDate(subscription.nextRenewalDate)}',
                          style: textTheme.bodySmall?.copyWith(
                            color: renewalColor,
                          ),
                        ),
                        if (daysUntilRenewal <= 3)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.notifications_active,
                              size: 14,
                              color: renewalColor,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Prix à droite
              SizedBox(
                width: 120,
                child: Text(
                  '${currency.formatAmount(subscription.amount)}',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
