import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:undebt/core/constants/app_colors.dart';
import 'package:undebt/core/providers/user_provider.dart';
import 'package:undebt/core/widgets/button_3d.dart';
import 'package:undebt/features/dashboard/widgets/character_header.dart';
import 'package:undebt/features/dashboard/widgets/stat_card.dart';

/// Main dashboard screen showing character, stats, and debts
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundDark,
              AppColors.primaryBlue.withValues(alpha: 0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final user = userProvider.user;
              
              if (user == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Character Header
                    CharacterHeader(
                      name: user.name,
                      level: user.level,
                      currentXP: user.xp,
                      nextLevelXP: user.xpForNextLevel,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick Stats
                    Text(
                      'Quick Stats',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Stats Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: const [
                        StatCard(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'Total Debt',
                          value: '\$0',
                          iconColor: AppColors.error,
                        ),
                        StatCard(
                          icon: Icons.calendar_month_rounded,
                          label: 'Monthly Payment',
                          value: '\$0',
                          iconColor: AppColors.warning,
                        ),
                        StatCard(
                          icon: Icons.event_available_rounded,
                          label: 'Debt-Free Date',
                          value: 'N/A',
                          iconColor: AppColors.success,
                        ),
                        StatCard(
                          icon: Icons.savings_rounded,
                          label: 'Interest to Pay',
                          value: '\$0',
                          iconColor: AppColors.primaryBlue,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Your Monsters Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Monsters',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '0 debts',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textOnDark.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Empty State
                    _EmptyState(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/debt-input'),
        backgroundColor: AppColors.rewardGold,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Debt',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card3D(
      padding: const EdgeInsets.all(32),
      backgroundColor: AppColors.surfaceDark,
      child: Column(
        children: [
          // Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pets_rounded,
              size: 100,
              color: AppColors.primaryBlue.withValues(alpha: 0.5),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            'No Monsters Yet!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            'Add your first debt to start your debt-slaying journey. Each debt becomes a monster you can defeat!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textOnDark.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Button
          Button3D(
            onPressed: () => context.push('/debt-input'),
            gradient: AppColors.primaryGradient,
            child: const Text('Add Your First Debt'),
          ),
        ],
      ),
    );
  }
}
