import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../views/colors/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_text_field.dart';
import '../models/user_model.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';

/// Écran de connexion
class LoginScreen extends StatefulWidget {
  final UserType selectedUserType;

  const LoginScreen({super.key, required this.selectedUserType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _emailController = TextEditingController(text: "luciensabropa@gmail.com");
    _passwordController = TextEditingController(text: "12345678");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
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

        final success = await authProvider.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (success && mounted) {
          Navigator.of(context).pushReplacement(
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
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur de connexion: ${e.toString()}'),
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

  void _goToRegister() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RegisterScreen(selectedUserType: widget.selectedUserType),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

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
                      'Connexion ${widget.selectedUserType == UserType.producteur ? 'Producteur' : 'Investisseur'}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connectez-vous à votre compte',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Formulaire
                EmailTextField(
                  label: 'Email',
                  controller: _emailController,
                  // isRequired: true,
                ),

                const SizedBox(height: 24),

                CustomTextField(
                  label: 'Mot de passe',
                  controller: _passwordController,
                  isPassword: true,
                  isRequired: true,
                ),

                const SizedBox(height: 16),

                // Lien mot de passe oublié
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implémenter la récupération de mot de passe
                    },
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: AppColors.primary, fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Bouton de connexion
                PrimaryButton(
                  text: 'Se connecter',
                  onPressed: _login,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 24),

                // Séparateur
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.textLight.withOpacity(0.3),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'ou',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.textLight.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Lien vers l'inscription
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Pas encore de compte ? ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: _goToRegister,
                      child: const Text(
                        'S\'inscrire',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
