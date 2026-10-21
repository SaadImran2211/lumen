import 'package:flutter/material.dart';
import 'package:lumen/features/auth/authpages/sign_in_page.dart';
import 'package:lumen/features/auth/authprovider/auth_provider.dart';
import 'package:lumen/features/auth/domain/entities/user_entity.dart';
import 'package:lumen/features/home/pages/home_page.dart';
import 'package:provider/provider.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<LumenAuthProvider>();

    return StreamBuilder<UserEntity?>(
      stream: auth.authStateChanges,
      initialData: auth.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Unable to check authentication status.')),
          );
        }
        return snapshot.data == null ? const SignInPage() : const HomePage();
      },
    );
  }
}
