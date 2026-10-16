import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/features/auth/home_page.dart';
import 'package:flutter_application_1/core/features/auth/sign_in_page.dart';
import 'package:flutter_application_1/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return StreamBuilder<User?>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Unable to check your login status.')),
          );
        }

        if (snapshot.data != null) {
          return const HomeScreen();
        }

        return const SignInPage();
      },
    );
  }
}
