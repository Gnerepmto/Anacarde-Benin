gi# Anacarde Bénin - Application Mobile

## 📱 Description

Application mobile Flutter pour connecter les producteurs d'anacarde et les investisseurs au Bénin. Cette plateforme facilite la commercialisation de l'anacarde en mettant en relation directe les producteurs locaux avec des investisseurs potentiels.

## 🎯 Fonctionnalités

### Pour les Producteurs
- **Publication de productions** : Publier des annonces avec photos, descriptions et prix
- **Gestion des productions** : Suivre le statut des publications (en attente, validée, vendue)
- **Statistiques** : Visualiser les vues et intérêts pour chaque production
- **Formations** : Accéder à des vidéos de formation sur la culture et transformation
- **Notifications** : Recevoir des alertes sur les investissements et validations

### Pour les Investisseurs
- **Découverte de productions** : Parcourir les productions disponibles avec filtres
- **Investissement** : Investir dans des productions d'anacarde
- **Historique** : Suivre tous les investissements effectués
- **Formations** : Consulter les formations pour comprendre le secteur
- **Notifications** : Recevoir des mises à jour sur les investissements

### Fonctionnalités Générales
- **Authentification** : Inscription et connexion sécurisées
- **Profils utilisateurs** : Gestion des informations personnelles
- **Interface moderne** : Design épuré et responsive
- **Animations fluides** : Transitions et animations pour une meilleure UX

## 🏗️ Architecture

### Structure du Projet
```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/                   # Modèles de données
│   ├── user_model.dart
│   ├── production_model.dart
│   ├── formation_model.dart
│   ├── investissement_model.dart
│   └── notification_model.dart
├── providers/                # Gestion d'état avec Provider
│   ├── auth_provider.dart
│   └── production_provider.dart
├── views/                    # Écrans de l'application
│   ├── colors/
│   │   └── app_colors.dart   # Charte graphique
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── choix_profil_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── dashboard_screen.dart
│   ├── dashboard_producteur_screen.dart
│   ├── dashboard_investisseur_screen.dart
│   ├── publication_production_screen.dart
│   ├── detail_production_screen.dart
│   ├── formations_screen.dart
│   ├── notifications_screen.dart
│   └── historique_investissements_screen.dart
└── widgets/                  # Composants réutilisables
    ├── primary_button.dart
    ├── custom_text_field.dart
    ├── production_card.dart
    ├── video_card.dart
    └── stat_card.dart
```

### Technologies Utilisées
- **Flutter** : Framework de développement mobile
- **Provider** : Gestion d'état
- **SharedPreferences** : Stockage local
- **Image Picker** : Sélection d'images
- **Cached Network Image** : Cache d'images
- **Video Player** : Lecteur vidéo (pour les formations)

## 🎨 Design

### Charte Graphique
- **Couleur principale** : Vert anacarde (#2E7D32)
- **Couleur secondaire** : Orange (#FF8F00)
- **Couleurs neutres** : Blanc, gris clair, gris foncé
- **Couleurs d'état** : Succès (vert), Erreur (rouge), Avertissement (orange), Info (bleu)

### Principes de Design
- **Design épuré** : Interface minimaliste et professionnelle
- **Coins arrondis** : Rayon de 12px minimum pour les éléments
- **Ombres douces** : Élévation subtile pour la hiérarchie visuelle
- **Marges généreuses** : Espacement confortable entre les éléments
- **Typographie claire** : Police lisible avec hiérarchie bien définie

## 🚀 Installation et Configuration

### Prérequis
- Flutter SDK (version 3.8.1 ou supérieure)
- Dart SDK
- Android Studio / VS Code
- Émulateur Android ou appareil physique

### Installation
1. **Cloner le projet**
   ```bash
   git clone [url-du-repo]
   cd projetc
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Lancer l'application**
   ```bash
   flutter run
   ```

### Configuration pour la Production
1. **Mise à jour du pubspec.yaml**
   - Vérifier les versions des dépendances
   - Ajouter les assets nécessaires

2. **Configuration Firebase** (optionnel)
   - Ajouter les fichiers de configuration Firebase
   - Configurer l'authentification et la base de données

3. **Build de l'application**
   ```bash
   # Pour Android
   flutter build apk --release
   
   # Pour iOS
   flutter build ios --release
   ```

## 📱 Écrans Principaux

### 1. SplashScreen
- Animation de démarrage avec logo
- Redirection automatique selon l'état de connexion

### 2. OnboardingScreen
- 3 slides présentant l'application
- Navigation fluide avec indicateurs

### 3. ChoixProfilScreen
- Sélection du type d'utilisateur (Producteur/Investisseur)
- Interface intuitive avec animations

### 4. Authentification
- **LoginScreen** : Connexion avec email/mot de passe
- **RegisterScreen** : Inscription avec validation des champs

### 5. Dashboards
- **DashboardProducteurScreen** : Statistiques, productions, formations
- **DashboardInvestisseurScreen** : Découverte, investissements, formations

### 6. Fonctionnalités Spécialisées
- **PublicationProductionScreen** : Formulaire complet avec upload photo
- **DetailProductionScreen** : Vue détaillée avec actions d'investissement
- **FormationsScreen** : Catalogue de formations vidéo
- **NotificationsScreen** : Centre de notifications
- **HistoriqueInvestissementsScreen** : Suivi des investissements

## 🔧 Fonctionnalités Techniques

### Gestion d'État
- **Provider** pour la gestion globale de l'état
- **AuthProvider** : Authentification et profil utilisateur
- **ProductionProvider** : Gestion des productions et filtres

### Navigation
- **PageRouteBuilder** pour les transitions animées
- **BottomNavigationBar** pour la navigation principale
- **Navigation conditionnelle** selon le type d'utilisateur

### Validation des Données
- **Validation côté client** pour tous les formulaires
- **Messages d'erreur** contextuels et informatifs
- **Formatage automatique** des données (prix, dates, etc.)

### Performance
- **Images en cache** pour un chargement rapide
- **Lazy loading** pour les listes longues
- **Optimisation des animations** pour une expérience fluide

## 🧪 Tests

### Tests Unitaires
```bash
flutter test
```

### Tests d'Intégration
```bash
flutter test integration_test/
```

## 📦 Déploiement

### Android
1. **Générer la clé de signature**
2. **Configurer le build.gradle**
3. **Build APK/AAB**
   ```bash
   flutter build apk --release
   flutter build appbundle --release
   ```

### iOS
1. **Configurer les certificats**
2. **Mettre à jour Info.plist**
3. **Build IPA**
   ```bash
   flutter build ios --release
   ```

## 🔮 Évolutions Futures

### Fonctionnalités Planifiées
- **Chat en temps réel** entre producteurs et investisseurs
- **Paiements intégrés** (Mobile Money, cartes bancaires)
- **Géolocalisation** pour les productions
- **Analytics avancés** pour les producteurs
- **Mode hors ligne** pour les fonctionnalités de base

### Améliorations Techniques
- **Migration vers Firebase** pour la persistance des données
- **Push notifications** pour les mises à jour importantes
- **Mode sombre** pour l'interface utilisateur
- **Support multilingue** (français, anglais, langues locales)

## 🤝 Contribution

### Comment Contribuer
1. **Fork** le projet
2. **Créer une branche** pour votre fonctionnalité
3. **Commiter** vos changements
4. **Pousser** vers la branche
5. **Ouvrir une Pull Request**

### Standards de Code
- **Dart/Flutter conventions** respectées
- **Commentaires** pour les fonctions complexes
- **Tests unitaires** pour les nouvelles fonctionnalités
- **Documentation** mise à jour

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Support

Pour toute question ou problème :
- **Email** : support@anacardebenin.com
- **Issues GitHub** : [Lien vers les issues]
- **Documentation** : [Lien vers la documentation]

---

**Développé avec ❤️ pour l'écosystème anacarde du Bénin**
# Anacarde-Benin
