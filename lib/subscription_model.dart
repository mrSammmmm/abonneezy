// lib/subscription_model.dart
import 'dart:convert'; // Nécessaire pour jsonEncode/Decode si tu l'utilises ici
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Subscription {
  final String id;
  final String name;
  final double amount;
  final String frequency;
  final DateTime nextRenewalDate;
  final bool isPotentiallyCancellable;
  final String category;

  static const List<String> categories = [
    'Entertainment',
    'Music',
    'Gaming',
    'Productivity',
    'Cloud Storage',
    'Health & Fitness',
    'Education',
    'News & Media',
    'Shopping',
    'Other'
  ];

  Subscription({
    required this.id,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.nextRenewalDate,
    this.isPotentiallyCancellable = false,
    this.category = 'Other',
  });

  // --- MÉTHODE POUR CONVERTIR EN JSON (Map) ---
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'amount': amount,
        'frequency': frequency,
        // Sauvegarde la date comme une chaîne ISO 8601 (standard)
        'nextRenewalDate': nextRenewalDate.toIso8601String(),
        'isPotentiallyCancellable': isPotentiallyCancellable,
        'category': category,
      };

  // --- MÉTHODE POUR CRÉER DEPUIS JSON (Map) ---
  // 'factory' est un type spécial de constructeur
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(), // Conversion sûre en double
      frequency: json['frequency'] as String,
      // Parse la chaîne ISO 8601 pour recréer l'objet DateTime
      nextRenewalDate: DateTime.parse(json['nextRenewalDate'] as String),
      isPotentiallyCancellable:
          json['isPotentiallyCancellable'] as bool? ?? false,
      category: json['category'] as String? ?? 'Other',
    );
  }
}

class SubscriptionModel extends ChangeNotifier {
  List<Subscription> _subscriptions = [];
  static const String _storageKey = 'subscriptions';

  List<Subscription> get subscriptions => List.unmodifiable(_subscriptions);

  SubscriptionModel() {
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? subscriptionsJson = prefs.getString(_storageKey);

    if (subscriptionsJson != null) {
      final List<dynamic> decoded = jsonDecode(subscriptionsJson);
      _subscriptions =
          decoded.map((item) => Subscription.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
        jsonEncode(_subscriptions.map((s) => s.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> addSubscription(Subscription subscription) async {
    _subscriptions.add(subscription);
    await _saveSubscriptions();
    notifyListeners();
  }

  Future<void> updateSubscription(
      Subscription oldSubscription, Subscription newSubscription) async {
    final index =
        _subscriptions.indexWhere((s) => s.name == oldSubscription.name);
    if (index != -1) {
      _subscriptions[index] = newSubscription;
      await _saveSubscriptions();
      notifyListeners();
    }

    Future<void> deleteSubscription(Subscription subscription) async {
      _subscriptions.removeWhere((s) => s.name == subscription.name);
      await _saveSubscriptions();
      notifyListeners();
    }
  }

  double get totalMonthlyAmount {
    return _subscriptions.fold(0, (total, subscription) {
      if (subscription.frequency == 'Monthly') {
        return total + subscription.amount;
      } else if (subscription.frequency == 'Yearly') {
        return total + (subscription.amount / 12);
      }
      return total;
    });
  }

  double get totalYearlyAmount {
    return _subscriptions.fold(0, (total, subscription) {
      if (subscription.frequency == 'Monthly') {
        return total + (subscription.amount * 12);
      } else if (subscription.frequency == 'Yearly') {
        return total + subscription.amount;
      }
      return total;
    });
  }

  List<Subscription> getSubscriptionsByCategory(String category) {
    return _subscriptions.where((sub) => sub.category == category).toList();
  }

  double getTotalAmountByCategory(String category) {
    return getSubscriptionsByCategory(category).fold(0, (total, subscription) {
      if (subscription.frequency == 'Monthly') {
        return total + subscription.amount;
      } else if (subscription.frequency == 'Yearly') {
        return total + (subscription.amount / 12);
      }
      return total;
    });
  }
}
