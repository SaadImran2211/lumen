import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/features/auth/create_account_page.dart';
import 'package:flutter_application_1/core/features/auth/home_page.dart';
import 'package:flutter_application_1/core/features/auth/sign_in_page.dart';
import 'package:flutter_application_1/core/features/auth/wrapper_screen.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:flutter_application_1/core/providers/home_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
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
      title: 'Lumen',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.coral),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const WrapperScreen(),
        '/home': (_) => const HomeScreen(),
        '/login': (_) => const SignInPage(),
        '/signup': (_) => const CreateAccountPage(),
      },
    );
  }
}

class AppColors {
  static const background = Color(0xFFF5F0E6);
  static const cream = Color(0xFFEDE5D5);
  static const coral = Color(0xFFFF6859);
  static const dark = Color(0xFF1B1916);
  static const muted = Color(0xFF91887D);
  static const green = Color(0xFF163D30);
  static const line = Color(0xFFDED2BE);
}
