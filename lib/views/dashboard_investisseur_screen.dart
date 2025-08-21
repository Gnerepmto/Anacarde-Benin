import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/production_provider.dart';
import '../models/production_model.dart';
import '../views/colors/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/production_card.dart';
import '../widgets/stat_card.dart';
import 'detail_production_screen.dart';
import 'historique_investissements_screen.dart';
import 'notifications_screen.dart';
import 'productions_investisseur_screen.dart';

/// Dashboard pour les investisseurs
class DashboardInvestisseurScreen extends StatefulWidget {
  const DashboardInvestisseurScreen({super.key});

  @override
  State<DashboardInvestisseurScreen> createState() =>
      _DashboardInvestisseurScreenState();
}

class _DashboardInvestisseurScreenState
    extends State<DashboardInvestisseurScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    _HomeTab(
      onTabChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    ),
    const _ProductionsTab(),
    const _InvestissementsTab(),
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
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Productions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Investissements',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

/// Onglet Accueil
class _HomeTab extends StatelessWidget {
  final Function(int) onTabChanged;

  const _HomeTab({required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
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
                              authProvider.currentUser?.name ?? 'Investisseur',
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
                crossAxisSpacing: 14,
                mainAxisSpacing: 10,
                childAspectRatio: 0.95,
                children: [
                  StatCard(
                    title: 'Investissements',
                    value: '3',
                    icon: Icons.trending_up,
                    color: AppColors.secondary,
                  ),
                  StatCard(
                    title: 'Productions vues',
                    value: '12',
                    icon: Icons.visibility,
                    color: AppColors.info,
                  ),
                  StatCard(
                    title: 'Montant investi',
                    value: '450k FCFA',
                    icon: Icons.attach_money,
                    color: AppColors.success,
                  ),
                  StatCard(
                    title: 'Productions suivies',
                    value: '5',
                    icon: Icons.favorite,
                    color: AppColors.primary,
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
                      text: 'Voir les productions',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const ProductionsInvestisseurScreen(),
                          ),
                        );
                      },
                      icon: Icons.search,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: PrimaryButton(
                      text: 'Mes investissements',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const HistoriqueInvestissementsScreen(),
                          ),
                        );
                      },
                      icon: Icons.trending_up,
                      isOutlined: true,
                    ),
                  ),
                ],
              ),

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
                      onTabChanged(1); // Index de l'onglet Productions
                    },
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(
                        color: AppColors.secondary,
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
                  final recentProductions = productionProvider.productions
                      .where((p) => p.status == ProductionStatus.validee)
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
                              'Aucune production disponible',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Les producteurs publieront bientôt leurs productions',
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailProductionScreen(
                                production: production,
                              ),
                            ),
                          );
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
  }
}

/// Onglet Productions
class _ProductionsTab extends StatefulWidget {
  const _ProductionsTab();

  @override
  State<_ProductionsTab> createState() => _ProductionsTabState();
}

class _ProductionsTabState extends State<_ProductionsTab> {
  String _selectedCategory = 'Toutes';
  String _selectedStatus = 'Toutes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Productions',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.secondary),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterChip('Catégorie', _selectedCategory),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildFilterChip('Statut', _selectedStatus)),
              ],
            ),
          ),

          // Liste des productions
          Expanded(
            child: Consumer<ProductionProvider>(
              builder: (context, productionProvider, child) {
                if (productionProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  );
                }

                final productions = productionProvider.productions
                    .where((p) => p.status == ProductionStatus.validee)
                    .toList();

                if (productions.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_outlined,
                          size: 80,
                          color: AppColors.textLight,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Aucune production disponible',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Aucune production ne correspond à vos critères',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailProductionScreen(production: production),
                          ),
                        );
                      },
                      onInvestir: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailProductionScreen(production: production),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return InkWell(
      onTap: () {
        if (label == 'Catégorie') {
          _showCategoryFilter();
        } else {
          _showStatusFilter();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Text(
              '$label: $value',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filtres',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Ajouter les options de filtre ici
          ],
        ),
      ),
    );
  }

  void _showCategoryFilter() {
    // Implémenter le filtre par catégorie
  }

  void _showStatusFilter() {
    // Implémenter le filtre par statut
  }
}

/// Onglet Investissements
class _InvestissementsTab extends StatelessWidget {
  const _InvestissementsTab();

  @override
  Widget build(BuildContext context) {
    return const HistoriqueInvestissementsScreen();
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
                    color: AppColors.secondary.withOpacity(0.1),
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
                          color: AppColors.secondary,
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
        leading: Icon(icon, color: AppColors.secondary),
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
