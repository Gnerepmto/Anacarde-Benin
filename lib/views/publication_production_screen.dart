import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/production_provider.dart';
import '../views/colors/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_text_field.dart';

/// Écran de publication de production avec formulaire complet
class PublicationProductionScreen extends StatefulWidget {
  const PublicationProductionScreen({super.key});

  @override
  State<PublicationProductionScreen> createState() =>
      _PublicationProductionScreenState();
}

class _PublicationProductionScreenState
    extends State<PublicationProductionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs du formulaire
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantiteController = TextEditingController();
  final _prixController = TextEditingController();
  final _localisationController = TextEditingController();

  // Nouveaux contrôleurs pour les champs d'investissement
  final _quantiteAnnuelleController = TextEditingController();
  final _hectaresAnacardiersController = TextEditingController();
  final _hectaresTotauxController = TextEditingController();
  final _montantInvestissementController = TextEditingController();
  final _modalitesRemboursementController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _adresseController = TextEditingController();

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
    _quantiteAnnuelleController.dispose();
    _hectaresAnacardiersController.dispose();
    _hectaresTotauxController.dispose();
    _montantInvestissementController.dispose();
    _modalitesRemboursementController.dispose();
    _telephoneController.dispose();
    _adresseController.dispose();
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
        // Nouveaux champs
        quantiteAnnuelle: double.parse(_quantiteAnnuelleController.text),
        hectaresAnacardiers: double.parse(_hectaresAnacardiersController.text),
        hectaresTotaux: double.parse(_hectaresTotauxController.text),
        montantInvestissement: double.parse(
          _montantInvestissementController.text,
        ),
        modalitesRemboursement: _modalitesRemboursementController.text.trim(),
        telephone: _telephoneController.text.trim(),
        adresse: _adresseController.text.trim(),
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Production publiée avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Publier une production', style: TextStyle(color: Colors.white),),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.keyboard_backspace_rounded, color: Colors.white,)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre de la section
              const Text(
                'Informations de base',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Titre de la production
              CustomTextField(
                controller: _titleController,
                label: 'Titre de la production',
                hint: 'Ex: Anacardes de qualité supérieure',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un titre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Décrivez votre production...',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quantité et prix
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _quantiteController,
                      label: 'Quantité disponible',
                      hint: '500',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir la quantité';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Veuillez saisir un nombre valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnite,
                      decoration: const InputDecoration(
                        labelText: 'Unité',
                        border: OutlineInputBorder(),
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
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _prixController,
                      label: 'Prix unitaire',
                      hint: '1200',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir le prix';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Veuillez saisir un nombre valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDevise,
                      decoration: const InputDecoration(
                        labelText: 'Devise',
                        border: OutlineInputBorder(),
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
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Section investissement
              const Text(
                'Informations d\'investissement',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Quantité annuelle
              CustomTextField(
                controller: _quantiteAnnuelleController,
                label: 'Quantité de noix produite par an',
                hint: '2000 kg/an',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la production annuelle';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez saisir un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Hectares
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _hectaresAnacardiersController,
                      label: 'Hectares d\'anacardiers',
                      hint: '5.0 ha',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir les hectares';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Veuillez saisir un nombre valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _hectaresTotauxController,
                      label: 'Hectares totaux possédés',
                      hint: '8.0 ha',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir les hectares totaux';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Veuillez saisir un nombre valide';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Montant d'investissement
              CustomTextField(
                controller: _montantInvestissementController,
                label: 'Montant d\'investissement recherché',
                hint: '500000 $_selectedDevise',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le montant d\'investissement';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez saisir un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Modalités de remboursement
              CustomTextField(
                controller: _modalitesRemboursementController,
                label: 'Modalités de remboursement',
                hint: 'Ex: Remboursement sur 2 ans avec 8% d\'intérêt annuel',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir les modalités de remboursement';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Section contact
              const Text(
                'Informations de contact',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Localité
              CustomTextField(
                controller: _localisationController,
                label: 'Localité',
                hint: 'Ex: Parakou, Bénin',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la localité';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Téléphone
              CustomTextField(
                controller: _telephoneController,
                label: 'Numéro de téléphone',
                hint: '+229 90 12 34 56',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le numéro de téléphone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Adresse
              CustomTextField(
                controller: _adresseController,
                label: 'Adresse complète',
                hint: 'Ex: Quartier Zongo, Parakou, Bénin',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir l\'adresse';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Section image
              const Text(
                'Image de la production',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Sélection d'image
              GestureDetector(
                onTap: _showImagePickerDialog,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _selectedImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            _selectedImagePath!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ajouter une photo',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Bouton de publication
              SizedBox(
                width: double.infinity,
                height: 56,
                child: PrimaryButton(
                  text: 'Publier la production',
                  onPressed: _isLoading ? null : _submitForm,
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
