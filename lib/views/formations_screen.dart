import 'package:flutter/material.dart';
import '../models/formation_model.dart';
import '../views/colors/app_colors.dart';
import '../widgets/video_card.dart';

/// Écran des formations vidéo
class FormationsScreen extends StatefulWidget {
  const FormationsScreen({super.key});

  @override
  State<FormationsScreen> createState() => _FormationsScreenState();
}

class _FormationsScreenState extends State<FormationsScreen> {
  FormationCategory? _selectedCategory;
  final List<FormationModel> _formations = [
    FormationModel(
      id: '1',
      title: 'Techniques de culture de l\'anacarde',
      description:
          'Apprenez les meilleures pratiques pour cultiver l\'anacarde au Bénin',
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop',
      category: 'culture',
      duree: 15 * 60 + 30, // 15 minutes 30 secondes
      instructeur: 'Dr. Kossi Agbeko',
      datePublication: DateTime.now().subtract(const Duration(days: 5)),
      isActive: true,
      tags: ['culture', 'techniques', 'débutant'],
      vues: 1250,
      note: 4.5,
    ),
    FormationModel(
      id: '2',
      title: 'Gestion des maladies de l\'anacarde',
      description: 'Identification et traitement des maladies courantes',
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop&crop=center',
      category: 'qualite',
      duree: 12 * 60 + 45, // 12 minutes 45 secondes
      instructeur: 'Dr. Fatou Diallo',
      datePublication: DateTime.now().subtract(const Duration(days: 3)),
      isActive: true,
      tags: ['maladies', 'traitement', 'prévention'],
      vues: 890,
      note: 4.8,
    ),
    FormationModel(
      id: '3',
      title: 'Optimisation de la récolte',
      description: 'Techniques pour maximiser le rendement de votre récolte',
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop&crop=entropy',
      category: 'recolte',
      duree: 18 * 60 + 20, // 18 minutes 20 secondes
      instructeur: 'Ing. Jean Akakpo',
      datePublication: DateTime.now().subtract(const Duration(days: 1)),
      isActive: true,
      tags: ['récolte', 'optimisation', 'rendement'],
      vues: 567,
      note: 4.6,
    ),
    FormationModel(
      id: '4',
      title: 'Commercialisation et marketing',
      description: 'Stratégies pour vendre votre production au meilleur prix',
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop&crop=top',
      category: 'commercialisation',
      duree: 22 * 60 + 15, // 22 minutes 15 secondes
      instructeur: 'Mme. Aïcha Traoré',
      datePublication: DateTime.now().subtract(const Duration(hours: 12)),
      isActive: true,
      tags: ['marketing', 'vente', 'prix'],
      vues: 432,
      note: 4.7,
    ),
  ];

  List<FormationModel> get _filteredFormations {
    if (_selectedCategory == null) {
      return _formations;
    }
    return _formations
        .where(
          (f) => f.category == _selectedCategory.toString().split('.').last,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Formations'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implémenter la recherche
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres par catégorie
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Toutes'),
                    selected: _selectedCategory == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...FormationCategory.values.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_getCategoryLabel(category)),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Liste des formations
          Expanded(
            child: _filteredFormations.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.video_library_outlined,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Aucune formation disponible',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredFormations.length,
                    itemBuilder: (context, index) {
                      final formation = _filteredFormations[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: VideoCard(
                          formation: formation,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoPlayerScreen(formation: formation),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(FormationCategory category) {
    switch (category) {
      case FormationCategory.culture:
        return 'Culture';
      case FormationCategory.recolte:
        return 'Récolte';
      case FormationCategory.transformation:
        return 'Transformation';
      case FormationCategory.commercialisation:
        return 'Commercialisation';
      case FormationCategory.financement:
        return 'Financement';
      case FormationCategory.qualite:
        return 'Qualité';
    }
  }
}

/// Écran de lecture vidéo
class VideoPlayerScreen extends StatefulWidget {
  final FormationModel formation;

  const VideoPlayerScreen({super.key, required this.formation});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _totalDuration = Duration(seconds: widget.formation.duree);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.formation.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Zone de lecture vidéo (simulée)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Thumbnail de la vidéo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.formation.thumbnailUrl ??
                          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.video_library,
                            size: 64,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
                  ),

                  // Bouton de lecture
                  if (!_isPlaying)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPlaying = true;
                          });
                          // TODO: Implémenter la lecture vidéo réelle
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Contrôles de lecture
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barre de progression
                Slider(
                  value: _currentPosition.inSeconds.toDouble(),
                  max: _totalDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _currentPosition = Duration(seconds: value.toInt());
                    });
                  },
                  activeColor: AppColors.primary,
                  inactiveColor: Colors.grey[600],
                ),

                // Temps de lecture
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_currentPosition),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      _formatDuration(_totalDuration),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Informations de la formation
                Text(
                  widget.formation.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.formation.description,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 16),

                // Statistiques
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      widget.formation.instructeur,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.visibility, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.formation.vues} vues',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      widget.formation.noteFormatee,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
