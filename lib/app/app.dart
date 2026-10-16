import 'package:flutter/material.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class CareerTwinApp extends StatelessWidget {
  const CareerTwinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Career Twin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
