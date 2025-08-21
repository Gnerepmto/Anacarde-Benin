import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/production_provider.dart';
import '../views/colors/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/production_card.dart';
import '../widgets/stat_card.dart';
import 'publication_production_screen.dart';
import 'formations_screen.dart';
import 'notifications_screen.dart';

/// Dashboard pour les producteurs
class DashboardProducteurScreen extends StatefulWidget {
  const DashboardProducteurScreen({super.key});

  @override
  State<DashboardProducteurScreen> createState() =>
      _DashboardProducteurScreenState();
}

class _DashboardProducteurScreenState extends State<DashboardProducteurScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const _ProductionsTab(),
    const _FormationsTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Productions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Formations',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

/// Onglet Accueil
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductionProvider>(
      builder: (context, productionProvider, child) {
        final stats = productionProvider.getProducteurStats();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête avec notifications
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bonjour,',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                return Text(
                                  authProvider.currentUser?.name ??
                                      'Producteur',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Statistiques
                  const Text(
                    'Vos statistiques',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.8,
                    children: [
                      StatCard(
                        title: 'Productions',
                        value: stats['total'].toString(),
                        icon: Icons.inventory,
                        color: AppColors.primary,
                      ),
                      StatCard(
                        title: 'Validées',
                        value: stats['validees'].toString(),
                        icon: Icons.check_circle,
                        color: AppColors.success,
                      ),
                      StatCard(
                        title: 'Vues totales',
                        value: stats['totalVues'].toString(),
                        icon: Icons.visibility,
                        color: AppColors.info,
                      ),
                      StatCard(
                        title: 'Intéressés',
                        value: stats['totalInteresses'].toString(),
                        icon: Icons.favorite,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Actions rapides
                  const Text(
                    'Actions rapides',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: PrimaryButton(
                          text: 'Publier une production',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PublicationProductionScreen(),
                              ),
                            );
                          },
                          icon: Icons.add,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: PrimaryButton(
                          text: 'Voir les formations',
                          onPressed: () {
                            // Changer vers l'onglet formations
                            // Note: Dans une vraie app, on utiliserait un provider pour gérer la navigation
                          },
                          icon: Icons.school,
                          isOutlined: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  const SizedBox(height: 48),

                  // Productions récentes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Productions récentes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Changer vers l'onglet productions
                        },
                        child: const Text(
                          'Voir tout',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Liste des productions récentes
                  Consumer<ProductionProvider>(
                    builder: (context, productionProvider, child) {
                      final recentProductions = productionProvider
                          .mesProductions
                          .take(3)
                          .toList();

                      if (recentProductions.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(32),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inventory_outlined,
                                  size: 64,
                                  color: AppColors.textLight,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Aucune production pour le moment',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Commencez par publier votre première production',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textLight,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: recentProductions.map((production) {
                          return CompactProductionCard(
                            production: production,
                            onTap: () {
                              // Naviguer vers le détail de la production
                            },
                          );
                        }).toList(),
                      );
                    },
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

/// Onglet Productions
class _ProductionsTab extends StatelessWidget {
  const _ProductionsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mes Productions',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PublicationProductionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductionProvider>(
        builder: (context, productionProvider, child) {
          if (productionProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final productions = productionProvider.mesProductions;

          if (productions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_outlined,
                    size: 80,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Aucune production',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Commencez par publier votre première production',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Publier une production',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const PublicationProductionScreen(),
                        ),
                      );
                    },
                    icon: Icons.add,
                    width: 200,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: productions.length,
            itemBuilder: (context, index) {
              final production = productions[index];
              return ProductionCard(
                production: production,
                onTap: () {
                  // Naviguer vers le détail de la production
                },
                showActions: false,
              );
            },
          );
        },
      ),
    );
  }
}

/// Onglet Formations
class _FormationsTab extends StatelessWidget {
  const _FormationsTab();

  @override
  Widget build(BuildContext context) {
    return const FormationsScreen();
  }
}

/// Onglet Profil
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mon Profil',
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
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Photo de profil
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: user?.profileImage != null
                      ? ClipOval(
                          child: Image.network(
                            user!.profileImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.primary,
                        ),
                ),

                const SizedBox(height: 24),

                // Informations utilisateur
                Text(
                  user?.name ?? 'Nom non défini',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  user?.email ?? 'Email non défini',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // Options du profil
                _buildProfileOption(
                  icon: Icons.edit,
                  title: 'Modifier le profil',
                  onTap: () {
                    // Naviguer vers la modification du profil
                  },
                ),

                _buildProfileOption(
                  icon: Icons.settings,
                  title: 'Paramètres',
                  onTap: () {
                    // Naviguer vers les paramètres
                  },
                ),

                _buildProfileOption(
                  icon: Icons.help,
                  title: 'Aide et support',
                  onTap: () {
                    // Naviguer vers l'aide
                  },
                ),

                _buildProfileOption(
                  icon: Icons.info,
                  title: 'À propos',
                  onTap: () {
                    // Naviguer vers les informations
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
