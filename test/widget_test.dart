// Test de base pour l'application Anacarde Bénin
//
// Pour effectuer une interaction avec un widget dans votre test, utilisez WidgetTester
// dans le package flutter_test. Par exemple, vous pouvez envoyer des tap et scroll
// gestures. Vous pouvez aussi utiliser WidgetTester pour trouver des widgets enfants
// dans l'arbre des widgets, lire du texte, et vérifier que les valeurs des propriétés
// des widgets sont correctes.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:projetc/main.dart';
import 'package:projetc/providers/auth_provider.dart';
import 'package:projetc/providers/production_provider.dart';
import 'package:projetc/views/splash_screen.dart';

void main() {
  testWidgets('Application démarre correctement', (WidgetTester tester) async {
    // Construire notre application et déclencher un frame
    await tester.pumpWidget(const MyApp());

    // Vérifier que l'application démarre avec le SplashScreen
    expect(find.text('Anacarde Bénin'), findsOneWidget);
    expect(find.text('Connecter producteurs et investisseurs'), findsOneWidget);
  });

  testWidgets('Test de navigation vers l\'onboarding', (
    WidgetTester tester,
  ) async {
    // Construire notre application avec un AuthProvider mock
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ProductionProvider()),
        ],
        child: const MaterialApp(home: SplashScreen()),
      ),
    );

    // Attendre que l'animation du splash se termine
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Vérifier que nous sommes redirigés vers l'onboarding (première utilisation)
    expect(find.text('Bienvenue sur Anacarde Bénin'), findsOneWidget);
  });
}
