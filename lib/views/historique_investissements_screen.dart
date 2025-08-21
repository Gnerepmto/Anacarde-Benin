import 'package:flutter/material.dart';
import '../views/colors/app_colors.dart';
import '../models/investissement_model.dart';

/// Écran d'historique des investissements
class HistoriqueInvestissementsScreen extends StatefulWidget {
  const HistoriqueInvestissementsScreen({super.key});

  @override
  State<HistoriqueInvestissementsScreen> createState() =>
      _HistoriqueInvestissementsScreenState();
}

class _HistoriqueInvestissementsScreenState
    extends State<HistoriqueInvestissementsScreen> {
  String _selectedStatus = 'Tous';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mes Investissements',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.secondary),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _buildFilterChip('Statut', _selectedStatus)),
              ],
            ),
          ),

          // Liste des investissements
          Expanded(child: _buildInvestissementsList()),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return InkWell(
      onTap: _showStatusFilter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Text(
              '$label: $value',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestissementsList() {
    // Simuler des données d'investissements
    final investissements = _getMockInvestissements();

    if (investissements.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_up_outlined,
              size: 80,
              color: AppColors.textLight,
            ),
            SizedBox(height: 24),
            Text(
              'Aucun investissement',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Vous n\'avez pas encore effectué d\'investissements',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: investissements.length,
      itemBuilder: (context, index) {
        final investissement = investissements[index];
        return _buildInvestissementCard(investissement);
      },
    );
  }

  Widget _buildInvestissementCard(InvestissementModel investissement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: AppColors.shadowLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Naviguer vers le détail de l'investissement
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec titre et statut
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          investissement.productionTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Producteur: ${investissement.investisseurName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(investissement.status),
                ],
              ),

              const SizedBox(height: 16),

              // Informations de l'investissement
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.attach_money,
                      label: 'Montant',
                      value: investissement.montantFormate,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value:
                          '${investissement.dateInvestissement.day}/${investissement.dateInvestissement.month}/${investissement.dateInvestissement.year}',
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),

              if (investissement.quantiteAchetee != null) ...[
                const SizedBox(height: 12),
                _buildInfoItem(
                  icon: Icons.inventory,
                  label: 'Quantité achetée',
                  value: investissement.quantiteFormatee,
                  color: AppColors.primary,
                ),
              ],

              if (investissement.commentaire != null &&
                  investissement.commentaire!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Commentaire:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        investissement.commentaire!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(InvestissementStatus status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case InvestissementStatus.enAttente:
        chipColor = AppColors.warning;
        statusText = 'En attente';
        break;
      case InvestissementStatus.valide:
        chipColor = AppColors.success;
        statusText = 'Validé';
        break;
      case InvestissementStatus.annule:
        chipColor = AppColors.error;
        statusText = 'Annulé';
        break;
      case InvestissementStatus.termine:
        chipColor = AppColors.primary;
        statusText = 'Terminé';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtres',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              //TODO : Ajouter les options de filtre ici
            ],
          ),
        ),
      ),
    );
  }

  void _showStatusFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filtrer par statut',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Tous'),
              onTap: () {
                setState(() {
                  _selectedStatus = 'Tous';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('En attente'),
              onTap: () {
                setState(() {
                  _selectedStatus = 'En attente';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Validés'),
              onTap: () {
                setState(() {
                  _selectedStatus = 'Validés';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Terminés'),
              onTap: () {
                setState(() {
                  _selectedStatus = 'Terminés';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Annulés'),
              onTap: () {
                setState(() {
                  _selectedStatus = 'Annulés';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<InvestissementModel> _getMockInvestissements() {
    return [
      InvestissementModel(
        id: '1',
        investisseurId: '1',
        investisseurName: 'Kossi Agbeko',
        productionId: '1',
        productionTitle: 'Anacardes de qualité supérieure',
        montantInvesti: 150000.0,
        devise: 'FCFA',
        dateInvestissement: DateTime.now().subtract(const Duration(days: 5)),
        status: InvestissementStatus.valide,
        quantiteAchetee: 100.0,
        unite: 'kg',
        commentaire: 'Excellent produit, très satisfait de la qualité.',
      ),
      InvestissementModel(
        id: '2',
        investisseurId: '1',
        investisseurName: 'Kossi Agbeko',
        productionId: '2',
        productionTitle: 'Anacardes transformées',
        montantInvesti: 200000.0,
        devise: 'FCFA',
        dateInvestissement: DateTime.now().subtract(const Duration(days: 10)),
        status: InvestissementStatus.termine,
        quantiteAchetee: 80.0,
        unite: 'kg',
      ),
      InvestissementModel(
        id: '3',
        investisseurId: '1',
        investisseurName: 'Kossi Agbeko',
        productionId: '3',
        productionTitle: 'Anacardes en coque',
        montantInvesti: 100000.0,
        devise: 'FCFA',
        dateInvestissement: DateTime.now().subtract(const Duration(days: 15)),
        status: InvestissementStatus.enAttente,
        quantiteAchetee: 125.0,
        unite: 'kg',
      ),
    ];
  }
}





