import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../views/colors/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_text_field.dart';
import '../models/user_model.dart';
import 'dashboard_screen.dart';

/// Écran d'inscription
class RegisterScreen extends StatefulWidget {
  final UserType selectedUserType;

  const RegisterScreen({super.key, required this.selectedUserType});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        // S'assurer que le type d'utilisateur sélectionné est enregistré
        if (authProvider.selectedUserType == null) {
          authProvider.setSelectedUserType(widget.selectedUserType);
        }

        final success = await authProvider.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          userType: widget.selectedUserType,
        );

        if (success && mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const DashboardScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur d\'inscription: ${e.toString()}'),
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
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // En-tête
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        widget.selectedUserType == UserType.producteur
                            ? Icons.agriculture
                            : Icons.trending_up,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Inscription ${widget.selectedUserType == UserType.producteur ? 'Producteur' : 'Investisseur'}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Créez votre compte pour commencer',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Formulaire
                CustomTextField(
                  label: 'Nom complet',
                  controller: _nameController,
                  isRequired: true,
                ),

                const SizedBox(height: 24),

                EmailTextField(label: 'Email', controller: _emailController),

                const SizedBox(height: 24),

                PhoneTextField(
                  label: 'Téléphone',
                  controller: _phoneController,
                ),

                const SizedBox(height: 24),

                CustomTextField(
                  label: 'Mot de passe',
                  controller: _passwordController,
                  isPassword: true,
                  validator: _validatePassword,
                ),

                const SizedBox(height: 24),

                CustomTextField(
                  label: 'Confirmer le mot de passe',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: _validateConfirmPassword,
                ),

                const SizedBox(height: 32),

                // Bouton d'inscription
                PrimaryButton(
                  text: 'S\'inscrire',
                  onPressed: _register,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 24),

                // Conditions d'utilisation
                const Text(
                  'En vous inscrivant, vous acceptez nos conditions d\'utilisation et notre politique de confidentialité.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
