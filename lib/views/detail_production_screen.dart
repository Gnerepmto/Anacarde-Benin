import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/production_model.dart';
import '../models/user_model.dart';
import '../views/colors/app_colors.dart';
import '../widgets/primary_button.dart';
import '../providers/auth_provider.dart';

/// Écran de détail d'une production
class DetailProductionScreen extends StatefulWidget {
  final ProductionModel production;

  const DetailProductionScreen({super.key, required this.production});

  @override
  State<DetailProductionScreen> createState() => _DetailProductionScreenState();
}

class _DetailProductionScreenState extends State<DetailProductionScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar avec image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            flexibleSpace: FlexibleSpaceBar(background: _buildImageSection()),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Partager la production
                },
              ),
            ],
          ),

          // Contenu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête avec titre et statut
                  _buildHeaderSection(),

                  const SizedBox(height: 24),

                  // Description
                  _buildDescriptionSection(),

                  const SizedBox(height: 24),

                  // Informations détaillées
                  _buildDetailsSection(),

                  const SizedBox(height: 24),

                  // Informations d'investissement (pour les investisseurs)
                  if (context.read<AuthProvider>().currentUser?.userType ==
                      UserType.investisseur)
                    _buildInvestmentSection(),

                  const SizedBox(height: 24),

                  // Statistiques
                  _buildStatsSection(),

                  const SizedBox(height: 24),

                  // Tags
                  if (widget.production.tags.isNotEmpty) _buildTagsSection(),

                  const SizedBox(height: 32),

                  // Bouton d'action
                  _buildActionButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(color: AppColors.background),
      child: widget.production.imageUrl != null
          ? Image.network(
              widget.production.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholderImage();
              },
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.background,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 80, color: AppColors.textLight),
            SizedBox(height: 16),
            Text(
              'Aucune image disponible',
              style: TextStyle(color: AppColors.textLight, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        Text(
          widget.production.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        // Producteur et statut
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.production.producteurName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _buildStatusChip(),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;

    switch (widget.production.status) {
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

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.production.description,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détails',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // Grille d'informations
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _buildDetailCard(
              icon: Icons.inventory,
              label: 'Quantité',
              value: widget.production.quantiteFormatee,
              color: AppColors.primary,
            ),
            _buildDetailCard(
              icon: Icons.attach_money,
              label: 'Prix unitaire',
              value: widget.production.prixFormate,
              color: AppColors.success,
            ),
            _buildDetailCard(
              icon: Icons.location_on,
              label: 'Localisation',
              value: widget.production.localisation,
              color: AppColors.info,
            ),
            _buildDetailCard(
              icon: Icons.calendar_today,
              label: 'Date de récolte',
              value:
                  '${widget.production.dateRecolte.day}/${widget.production.dateRecolte.month}/${widget.production.dateRecolte.year}',
              color: AppColors.secondary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
      ),
      child: Column(
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistiques',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.visibility,
                label: 'Vues',
                value: widget.production.vues.toString(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.favorite,
                label: 'Intéressés',
                value: widget.production.investisseursInteresses.toString(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.textSecondary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.production.tags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: AppColors.primary.withOpacity(0.1),
              labelStyle: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;

    // Afficher le bouton d'investissement seulement pour les investisseurs
    if (user?.userType == UserType.investisseur &&
        widget.production.status == ProductionStatus.validee) {
      return PrimaryButton(
        text: 'Investir maintenant',
        onPressed: _investir,
        isLoading: _isLoading,
        icon: Icons.trending_up,
      );
    }

    // Pour les producteurs, afficher un bouton de modification
    if (user?.userType == UserType.producteur &&
        widget.production.producteurId == user?.id) {
      return Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: 'Modifier',
              onPressed: () {
                // Naviguer vers la modification
              },
              isOutlined: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: PrimaryButton(
              text: 'Supprimer',
              onPressed: () {
                _showDeleteDialog();
              },
              backgroundColor: AppColors.error,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _investir() async {
    // Afficher la boîte de dialogue de sélection du moyen de paiement
    final selectedPaymentMethod = await _showPaymentMethodDialog();

    if (selectedPaymentMethod == null) {
      // L'utilisateur a annulé la sélection
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Afficher les informations de paiement selon le moyen sélectionné
      await _showPaymentDetails(selectedPaymentMethod);

      // Simuler un investissement avec le moyen de paiement sélectionné
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Demande d\'investissement envoyée avec succès via $selectedPaymentMethod !',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'investissement: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> _showPaymentMethodDialog() {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.payment, color: AppColors.secondary),
            const SizedBox(width: 8),
            const Text(
              'Choisir le moyen de paiement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sélectionnez votre moyen de paiement préféré pour procéder à l\'investissement.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            _buildPaymentOption(
              'Mobile Money',
              'Paiement via Mobile Money',
              Icons.phone_android,
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'Moov Money',
              'Paiement via Moov Money',
              Icons.account_balance_wallet,
              AppColors.success,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'CeltiisCash',
              'Paiement via CeltiisCash',
              Icons.credit_card,
              AppColors.warning,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textLight.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPaymentDetails(String paymentMethod) async {
    final montant = widget.production.montantInvestissementFormate;
    final productionTitle = widget.production.title;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getPaymentIcon(paymentMethod),
              color: _getPaymentColor(paymentMethod),
            ),
            const SizedBox(width: 8),
            Text(
              'Paiement via $paymentMethod',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Récapitulatif de votre investissement :',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentDetail('Production', productionTitle),
            const SizedBox(height: 8),
            _buildPaymentDetail('Montant', montant),
            const SizedBox(height: 8),
            _buildPaymentDetail('Moyen de paiement', paymentMethod),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Vous allez être redirigé vers $paymentMethod pour finaliser le paiement.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
            },
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getPaymentColor(paymentMethod),
            ),
            child: const Text(
              'Continuer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  IconData _getPaymentIcon(String paymentMethod) {
    switch (paymentMethod) {
      case 'Mobile Money':
        return Icons.phone_android;
      case 'Moov Money':
        return Icons.account_balance_wallet;
      case 'CeltiisCash':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  Color _getPaymentColor(String paymentMethod) {
    switch (paymentMethod) {
      case 'Mobile Money':
        return AppColors.primary;
      case 'Moov Money':
        return AppColors.success;
      case 'CeltiisCash':
        return AppColors.warning;
      default:
        return AppColors.secondary;
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la production'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette production ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Supprimer la production
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations d\'investissement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // Grille d'informations d'investissement
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2,
          children: [
            _buildDetailCard(
              icon: Icons.trending_up,
              label: 'Production annuelle',
              value: widget.production.quantiteAnnuelleFormatee,
              color: AppColors.primary,
            ),
            _buildDetailCard(
              icon: Icons.attach_money,
              label: 'Montant recherché',
              value: widget.production.montantInvestissementFormate,
              color: AppColors.success,
            ),
            _buildDetailCard(
              icon: Icons.agriculture,
              label: 'Hectares anacardiers',
              value: widget.production.hectaresAnacardiersFormate,
              color: AppColors.info,
            ),
            _buildDetailCard(
              icon: Icons.landscape,
              label: 'Hectares totaux',
              value: widget.production.hectaresTotauxFormate,
              color: AppColors.secondary,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Modalités de remboursement
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Modalités de remboursement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.production.modalitesRemboursement,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Informations de contact
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contact du producteur',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.production.telephone,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.production.adresse,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
