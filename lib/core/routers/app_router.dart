import 'package:flutter/material.dart';
import 'package:lumen/features/auth/authpages/create_account_page.dart';
import 'package:lumen/features/auth/authpages/sign_in_page.dart';
import 'package:lumen/features/auth/authpages/wrapper_screen.dart';

class AppRouter {
  AppRouter._();

  static const String wrapper = '/';
  static const String signIn = '/sign-in';
  static const String signUp = '/create-account';

  static Map<String, WidgetBuilder> get routes => {
    wrapper: (_) => const WrapperScreen(),
    signIn: (_) => const SignInPage(),
    signUp: (_) => const CreateAccountPage(),
  };
}
