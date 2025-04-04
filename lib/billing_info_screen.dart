import 'package:flutter/material.dart';

// --- Écran Informations de Facturation ---
class BillingInfoScreen extends StatelessWidget {
  const BillingInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Billing Information')),
      body: ListView(
        // ListView pour le contenu potentiellement long
        padding: const EdgeInsets.all(20.0),
        children: [
          // --- Section Plan Actuel ---
          Card(
            // Utilise une carte pour encadrer cette section
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.grey.shade200)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Plan',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // TODO: Remplacer par les vraies informations du plan
                  const Text('Premium Plan',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('\$4.99 / month'),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Naviguer vers la page de gestion externe ou interne
                        print('Manage Subscription cliqué');
                      },
                      child: const Text('Manage Subscription'),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // --- Section Historique de Facturation ---
          Text('Invoice History',
              style: textTheme.titleLarge?.copyWith(fontFamily: 'Poppins')),
          const SizedBox(height: 10),
          const Divider(),

          // --- Liste des Factures (Placeholders) ---
          // Pour une vraie application, on utiliserait ListView.builder avec de vraies données
          _buildInvoiceItem(context,
              date: 'May 1, 2024', amount: '\$4.99', status: 'Paid'),
          const Divider(),
          _buildInvoiceItem(context,
              date: 'April 1, 2024', amount: '\$4.99', status: 'Paid'),
          const Divider(),
          _buildInvoiceItem(context,
              date: 'March 1, 2024', amount: '\$4.99', status: 'Paid'),
          const Divider(),
          // Ajoutez d'autres items si vous voulez
        ],
      ),
    );
  }

  // --- Helper Widget pour une ligne de facture ---
  Widget _buildInvoiceItem(BuildContext context,
      {required String date, required String amount, required String status}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      title: Text('Invoice - $date',
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
      subtitle: Text('Amount: $amount'),
      trailing: Row(
        // Pour afficher le statut et une icône de téléchargement
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            // Utilise un Chip pour le statut
            label: Text(status),
            labelStyle: TextStyle(
                fontSize: 12,
                color: status == 'Paid'
                    ? Colors.green.shade800
                    : Colors.orange.shade800),
            backgroundColor: status == 'Paid'
                ? Colors.green.shade100
                : Colors.orange.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          IconButton(
            // Icône pour télécharger (non fonctionnelle)
            icon: Icon(Icons.download_for_offline_outlined,
                color: colorScheme.primary),
            onPressed: () {
              print('Télécharger facture du $date');
              // TODO: Implémenter le téléchargement de la facture
            },
            tooltip: 'Download Invoice',
          )
        ],
      ),
    );
  }
}
