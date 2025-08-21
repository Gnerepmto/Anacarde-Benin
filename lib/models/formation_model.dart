/// Modèle de formation vidéo
class FormationModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String? thumbnailUrl;
  final String category;
  final int duree; // en secondes
  final String instructeur;
  final DateTime datePublication;
  final bool isActive;
  final List<String> tags;
  final int vues;
  final double note; // Note moyenne sur 5

  FormationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.category,
    required this.duree,
    required this.instructeur,
    required this.datePublication,
    this.isActive = true,
    required this.tags,
    this.vues = 0,
    this.note = 0.0,
  });

  factory FormationModel.fromJson(Map<String, dynamic> json) {
    return FormationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      category: json['category'],
      duree: json['duree'],
      instructeur: json['instructeur'],
      datePublication: DateTime.parse(json['datePublication']),
      isActive: json['isActive'] ?? true,
      tags: List<String>.from(json['tags']),
      vues: json['vues'] ?? 0,
      note: json['note']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'duree': duree,
      'instructeur': instructeur,
      'datePublication': datePublication.toIso8601String(),
      'isActive': isActive,
      'tags': tags,
      'vues': vues,
      'note': note,
    };
  }

  FormationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    String? category,
    int? duree,
    String? instructeur,
    DateTime? datePublication,
    bool? isActive,
    List<String>? tags,
    int? vues,
    double? note,
  }) {
    return FormationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      category: category ?? this.category,
      duree: duree ?? this.duree,
      instructeur: instructeur ?? this.instructeur,
      datePublication: datePublication ?? this.datePublication,
      isActive: isActive ?? this.isActive,
      tags: tags ?? this.tags,
      vues: vues ?? this.vues,
      note: note ?? this.note,
    );
  }

  /// Formate la durée en format MM:SS
  String get dureeFormatee {
    final minutes = duree ~/ 60;
    final secondes = duree % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secondes.toString().padLeft(2, '0')}';
  }

  /// Formate la note avec des étoiles
  String get noteFormatee => '${note.toStringAsFixed(1)}/5';
}

/// Catégories de formations
enum FormationCategory {
  culture,
  recolte,
  transformation,
  commercialisation,
  financement,
  qualite,
}

