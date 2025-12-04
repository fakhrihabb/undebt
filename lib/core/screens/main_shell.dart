import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:undebt/core/providers/navigation_provider.dart';
import 'package:undebt/core/widgets/bottom_nav_bar.dart';
import 'package:undebt/features/dashboard/screens/dashboard_screen.dart';
import 'package:undebt/features/progress/screens/progress_screen.dart';
import 'package:undebt/features/payment/screens/payment_screen.dart';
import 'package:undebt/features/achievements/screens/achievements_screen.dart';
import 'package:undebt/features/settings/screens/settings_screen.dart';

/// Main shell screen with bottom navigation
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static final List<Widget> _screens = [
    const DashboardScreen(),
    const ProgressScreen(),
    const PaymentScreen(),
    const AchievementsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NavigationProvider>(
        builder: (context, navProvider, child) {
          return IndexedStack(
            index: navProvider.currentIndex,
            children: _screens,
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
