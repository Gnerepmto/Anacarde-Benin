import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/production_provider.dart';
import '../views/colors/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_text_field.dart';

/// Écran de publication de production
class PublicationProductionScreen extends StatefulWidget {
  const PublicationProductionScreen({super.key});

  @override
  State<PublicationProductionScreen> createState() =>
      _PublicationProductionScreenState();
}

class _PublicationProductionScreenState
    extends State<PublicationProductionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantiteController = TextEditingController();
  final _prixController = TextEditingController();
  final _localisationController = TextEditingController();

  String _selectedUnite = 'kg';
  String _selectedDevise = 'FCFA';
  DateTime _selectedDate = DateTime.now();
  String? _selectedImagePath;
  List<String> _selectedTags = [];
  bool _isLoading = false;

  final List<String> _unites = ['kg', 'tonnes', 'sacs'];
  final List<String> _devises = ['FCFA', 'EUR', 'USD'];
  final List<String> _availableTags = [
    'bio',
    'premium',
    'transforme',
    'grille',
    'coque',
    'stockage',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantiteController.dispose();
    _prixController.dispose();
    _localisationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choisir une image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _takePhoto();
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Appareil photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage();
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galerie'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _publishProduction() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final productionProvider = Provider.of<ProductionProvider>(
          context,
          listen: false,
        );
        final success = await productionProvider.addProduction(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          quantite: double.parse(_quantiteController.text),
          unite: _selectedUnite,
          prixUnitaire: double.parse(_prixController.text),
          devise: _selectedDevise,
          localisation: _localisationController.text.trim(),
          dateRecolte: _selectedDate,
          imageUrl: _selectedImagePath,
          tags: _selectedTags,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Production publiée avec succès !'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la publication: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Publier une production',
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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image de la production
              _buildImageSection(),

              const SizedBox(height: 24),

              // Informations de base
              CustomTextField(
                label: 'Titre de la production',
                controller: _titleController,
                isRequired: true,
                hint: 'Ex: Anacardes de qualité supérieure',
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'Description',
                controller: _descriptionController,
                isRequired: true,
                maxLines: 3,
                hint:
                    'Décrivez votre production, la qualité, les conditions de culture...',
              ),

              const SizedBox(height: 16),

              // Quantité et prix
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Quantité',
                      controller: _quantiteController,
                      isRequired: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Unité',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedUnite,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.textLight,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                          items: _unites.map((unite) {
                            return DropdownMenuItem(
                              value: unite,
                              child: Text(unite),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedUnite = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Prix unitaire',
                      controller: _prixController,
                      isRequired: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Devise',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedDevise,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.textLight,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                          items: _devises.map((devise) {
                            return DropdownMenuItem(
                              value: devise,
                              child: Text(devise),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDevise = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'Localisation',
                controller: _localisationController,
                isRequired: true,
                hint: 'Ex: Parakou, Bénin',
              ),

              const SizedBox(height: 16),

              // Date de récolte
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Date de récolte',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.textLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Tags
              const Text(
                'Tags (optionnel)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) => _toggleTag(tag),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Bouton de publication
              PrimaryButton(
                text: 'Publier la production',
                onPressed: _publishProduction,
                isLoading: _isLoading,
                icon: Icons.publish,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photo de la production',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        if (_selectedImagePath != null) ...[
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.surface,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                _selectedImagePath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.background,
                    child: const Icon(
                      Icons.image,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        InkWell(
          onTap: _showImagePickerDialog,
          child: Container(
            width: double.infinity,
            height: _selectedImagePath != null ? 60 : 120,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.textLight.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _selectedImagePath != null ? Icons.edit : Icons.add_a_photo,
                  size: _selectedImagePath != null ? 24 : 32,
                  color: AppColors.textSecondary,
                ),
                if (_selectedImagePath == null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Ajouter une photo',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

