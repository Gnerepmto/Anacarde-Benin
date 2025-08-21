/// Modèle de production d'anacarde
class ProductionModel {
  final String id;
  final String producteurId;
  final String producteurName;
  final String title;
  final String description;
  final double quantite;
  final String unite; // kg, tonnes, etc.
  final double prixUnitaire;
  final String devise; // FCFA, EUR, USD
  final String? imageUrl;
  final String localisation;
  final DateTime dateRecolte;
  final DateTime datePublication;
  final ProductionStatus status;
  final List<String> tags;
  final int vues;
  final int investisseursInteresses;

  ProductionModel({
    required this.id,
    required this.producteurId,
    required this.producteurName,
    required this.title,
    required this.description,
    required this.quantite,
    required this.unite,
    required this.prixUnitaire,
    required this.devise,
    this.imageUrl,
    required this.localisation,
    required this.dateRecolte,
    required this.datePublication,
    required this.status,
    required this.tags,
    this.vues = 0,
    this.investisseursInteresses = 0,
  });

  factory ProductionModel.fromJson(Map<String, dynamic> json) {
    return ProductionModel(
      id: json['id'],
      producteurId: json['producteurId'],
      producteurName: json['producteurName'],
      title: json['title'],
      description: json['description'],
      quantite: json['quantite'].toDouble(),
      unite: json['unite'],
      prixUnitaire: json['prixUnitaire'].toDouble(),
      devise: json['devise'],
      imageUrl: json['imageUrl'],
      localisation: json['localisation'],
      dateRecolte: DateTime.parse(json['dateRecolte']),
      datePublication: DateTime.parse(json['datePublication']),
      status: ProductionStatus.values.firstWhere(
        (e) => e.toString() == 'ProductionStatus.${json['status']}',
      ),
      tags: List<String>.from(json['tags']),
      vues: json['vues'] ?? 0,
      investisseursInteresses: json['investisseursInteresses'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producteurId': producteurId,
      'producteurName': producteurName,
      'title': title,
      'description': description,
      'quantite': quantite,
      'unite': unite,
      'prixUnitaire': prixUnitaire,
      'devise': devise,
      'imageUrl': imageUrl,
      'localisation': localisation,
      'dateRecolte': dateRecolte.toIso8601String(),
      'datePublication': datePublication.toIso8601String(),
      'status': status.toString().split('.').last,
      'tags': tags,
      'vues': vues,
      'investisseursInteresses': investisseursInteresses,
    };
  }

  ProductionModel copyWith({
    String? id,
    String? producteurId,
    String? producteurName,
    String? title,
    String? description,
    double? quantite,
    String? unite,
    double? prixUnitaire,
    String? devise,
    String? imageUrl,
    String? localisation,
    DateTime? dateRecolte,
    DateTime? datePublication,
    ProductionStatus? status,
    List<String>? tags,
    int? vues,
    int? investisseursInteresses,
  }) {
    return ProductionModel(
      id: id ?? this.id,
      producteurId: producteurId ?? this.producteurId,
      producteurName: producteurName ?? this.producteurName,
      title: title ?? this.title,
      description: description ?? this.description,
      quantite: quantite ?? this.quantite,
      unite: unite ?? this.unite,
      prixUnitaire: prixUnitaire ?? this.prixUnitaire,
      devise: devise ?? this.devise,
      imageUrl: imageUrl ?? this.imageUrl,
      localisation: localisation ?? this.localisation,
      dateRecolte: dateRecolte ?? this.dateRecolte,
      datePublication: datePublication ?? this.datePublication,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      vues: vues ?? this.vues,
      investisseursInteresses:
          investisseursInteresses ?? this.investisseursInteresses,
    );
  }

  /// Calcule le prix total de la production
  double get prixTotal => quantite * prixUnitaire;

  /// Formate le prix pour l'affichage
  String get prixFormate => '${prixUnitaire.toStringAsFixed(0)} $devise/$unite';

  /// Formate la quantité pour l'affichage
  String get quantiteFormatee => '${quantite.toStringAsFixed(1)} $unite';
}

/// Statuts de production
enum ProductionStatus {
  enAttente, // En attente de validation admin
  validee, // Validée et visible
  reservee, // Réservée par un investisseur
  vendue, // Vendu
  rejetee, // Rejetée par l'admin
}

