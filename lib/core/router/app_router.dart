import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undebt/features/onboarding/screens/welcome_screen.dart';
import 'package:undebt/features/onboarding/screens/method_quiz_screen.dart';
import 'package:undebt/features/onboarding/screens/debt_input_screen.dart';
import 'package:undebt/core/screens/main_shell.dart';
import 'package:undebt/features/debt/screens/debt_detail_screen.dart';

/// App router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      // Onboarding Routes
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/method-quiz',
        name: 'method-quiz',
        builder: (context, state) => const MethodQuizScreen(),
      ),
      GoRoute(
        path: '/debt-input',
        name: 'debt-input',
        builder: (context, state) => const DebtInputScreen(),
      ),

      // Main App Shell (with bottom navigation)
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const MainShell(),
      ),

      // Detail Routes
      GoRoute(
        path: '/debt/:debtId',
        name: 'debt-detail',
        builder: (context, state) {
          final debtId = state.pathParameters['debtId']!;
          return DebtDetailScreen(debtId: debtId);
        },
      ),
    ],
  );
}
