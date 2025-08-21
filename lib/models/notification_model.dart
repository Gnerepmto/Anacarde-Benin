/// Modèle de notification
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime dateCreation;
  final bool isLue;
  final String? dataId; // ID de l'objet lié (production, investissement, etc.)
  final String? actionUrl; // URL ou route pour l'action

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.dateCreation,
    this.isLue = false,
    this.dataId,
    this.actionUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${json['type']}',
      ),
      dateCreation: DateTime.parse(json['dateCreation']),
      isLue: json['isLue'] ?? false,
      dataId: json['dataId'],
      actionUrl: json['actionUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'dateCreation': dateCreation.toIso8601String(),
      'isLue': isLue,
      'dataId': dataId,
      'actionUrl': actionUrl,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? dateCreation,
    bool? isLue,
    String? dataId,
    String? actionUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      dateCreation: dateCreation ?? this.dateCreation,
      isLue: isLue ?? this.isLue,
      dataId: dataId ?? this.dataId,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  /// Formate la date pour l'affichage
  String get dateFormatee {
    final maintenant = DateTime.now();
    final difference = maintenant.difference(dateCreation);

    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }
}

/// Types de notifications
enum NotificationType {
  production, // Nouvelle production publiée
  investissement, // Nouvel investissement
  validation, // Production validée/rejetée
  formation, // Nouvelle formation disponible
  systeme, // Notification système
  message, // Message privé
}

