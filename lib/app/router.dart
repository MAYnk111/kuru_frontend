import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/discover/data/models/job_model.dart';
import '../features/discover/presentation/screens/job_details_screen.dart';
import '../features/navigation/presentation/screens/main_scaffold_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScaffoldScreen(),
    ),
    GoRoute(
      path: '/jobs/:id',
      builder: (context, state) {
        final jobId = state.pathParameters['id'] ?? '';
        final initialJob = state.extra as JobModel?;
        return JobDetailsScreen(jobId: jobId, initialJob: initialJob);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
