import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/production_model.dart';
import '../views/colors/app_colors.dart';

/// Carte de production avec design moderne
class ProductionCard extends StatelessWidget {
  final ProductionModel production;
  final VoidCallback? onTap;
  final VoidCallback? onInvestir;
  final bool showActions;
  final bool isCompact;

  const ProductionCard({
    super.key,
    required this.production,
    this.onTap,
    this.onInvestir,
    this.showActions = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image de la production
            _buildImageSection(),

            // Contenu de la carte
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et statut
                  _buildHeaderSection(),
                  const SizedBox(height: 8),

                  // Description
                  if (!isCompact) ...[
                    Text(
                      production.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Informations de prix et quantité
                  _buildInfoSection(),

                  // Actions
                  if (showActions && !isCompact) ...[
                    const SizedBox(height: 16),
                    _buildActionsSection(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: AppColors.background,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: production.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: production.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.background,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                errorWidget: (context, url, error) => _buildPlaceholderImage(),
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.background,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 48, color: AppColors.textLight),
            SizedBox(height: 8),
            Text(
              'Aucune image',
              style: TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        Expanded(
          child: Text(
            production.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;

    switch (production.status) {
      case ProductionStatus.enAttente:
        chipColor = AppColors.warning;
        statusText = 'En attente';
        break;
      case ProductionStatus.validee:
        chipColor = AppColors.success;
        statusText = 'Validée';
        break;
      case ProductionStatus.reservee:
        chipColor = AppColors.info;
        statusText = 'Réservée';
        break;
      case ProductionStatus.vendue:
        chipColor = AppColors.primary;
        statusText = 'Vendue';
        break;
      case ProductionStatus.rejetee:
        chipColor = AppColors.error;
        statusText = 'Rejetée';
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

  Widget _buildInfoSection() {
    return Row(
      children: [
        // Prix
        Expanded(
          child: _buildInfoItem(
            icon: Icons.attach_money,
            label: 'Prix',
            value: production.prixFormate,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        // Quantité
        Expanded(
          child: _buildInfoItem(
            icon: Icons.inventory,
            label: 'Quantité',
            value: production.quantiteFormatee,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Row(
      children: [
        // Statistiques
        Expanded(
          child: Row(
            children: [
              _buildStatItem(
                icon: Icons.visibility,
                value: production.vues.toString(),
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                icon: Icons.favorite,
                value: production.investisseursInteresses.toString(),
              ),
            ],
          ),
        ),
        // Bouton d'action
        if (onInvestir != null)
          ElevatedButton(
            onPressed: onInvestir,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Investir',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  Widget _buildStatItem({required IconData icon, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Version compacte de la carte de production
class CompactProductionCard extends StatelessWidget {
  final ProductionModel production;
  final VoidCallback? onTap;

  const CompactProductionCard({
    super.key,
    required this.production,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shadowColor: AppColors.shadowLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image miniature
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.background,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: production.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: production.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image,
                            color: AppColors.textLight,
                          ),
                        )
                      : const Icon(Icons.image, color: AppColors.textLight),
                ),
              ),
              const SizedBox(width: 12),

              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      production.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${production.quantiteFormatee} • ${production.prixFormate}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Statut
              _buildStatusChip(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;

    switch (production.status) {
      case ProductionStatus.enAttente:
        chipColor = AppColors.warning;
        statusText = 'En attente';
        break;
      case ProductionStatus.validee:
        chipColor = AppColors.success;
        statusText = 'Validée';
        break;
      case ProductionStatus.reservee:
        chipColor = AppColors.info;
        statusText = 'Réservée';
        break;
      case ProductionStatus.vendue:
        chipColor = AppColors.primary;
        statusText = 'Vendue';
        break;
      case ProductionStatus.rejetee:
        chipColor = AppColors.error;
        statusText = 'Rejetée';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }
}

