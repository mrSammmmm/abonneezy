import 'package:flutter/material.dart';
import 'package:abonneezy/subscription_model.dart'; // Assure-toi d'avoir ce chemin correct

// --- Écran pour Modifier un Abonnement Existant ---
class EditSubscriptionScreen extends StatefulWidget {
  // Reçoit l'abonnement à modifier lors de la navigation
  final Subscription existingSubscription;

  const EditSubscriptionScreen({
    super.key,
    required this.existingSubscription, // Paramètre requis
  });

  @override
  State<EditSubscriptionScreen> createState() => _EditSubscriptionScreenState();
}

class _EditSubscriptionScreenState extends State<EditSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  // Initialise les contrôleurs avec les valeurs existantes
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  String? _selectedFrequency;
  DateTime? _selectedDate;
  bool _isPotentiallyCancellable = false;
  String _selectedCategory = 'Other';

  // Même liste d'options que pour l'ajout
  final List<String> _frequencyOptions = [
    'Monthly',
    'Yearly',
    'Weekly',
    'Other'
  ];
  bool _showDateError = false;

  // --- Début Fonction initState ---
  // Initialise l'état avec les données de l'abonnement passé en paramètre
  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingSubscription.name);
    _amountController = TextEditingController(
        text: widget.existingSubscription.amount
            .toStringAsFixed(2)); // Format montant
    _selectedFrequency = widget.existingSubscription.frequency;
    // Assure-toi que la fréquence existe dans les options, sinon utilise 'Other'
    if (!_frequencyOptions.contains(_selectedFrequency)) {
      _selectedFrequency = 'Other';
    }
    _selectedDate = widget.existingSubscription.nextRenewalDate;
    _isPotentiallyCancellable =
        widget.existingSubscription.isPotentiallyCancellable;
    _selectedCategory = widget.existingSubscription.category;
  }
  // --- Fin Fonction initState ---

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
    // Nettoie les contrôleurs
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  // --- Fin Fonction dispose ---

  // --- Début Fonction _saveForm ---
  void _saveForm() {
    final isFormValid = _formKey.currentState!.validate();
    final isDateSelected = _selectedDate != null;
    if (!isDateSelected) {
      setState(() {
        _showDateError = true;
      });
    }

    if (isFormValid && isDateSelected) {
      // Crée un NOUVEL objet Subscription avec les données modifiées
      // MAIS conserve l'ID d'origine !
      final updatedSubscription = Subscription(
        id: widget.existingSubscription.id,
        name: _nameController.text,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        frequency: _selectedFrequency ?? 'Other',
        nextRenewalDate: _selectedDate!,
        isPotentiallyCancellable: _isPotentiallyCancellable,
        category: _selectedCategory,
      );
      // Renvoie l'objet MIS À JOUR à l'écran précédent
      Navigator.pop(context, updatedSubscription);
    }
  }
  // --- Fin Fonction _saveForm ---

  // --- Début Fonction build ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Titre indiquant qu'on modifie
        title: Text(
            'Edit ${widget.existingSubscription.name}'), // Utilise le nom original dans le titre
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm, // Appelle la même logique de sauvegarde
          )
        ],
      ),
      // Le reste du formulaire est presque identique à l'écran d'ajout
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Champ Nom --- (Pré-rempli grâce au contrôleur)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Subscription Name',
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // --- Champ Montant --- (Pré-rempli)
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '\$ ',
                      border: OutlineInputBorder()),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                // --- Sélecteur de Fréquence --- (Pré-rempli)
                DropdownButtonFormField<String>(
                  value: _selectedFrequency,
                  decoration: const InputDecoration(
                      labelText: 'Frequency', border: OutlineInputBorder()),
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
// --- Fin Classe _EditSubscriptionScreenState ---
