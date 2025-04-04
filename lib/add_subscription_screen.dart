import 'package:flutter/material.dart';
import 'package:abonneezy/subscription_model.dart'; // Assure-toi que le chemin est correct si tu as des sous-dossiers

// --- Écran pour Ajouter un Nouvel Abonnement ---
class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedFrequency = 'Monthly';
  DateTime? _selectedDate;
  bool _isPotentiallyCancellable = false;
  String _selectedCategory = 'Other';
  final List<String> _frequencyOptions = [
    'Monthly',
    'Yearly',
    'Weekly',
    'Other'
  ];
  bool _showDateError =
      false; // Pour afficher l'erreur de date après validation

  // --- Début Fonction _selectDate ---
  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.primary,
              onPrimary: colorScheme.onPrimary,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _showDateError = false;
      });
    }
  }
  // --- Fin Fonction _selectDate ---

  // --- Début Fonction dispose ---
  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  // --- Fin Fonction dispose ---

  // --- Début Fonction _saveForm ---
  void _saveForm() {
    // Valide les champs TextFormField
    final isFormValid = _formKey.currentState!.validate();
    // Vérifie si la date est sélectionnée
    final isDateSelected = _selectedDate != null;

    // Met à jour l'état pour afficher l'erreur de date si nécessaire
    if (!isDateSelected) {
      setState(() {
        _showDateError = true;
      });
    }

    // Si le formulaire ET la date sont valides
    if (isFormValid && isDateSelected) {
      // Crée un nouvel objet Subscription
      final newSubscription = Subscription(
        // Génère un ID unique basé sur l'heure actuelle (simple placeholder)
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        // Tente de convertir le montant en double, sinon met 0.0
        amount: double.tryParse(_amountController.text) ?? 0.0,
        // Utilise la fréquence sélectionnée (ou 'Other' par défaut si null)
        frequency: _selectedFrequency ?? 'Other',
        // Utilise la date sélectionnée (on sait qu'elle n'est pas null ici)
        nextRenewalDate: _selectedDate!,
        isPotentiallyCancellable: _isPotentiallyCancellable,
        category: _selectedCategory,
      );

      // Renvoie le nouvel objet à l'écran précédent
      Navigator.pop(context, newSubscription);
    }
  }
  // --- Fin Fonction _saveForm ---

  // --- Début Fonction build ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Subscription'),
        actions: [
          // Bouton pour sauvegarder
          IconButton(
            icon: const Icon(Icons.save),
            // Appelle notre nouvelle fonction _saveForm
            onPressed: _saveForm,
          )
        ],
      ),
      // Corps avec un formulaire
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Champ Nom ---
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Subscription Name',
                    hintText: 'e.g., Netflix, Spotify',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // --- Champ Montant ---
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'e.g., 15.99',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // --- Sélecteur de Fréquence ---
                DropdownButtonFormField<String>(
                  value: _selectedFrequency,
                  decoration: const InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(),
                  ),
                  items: _frequencyOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFrequency = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a frequency' : null,
                ),
                const SizedBox(height: 20),

                // --- Sélecteur de Catégorie ---
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: Subscription.categories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),

                // --- Switch pour Potentially Cancellable ---
                SwitchListTile(
                  title: const Text('Potentially Cancellable'),
                  subtitle: const Text(
                      'Mark this subscription as potentially cancellable to track potential savings'),
                  value: _isPotentiallyCancellable,
                  onChanged: (bool value) {
                    setState(() {
                      _isPotentiallyCancellable = value;
                    });
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                ),

                // --- Sélecteur de Date ---
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _showDateError
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      _selectedDate == null
                          ? 'Select Next Renewal Date'
                          : 'Next Renewal: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: TextStyle(
                        color: _selectedDate == null
                            ? Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6)
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    trailing: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
                if (_showDateError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                    child: Text(
                      'Please select a date',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // --- Fin Fonction build ---
}
// --- Fin Classe _AddSubscriptionScreenState ---
