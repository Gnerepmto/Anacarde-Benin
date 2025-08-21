import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Provider pour la gestion de l'authentification
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isFirstLaunch = true;
  UserType? _selectedUserType;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isFirstLaunch => _isFirstLaunch;
  UserType? get selectedUserType => _selectedUserType;

  /// Initialise l'état d'authentification
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      // Vérifier si un utilisateur est connecté
      final userJson = prefs.getString('currentUser');
      if (userJson != null) {
        // Simuler la récupération des données utilisateur
        // En production, cela viendrait de Firebase ou d'une API
        await Future.delayed(const Duration(seconds: 1));
        _currentUser = _getMockUser();
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Connexion utilisateur
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simuler une requête API
      await Future.delayed(const Duration(seconds: 2));

      // Validation simple (en production, cela viendrait du backend)
      if (email.isNotEmpty && password.isNotEmpty) {
        _currentUser = _getMockUser();

        // Sauvegarder en local
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentUser', 'mock_user_data');

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Email ou mot de passe invalide');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Inscription utilisateur
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserType userType,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simuler une requête API
      await Future.delayed(const Duration(seconds: 2));

      // Créer un nouvel utilisateur
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        userType: userType,
        createdAt: DateTime.now(),
      );

      // Sauvegarder en local
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUser', 'mock_user_data');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Supprimer les données locales
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');

      _currentUser = null;
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Marquer l'onboarding comme terminé
  Future<void> completeOnboarding() async {
    _isFirstLaunch = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    notifyListeners();
  }

  /// Définir le type d'utilisateur sélectionné
  void setSelectedUserType(UserType userType) {
    _selectedUserType = userType;
    notifyListeners();
  }

  /// Méthode de test pour définir un utilisateur connecté
  void setCurrentUserForTesting(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Mettre à jour le profil utilisateur
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? profileImage,
  }) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        phone: phone,
        profileImage: profileImage,
      );
      notifyListeners();
    }
  }

  /// Utilisateur mock pour les tests
  UserModel _getMockUser() {
    return UserModel(
      id: '1',
      name: 'Kossi Agbeko',
      email: 'kossi@example.com',
      phone: '+229 90123456',
      userType: _selectedUserType ?? UserType.producteur,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }
}
