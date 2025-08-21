import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/colors/app_colors.dart';
import '../widgets/primary_button.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

/// Écran de choix de profil (Producteur / Investisseur)
class ChoixProfilScreen extends StatefulWidget {
  const ChoixProfilScreen({super.key});

  @override
  State<ChoixProfilScreen> createState() => _ChoixProfilScreenState();
}

class _ChoixProfilScreenState extends State<ChoixProfilScreen>
    with TickerProviderStateMixin {
  UserType? _selectedType;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectType(UserType type) {
    setState(() {
      _selectedType = type;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _continue() {
    if (_selectedType != null) {
      // Enregistrer le type d'utilisateur sélectionné dans le provider
      context.read<AuthProvider>().setSelectedUserType(_selectedType!);

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(selectedUserType: _selectedType!),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // En-tête
              const SizedBox(height: 40),
              const Text(
                'Choisissez votre profil',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sélectionnez le type de compte qui correspond à votre activité',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

              // Options de profil
              Expanded(
                child: Column(
                  children: [
                    // Option Producteur
                    _buildProfileOption(
                      type: UserType.producteur,
                      title: 'Producteur',
                      subtitle: 'Je cultive et vends de l\'anacarde',
                      icon: Icons.agriculture,
                      color: AppColors.primary,
                      isSelected: _selectedType == UserType.producteur,
                    ),

                    const SizedBox(height: 24),

                    // Option Investisseur
                    _buildProfileOption(
                      type: UserType.investisseur,
                      title: 'Investisseur',
                      subtitle: 'Je souhaite investir dans l\'anacarde',
                      icon: Icons.trending_up,
                      color: AppColors.secondary,
                      isSelected: _selectedType == UserType.investisseur,
                    ),
                  ],
                ),
              ),

              // Bouton Continuer
              PrimaryButton(
                text: 'Continuer',
                onPressed: _selectedType != null ? _continue : null,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required UserType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _selectType(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.1) : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? color
                      : AppColors.textLight.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.shadowLight,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  // Icône
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? color : color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      icon,
                      size: 30,
                      color: isSelected ? Colors.white : color,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Texte
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? color : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? color.withOpacity(0.8)
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Indicateur de sélection
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
