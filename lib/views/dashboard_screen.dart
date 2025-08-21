import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/production_provider.dart';
import '../views/colors/app_colors.dart';
import '../models/user_model.dart';
import 'dashboard_producteur_screen.dart';
import 'dashboard_investisseur_screen.dart';

/// Écran de dashboard principal avec redirection selon le type d'utilisateur
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    // Initialiser les données nécessaires
    final productionProvider = Provider.of<ProductionProvider>(
      context,
      listen: false,
    );
    await productionProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (!authProvider.isAuthenticated) {
          // Rediriger vers la connexion si non authentifié
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return const SizedBox.shrink();
        }

        // Rediriger vers le bon dashboard selon le type d'utilisateur
        final user = authProvider.currentUser;
        if (user != null) {
          switch (user.userType) {
            case UserType.producteur:
              return const DashboardProducteurScreen();
            case UserType.investisseur:
              return const DashboardInvestisseurScreen();
            case UserType.admin:
              return const AdminDashboardScreen();
          }
        }

        // Fallback
        return const Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: Text(
              'Type d\'utilisateur non reconnu',
              style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
            ),
          ),
        );
      },
    );
  }
}

/// Dashboard pour les administrateurs
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Administration',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textPrimary),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Dashboard Administrateur',
          style: TextStyle(fontSize: 24, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

