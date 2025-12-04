import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:undebt/core/constants/app_colors.dart';
import 'package:undebt/core/providers/user_provider.dart';
import 'package:undebt/core/providers/debt_provider.dart';
import 'package:undebt/core/widgets/button_3d.dart';
import 'package:undebt/features/dashboard/widgets/character_header.dart';
import 'package:undebt/features/dashboard/widgets/stat_card.dart';
import 'package:undebt/features/dashboard/widgets/monster_card.dart';
import 'package:undebt/core/utils/currency_formatter.dart';

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
        child: Consumer2<UserProvider, DebtProvider>(
          builder: (context, userProvider, debtProvider, child) {
            final user = userProvider.user;
            
            if (user == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final prioritizedDebts = debtProvider.getPrioritizedDebts();
            final totalDebt = debtProvider.getTotalDebt();
            final monthlyPayment = debtProvider.getTotalMonthlyPayment();
            final debtFreeDate = debtProvider.getDebtFreeDate();
            final interestToPay = debtProvider.getTotalInterestToPay();

            return RefreshIndicator(
              onRefresh: () async {
                await debtProvider.loadDebts();
              },
              color: AppColors.primaryBlue,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 90), // Extra bottom padding for nav bar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Character Header
                    CharacterHeader(
                      name: user.email.split('@')[0], // Use email username as name
                      level: user.level,
                      currentXP: user.totalXp,
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
                      childAspectRatio: 1.0, // Square cards
                      children: [
                        StatCard(
                          imagePath: 'assets/images/quick-stats-icons/1.png',
                          label: 'Total Debt',
                          value: CurrencyFormatter.format(totalDebt),
                        ),
                        StatCard(
                          imagePath: 'assets/images/quick-stats-icons/2.png',
                          label: 'Monthly Payment',
                          value: CurrencyFormatter.format(monthlyPayment),
                        ),
                        StatCard(
                          imagePath: 'assets/images/quick-stats-icons/3.png',
                          label: 'Debt-Free Date',
                          value: debtFreeDate != null
                              ? DateFormat('MMM yyyy').format(debtFreeDate)
                              : 'N/A',
                        ),
                        StatCard(
                          imagePath: 'assets/images/quick-stats-icons/4.png',
                          label: 'Interest to Pay',
                          value: CurrencyFormatter.format(interestToPay),
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
                          '${prioritizedDebts.length} ${prioritizedDebts.length == 1 ? 'debt' : 'debts'}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textOnDark.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Monster Cards or Empty State
                    if (prioritizedDebts.isEmpty)
                      _EmptyState()
                    else
                      ...prioritizedDebts.map((debt) {
                        final isPriority = debt.priority == 1;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: MonsterCard(
                            debt: debt,
                            isPriority: isPriority,
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      
      // Floating Action Button
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlue,
              AppColors.skyBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => context.push('/debt-input'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Add Debt',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
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
