import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undebt/features/onboarding/screens/welcome_screen.dart';
import 'package:undebt/features/onboarding/screens/method_quiz_screen.dart';
import 'package:undebt/features/onboarding/screens/debt_input_screen.dart';
import 'package:undebt/features/dashboard/screens/dashboard_screen.dart';
import 'package:undebt/features/progress/screens/progress_screen.dart';
import 'package:undebt/features/achievements/screens/achievements_screen.dart';
import 'package:undebt/features/settings/screens/settings_screen.dart';
import 'package:undebt/features/payment/screens/payment_screen.dart';
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

      // Main App Routes
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/progress',
        name: 'progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/achievements',
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Detail Routes
      GoRoute(
        path: '/payment/:debtId',
        name: 'payment',
        builder: (context, state) {
          final debtId = state.pathParameters['debtId']!;
          return PaymentScreen(debtId: debtId);
        },
      ),
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
