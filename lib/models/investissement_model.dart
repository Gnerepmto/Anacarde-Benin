/// Modèle d'investissement
class InvestissementModel {
  final String id;
  final String investisseurId;
  final String investisseurName;
  final String productionId;
  final String productionTitle;
  final double montantInvesti;
  final String devise;
  final DateTime dateInvestissement;
  final InvestissementStatus status;
  final String? commentaire;
  final double? quantiteAchetee;
  final String? unite;

  InvestissementModel({
    required this.id,
    required this.investisseurId,
    required this.investisseurName,
    required this.productionId,
    required this.productionTitle,
    required this.montantInvesti,
    required this.devise,
    required this.dateInvestissement,
    required this.status,
    this.commentaire,
    this.quantiteAchetee,
    this.unite,
  });

  factory InvestissementModel.fromJson(Map<String, dynamic> json) {
    return InvestissementModel(
      id: json['id'],
      investisseurId: json['investisseurId'],
      investisseurName: json['investisseurName'],
      productionId: json['productionId'],
      productionTitle: json['productionTitle'],
      montantInvesti: json['montantInvesti'].toDouble(),
      devise: json['devise'],
      dateInvestissement: DateTime.parse(json['dateInvestissement']),
      status: InvestissementStatus.values.firstWhere(
        (e) => e.toString() == 'InvestissementStatus.${json['status']}',
      ),
      commentaire: json['commentaire'],
      quantiteAchetee: json['quantiteAchetee']?.toDouble(),
      unite: json['unite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'investisseurId': investisseurId,
      'investisseurName': investisseurName,
      'productionId': productionId,
      'productionTitle': productionTitle,
      'montantInvesti': montantInvesti,
      'devise': devise,
      'dateInvestissement': dateInvestissement.toIso8601String(),
      'status': status.toString().split('.').last,
      'commentaire': commentaire,
      'quantiteAchetee': quantiteAchetee,
      'unite': unite,
    };
  }

  InvestissementModel copyWith({
    String? id,
    String? investisseurId,
    String? investisseurName,
    String? productionId,
    String? productionTitle,
    double? montantInvesti,
    String? devise,
    DateTime? dateInvestissement,
    InvestissementStatus? status,
    String? commentaire,
    double? quantiteAchetee,
    String? unite,
  }) {
    return InvestissementModel(
      id: id ?? this.id,
      investisseurId: investisseurId ?? this.investisseurId,
      investisseurName: investisseurName ?? this.investisseurName,
      productionId: productionId ?? this.productionId,
      productionTitle: productionTitle ?? this.productionTitle,
      montantInvesti: montantInvesti ?? this.montantInvesti,
      devise: devise ?? this.devise,
      dateInvestissement: dateInvestissement ?? this.dateInvestissement,
      status: status ?? this.status,
      commentaire: commentaire ?? this.commentaire,
      quantiteAchetee: quantiteAchetee ?? this.quantiteAchetee,
      unite: unite ?? this.unite,
    );
  }

  /// Formate le montant pour l'affichage
  String get montantFormate => '${montantInvesti.toStringAsFixed(0)} $devise';

  /// Formate la quantité achetée
  String get quantiteFormatee {
    if (quantiteAchetee == null || unite == null) return '';
    return '${quantiteAchetee!.toStringAsFixed(1)} $unite';
  }
}

/// Statuts d'investissement
enum InvestissementStatus {
  enAttente, // En attente de validation
  valide, // Validé et confirmé
  annule, // Annulé
  termine, // Terminé avec succès
}

