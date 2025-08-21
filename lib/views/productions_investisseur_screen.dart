import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/production_provider.dart';
import '../models/production_model.dart';
import '../views/colors/app_colors.dart';
import 'detail_production_screen.dart';

/// Écran des productions pour les investisseurs avec filtres avancés
class ProductionsInvestisseurScreen extends StatefulWidget {
  const ProductionsInvestisseurScreen({super.key});

  @override
  State<ProductionsInvestisseurScreen> createState() =>
      _ProductionsInvestisseurScreenState();
}

class _ProductionsInvestisseurScreenState
    extends State<ProductionsInvestisseurScreen> {
  // Filtres
  String _selectedLocalisation = 'Toutes';
  String _selectedQuantite = 'Toutes';
  String _selectedMontant = 'Toutes';

  // Contrôleurs pour les filtres numériques
  final TextEditingController _minQuantiteController = TextEditingController();
  final TextEditingController _maxQuantiteController = TextEditingController();
  final TextEditingController _minMontantController = TextEditingController();
  final TextEditingController _maxMontantController = TextEditingController();

  // Listes des options de filtres
  final List<String> _localisations = [
    'Toutes',
    'Parakou',
    'Cotonou',
    'Porto-Novo',
    'Abomey',
  ];
  final List<String> _quantites = [
    'Toutes',
    '0-500 kg',
    '500-1000 kg',
    '1000-2000 kg',
    '2000+ kg',
  ];
  final List<String> _montants = [
    'Toutes',
    '0-300k FCFA',
    '300k-500k FCFA',
    '500k-1M FCFA',
    '1M+ FCFA',
  ];

  @override
  void dispose() {
    _minQuantiteController.dispose();
    _maxQuantiteController.dispose();
    _minMontantController.dispose();
    _maxMontantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Productions disponibles',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showAdvancedFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres rapides
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtres rapides',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Localisation', _selectedLocalisation, (
                        value,
                      ) {
                        setState(() {
                          _selectedLocalisation = value;
                        });
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Quantité', _selectedQuantite, (value) {
                        setState(() {
                          _selectedQuantite = value;
                        });
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Montant', _selectedMontant, (value) {
                        setState(() {
                          _selectedMontant = value;
                        });
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Liste des productions
          Expanded(
            child: Consumer<ProductionProvider>(
              builder: (context, productionProvider, child) {
                if (productionProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  );
                }

                final filteredProductions = _getFilteredProductions(
                  productionProvider.productions,
                );

                if (filteredProductions.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: AppColors.textLight,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Aucune production trouvée',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Essayez de modifier vos filtres',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProductions.length,
                  itemBuilder: (context, index) {
                    final production = filteredProductions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildProductionCard(production),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return FilterChip(
      label: Text(
        selectedValue,
        style: TextStyle(
          color: selectedValue == 'Toutes'
              ? AppColors.textSecondary
              : AppColors.secondary,
          fontWeight: selectedValue == 'Toutes'
              ? FontWeight.normal
              : FontWeight.w600,
        ),
      ),
      selected: selectedValue != 'Toutes',
      onSelected: (selected) {
        // Ouvrir le sélecteur
        _showFilterSelector(label, selectedValue, onChanged);
      },
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.secondary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.secondary,
      side: BorderSide(
        color: selectedValue == 'Toutes'
            ? AppColors.textLight
            : AppColors.secondary,
      ),
    );
  }

  void _showFilterSelector(
    String label,
    String currentValue,
    Function(String) onChanged,
  ) {
    List<String> options = [];
    switch (label) {
      case 'Localisation':
        options = _localisations;
        break;
      case 'Quantité':
        options = _quantites;
        break;
      case 'Montant':
        options = _montants;
        break;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sélectionner $label',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...options.map(
              (option) => ListTile(
                title: Text(option),
                trailing: option == currentValue
                    ? const Icon(Icons.check, color: AppColors.secondary)
                    : null,
                onTap: () {
                  onChanged(option);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdvancedFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtres avancés'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filtre par localisation
              const Text(
                'Localisation',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedLocalisation,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: _localisations
                    .map(
                      (loc) => DropdownMenuItem(value: loc, child: Text(loc)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocalisation = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Filtre par quantité
              const Text(
                'Quantité produite (kg)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minQuantiteController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Min',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _maxQuantiteController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Max',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filtre par montant d'investissement
              const Text(
                'Montant d\'investissement (FCFA)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minMontantController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Min',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _maxMontantController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Max',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
  }

  List<ProductionModel> _getFilteredProductions(
    List<ProductionModel> productions,
  ) {
    List<ProductionModel> filtered = productions
        .where((p) => p.status == ProductionStatus.validee)
        .toList();

    // Filtre par localisation
    if (_selectedLocalisation != 'Toutes') {
      filtered = filtered
          .where(
            (p) => p.localisation.toLowerCase().contains(
              _selectedLocalisation.toLowerCase(),
            ),
          )
          .toList();
    }

    // Filtre par quantité
    if (_selectedQuantite != 'Toutes') {
      switch (_selectedQuantite) {
        case '0-500 kg':
          filtered = filtered.where((p) => p.quantite <= 500).toList();
          break;
        case '500-1000 kg':
          filtered = filtered
              .where((p) => p.quantite > 500 && p.quantite <= 1000)
              .toList();
          break;
        case '1000-2000 kg':
          filtered = filtered
              .where((p) => p.quantite > 1000 && p.quantite <= 2000)
              .toList();
          break;
        case '2000+ kg':
          filtered = filtered.where((p) => p.quantite > 2000).toList();
          break;
      }
    }

    // Filtre par montant d'investissement
    if (_selectedMontant != 'Toutes') {
      switch (_selectedMontant) {
        case '0-300k FCFA':
          filtered = filtered
              .where((p) => p.montantInvestissement <= 300000)
              .toList();
          break;
        case '300k-500k FCFA':
          filtered = filtered
              .where(
                (p) =>
                    p.montantInvestissement > 300000 &&
                    p.montantInvestissement <= 500000,
              )
              .toList();
          break;
        case '500k-1M FCFA':
          filtered = filtered
              .where(
                (p) =>
                    p.montantInvestissement > 500000 &&
                    p.montantInvestissement <= 1000000,
              )
              .toList();
          break;
        case '1M+ FCFA':
          filtered = filtered
              .where((p) => p.montantInvestissement > 1000000)
              .toList();
          break;
      }
    }

    // Filtres numériques avancés
    if (_minQuantiteController.text.isNotEmpty) {
      final minQuantite = double.tryParse(_minQuantiteController.text) ?? 0;
      filtered = filtered.where((p) => p.quantite >= minQuantite).toList();
    }

    if (_maxQuantiteController.text.isNotEmpty) {
      final maxQuantite =
          double.tryParse(_maxQuantiteController.text) ?? double.infinity;
      filtered = filtered.where((p) => p.quantite <= maxQuantite).toList();
    }

    if (_minMontantController.text.isNotEmpty) {
      final minMontant = double.tryParse(_minMontantController.text) ?? 0;
      filtered = filtered
          .where((p) => p.montantInvestissement >= minMontant)
          .toList();
    }

    if (_maxMontantController.text.isNotEmpty) {
      final maxMontant =
          double.tryParse(_maxMontantController.text) ?? double.infinity;
      filtered = filtered
          .where((p) => p.montantInvestissement <= maxMontant)
          .toList();
    }

    return filtered;
  }

  Widget _buildProductionCard(ProductionModel production) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  DetailProductionScreen(production: production),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec image et titre
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image de la production
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: AppColors.surface,
                      child: production.imageUrl != null
                          ? Image.network(
                              production.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image,
                                  size: 40,
                                  color: AppColors.textLight,
                                );
                              },
                            )
                          : const Icon(
                              Icons.image,
                              size: 40,
                              color: AppColors.textLight,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Informations principales
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          production.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          production.producteurName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                production.localisation,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Informations d'investissement
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations d\'investissement',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Production annuelle',
                            production.quantiteAnnuelleFormatee,
                            Icons.trending_up,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Montant recherché',
                            production.montantInvestissementFormate,
                            Icons.attach_money,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Hectares anacardiers',
                            production.hectaresAnacardiersFormate,
                            Icons.agriculture,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Hectares totaux',
                            production.hectaresTotauxFormate,
                            Icons.landscape,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Bouton d'action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailProductionScreen(production: production),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Voir les détails'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
