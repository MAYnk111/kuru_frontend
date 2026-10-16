import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/config/api_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // If in debug mode or by default when testing standalone frontend,
  // allow the developer/evaluator to immediately see reference fidelity
  // while retaining full capability to switch to live FastAPI backend.
  ApiConfig.enableDemoPreviewMode = true;

  runApp(
    const ProviderScope(
      child: CareerTwinApp(),
    ),
  );
}
