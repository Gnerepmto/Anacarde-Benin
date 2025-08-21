import 'package:flutter/material.dart';
import '../models/production_model.dart';

/// Provider pour la gestion des productions
class ProductionProvider extends ChangeNotifier {
  List<ProductionModel> _productions = [];
  List<ProductionModel> _mesProductions = [];
  bool _isLoading = false;
  String _filterCategory = 'Toutes';
  String _filterStatus = 'Toutes';

  List<ProductionModel> get productions => _getFilteredProductions();
  List<ProductionModel> get mesProductions => _mesProductions;
  bool get isLoading => _isLoading;
  String get filterCategory => _filterCategory;
  String get filterStatus => _filterStatus;

  /// Initialise les données de production
  Future<void> initialize() async {
    _isLoading = true;

    try {
      // Simuler le chargement des données
      await Future.delayed(const Duration(seconds: 1));
      _productions = _getMockProductions();
      _mesProductions = _productions
          .where((p) => p.producteurId == '1')
          .toList();
    } catch (e) {
      debugPrint('Erreur lors du chargement des productions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ajouter une nouvelle production
  Future<bool> addProduction({
    required String title,
    required String description,
    required double quantite,
    required String unite,
    required double prixUnitaire,
    required String devise,
    required String localisation,
    required DateTime dateRecolte,
    String? imageUrl,
    List<String> tags = const [],
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simuler l'ajout
      await Future.delayed(const Duration(seconds: 2));

      final nouvelleProduction = ProductionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        producteurId: '1', // ID de l'utilisateur connecté
        producteurName: 'Kossi Agbeko',
        title: title,
        description: description,
        quantite: quantite,
        unite: unite,
        prixUnitaire: prixUnitaire,
        devise: devise,
        imageUrl: imageUrl,
        localisation: localisation,
        dateRecolte: dateRecolte,
        datePublication: DateTime.now(),
        status: ProductionStatus.enAttente,
        tags: tags,
      );

      _productions.add(nouvelleProduction);
      _mesProductions.add(nouvelleProduction);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Mettre à jour le statut d'une production
  Future<void> updateProductionStatus(
    String productionId,
    ProductionStatus status,
  ) async {
    final index = _productions.indexWhere((p) => p.id == productionId);
    if (index != -1) {
      _productions[index] = _productions[index].copyWith(status: status);

      final mesIndex = _mesProductions.indexWhere((p) => p.id == productionId);
      if (mesIndex != -1) {
        _mesProductions[mesIndex] = _mesProductions[mesIndex].copyWith(
          status: status,
        );
      }

      notifyListeners();
    }
  }

  /// Supprimer une production
  Future<void> deleteProduction(String productionId) async {
    _productions.removeWhere((p) => p.id == productionId);
    _mesProductions.removeWhere((p) => p.id == productionId);
    notifyListeners();
  }

  /// Appliquer un filtre par catégorie
  void setCategoryFilter(String category) {
    _filterCategory = category;
    notifyListeners();
  }

  /// Appliquer un filtre par statut
  void setStatusFilter(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  /// Obtenir les productions filtrées
  List<ProductionModel> _getFilteredProductions() {
    List<ProductionModel> filtered = _productions;

    // Filtre par catégorie
    if (_filterCategory != 'Toutes') {
      filtered = filtered
          .where((p) => p.tags.contains(_filterCategory))
          .toList();
    }

    // Filtre par statut
    if (_filterStatus != 'Toutes') {
      final status = ProductionStatus.values.firstWhere(
        (s) => s.toString().split('.').last == _filterStatus,
        orElse: () => ProductionStatus.validee,
      );
      filtered = filtered.where((p) => p.status == status).toList();
    }

    return filtered;
  }

  /// Obtenir les statistiques du producteur
  Map<String, dynamic> getProducteurStats() {
    final mesProductions = _productions
        .where((p) => p.producteurId == '1')
        .toList();

    return {
      'total': mesProductions.length,
      'enAttente': mesProductions
          .where((p) => p.status == ProductionStatus.enAttente)
          .length,
      'validees': mesProductions
          .where((p) => p.status == ProductionStatus.validee)
          .length,
      'vendues': mesProductions
          .where((p) => p.status == ProductionStatus.vendue)
          .length,
      'totalVues': mesProductions.fold(0, (sum, p) => sum + p.vues),
      'totalInteresses': mesProductions.fold(
        0,
        (sum, p) => sum + p.investisseursInteresses,
      ),
    };
  }

  /// Productions mock pour les tests
  List<ProductionModel> _getMockProductions() {
    return [
      ProductionModel(
        id: '1',
        producteurId: '1',
        producteurName: 'Kossi Agbeko',
        title: 'Anacardes de qualité supérieure',
        description:
            'Anacardes fraîchement récoltées, de grande qualité. Production biologique sans pesticides.',
        quantite: 500.0,
        unite: 'kg',
        prixUnitaire: 1200.0,
        devise: 'FCFA',
        imageUrl:
            'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop',
        localisation: 'Parakou, Bénin',
        dateRecolte: DateTime.now().subtract(const Duration(days: 5)),
        datePublication: DateTime.now().subtract(const Duration(days: 3)),
        status: ProductionStatus.validee,
        tags: ['bio', 'premium'],
        vues: 45,
        investisseursInteresses: 3,
      ),
      ProductionModel(
        id: '2',
        producteurId: '2',
        producteurName: 'Fatou Diallo',
        title: 'Anacardes transformées',
        description:
            'Anacardes décortiquées et grillées, prêtes pour la commercialisation.',
        quantite: 200.0,
        unite: 'kg',
        prixUnitaire: 2500.0,
        devise: 'FCFA',
        imageUrl:
            'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop&crop=center',
        localisation: 'Cotonou, Bénin',
        dateRecolte: DateTime.now().subtract(const Duration(days: 10)),
        datePublication: DateTime.now().subtract(const Duration(days: 7)),
        status: ProductionStatus.validee,
        tags: ['transforme', 'grille'],
        vues: 32,
        investisseursInteresses: 2,
      ),
      ProductionModel(
        id: '3',
        producteurId: '1',
        producteurName: 'Kossi Agbeko',
        title: 'Anacardes en coque',
        description:
            'Anacardes en coque, stockées dans des conditions optimales.',
        quantite: 1000.0,
        unite: 'kg',
        prixUnitaire: 800.0,
        devise: 'FCFA',
        imageUrl:
            'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop&crop=entropy',
        localisation: 'Parakou, Bénin',
        dateRecolte: DateTime.now().subtract(const Duration(days: 2)),
        datePublication: DateTime.now().subtract(const Duration(days: 1)),
        status: ProductionStatus.enAttente,
        tags: ['coque', 'stockage'],
        vues: 12,
        investisseursInteresses: 0,
      ),
    ];
  }
}
