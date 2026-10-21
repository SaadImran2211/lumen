import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lumen/app.dart';
import 'package:lumen/features/auth/authprovider/auth_provider.dart';
import 'package:lumen/features/auth/data/firebase_auth_repository.dart';
import 'package:lumen/features/auth/domain/repositories/auth_repository.dart';
import 'package:lumen/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:lumen/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:lumen/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:lumen/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:lumen/features/home/providers/home_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => FirebaseAuthRepository()),
        ProxyProvider<AuthRepository, SignInUseCase>(
          update: (_, repository, __) => SignInUseCase(repository),
        ),
        ProxyProvider<AuthRepository, SignUpUseCase>(
          update: (_, repository, __) => SignUpUseCase(repository),
        ),
        ProxyProvider<AuthRepository, SignOutUseCase>(
          update: (_, repository, __) => SignOutUseCase(repository),
        ),
        ProxyProvider<AuthRepository, ResetPasswordUseCase>(
          update: (_, repository, __) => ResetPasswordUseCase(repository),
        ),
        ChangeNotifierProxyProvider4<
          AuthRepository,
          SignInUseCase,
          SignUpUseCase,
          SignOutUseCase,
          LumenAuthProvider
        >(
          create: (context) => LumenAuthProvider(
            repository: context.read<AuthRepository>(),
            signInUseCase: context.read<SignInUseCase>(),
            signUpUseCase: context.read<SignUpUseCase>(),
            signOutUseCase: context.read<SignOutUseCase>(),
            resetPasswordUseCase: context.read<ResetPasswordUseCase>(),
          ),
          update: (context, repository, signIn, signUp, signOut, previous) =>
              previous ??
              LumenAuthProvider(
                repository: repository,
                signInUseCase: signIn,
                signUpUseCase: signUp,
                signOutUseCase: signOut,
                resetPasswordUseCase: context.read<ResetPasswordUseCase>(),
              ),
        ),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const LumenApp(),
    ),
  );
}
