import 'package:flutter/material.dart';
import '../views/colors/app_colors.dart';
import '../models/notification_model.dart';

/// Écran des notifications
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: AppColors.primary),
            onPressed: () {
              // Marquer toutes les notifications comme lues
            },
          ),
        ],
      ),
      body: _buildNotificationsList(),
    );
  }

  Widget _buildNotificationsList() {
    // Simuler des données de notifications
    final notifications = _getMockNotifications();

    if (notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: AppColors.textLight,
            ),
            SizedBox(height: 24),
            Text(
              'Aucune notification',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Vous n\'avez pas encore de notifications',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: notification.isLue ? 1 : 2,
      shadowColor: AppColors.shadowLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Marquer comme lue et naviguer si nécessaire
          _handleNotificationTap(notification);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: notification.isLue
                ? AppColors.surface
                : AppColors.primary.withOpacity(0.05),
          ),
          child: Row(
            children: [
              // Icône
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getNotificationColor(
                    notification.type,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  size: 24,
                  color: _getNotificationColor(notification.type),
                ),
              ),

              const SizedBox(width: 16),

              // Contenu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: notification.isLue
                            ? FontWeight.w500
                            : FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Message
                    Text(
                      notification.message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Date
                    Text(
                      notification.dateFormatee,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Indicateur de lecture
              if (!notification.isLue)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Marquer comme lue
    // En production, cela mettrait à jour la base de données

    // Naviguer selon le type de notification
    switch (notification.type) {
      case NotificationType.production:
        // Naviguer vers le détail de la production
        break;
      case NotificationType.investissement:
        // Naviguer vers le détail de l'investissement
        break;
      case NotificationType.validation:
        // Naviguer vers les productions en attente
        break;
      case NotificationType.formation:
        // Naviguer vers les formations
        break;
      case NotificationType.systeme:
      case NotificationType.message:
        // Afficher le message complet
        _showNotificationDetails(notification);
        break;
    }
  }

  void _showNotificationDetails(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 16),
            Text(
              notification.dateFormatee,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.production:
        return Icons.inventory;
      case NotificationType.investissement:
        return Icons.trending_up;
      case NotificationType.validation:
        return Icons.check_circle;
      case NotificationType.formation:
        return Icons.school;
      case NotificationType.systeme:
        return Icons.info;
      case NotificationType.message:
        return Icons.message;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.production:
        return AppColors.primary;
      case NotificationType.investissement:
        return AppColors.success;
      case NotificationType.validation:
        return AppColors.info;
      case NotificationType.formation:
        return AppColors.secondary;
      case NotificationType.systeme:
        return AppColors.warning;
      case NotificationType.message:
        return AppColors.primary;
    }
  }

  List<NotificationModel> _getMockNotifications() {
    return [
      NotificationModel(
        id: '1',
        userId: '1',
        title: 'Production validée',
        message:
            'Votre production "Anacardes de qualité supérieure" a été validée et est maintenant visible par les investisseurs.',
        type: NotificationType.validation,
        dateCreation: DateTime.now().subtract(const Duration(hours: 2)),
        isLue: false,
        dataId: '1',
      ),
      NotificationModel(
        id: '2',
        userId: '1',
        title: 'Nouvel investisseur intéressé',
        message:
            'Un investisseur s\'est intéressé à votre production "Anacardes transformées".',
        type: NotificationType.investissement,
        dateCreation: DateTime.now().subtract(const Duration(days: 1)),
        isLue: false,
        dataId: '2',
      ),
      NotificationModel(
        id: '3',
        userId: '1',
        title: 'Nouvelle formation disponible',
        message:
            'Une nouvelle formation sur "Techniques de transformation" est maintenant disponible.',
        type: NotificationType.formation,
        dateCreation: DateTime.now().subtract(const Duration(days: 2)),
        isLue: true,
        dataId: '3',
      ),
      NotificationModel(
        id: '4',
        userId: '1',
        title: 'Maintenance prévue',
        message:
            'Une maintenance est prévue le 15 décembre de 22h à 2h. L\'application sera temporairement indisponible.',
        type: NotificationType.systeme,
        dateCreation: DateTime.now().subtract(const Duration(days: 3)),
        isLue: true,
      ),
      NotificationModel(
        id: '5',
        userId: '1',
        title: 'Bienvenue sur Anacarde Bénin',
        message:
            'Merci de vous être inscrit sur notre plateforme. Nous sommes ravis de vous accompagner dans votre activité.',
        type: NotificationType.message,
        dateCreation: DateTime.now().subtract(const Duration(days: 5)),
        isLue: true,
      ),
    ];
  }
}




