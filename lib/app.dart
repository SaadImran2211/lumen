import 'package:flutter/material.dart';
import 'package:lumen/core/routers/app_router.dart';
import 'package:lumen/core/theme/app_colors.dart';

class LumenApp extends StatelessWidget {
  const LumenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.coral),
      ),
      initialRoute: AppRouter.wrapper,
      routes: AppRouter.routes,
    );
  }
}
