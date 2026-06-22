import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:karirku_application/core/theme/app_theme.dart';
import 'package:karirku_application/firebase_options.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/splash/splash_screen.dart';
import 'package:karirku_application/services/seed_data.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Seed data removed so it doesn't recreate dummy jobs automatically

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()..listenToJobs()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KarirKu App',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
