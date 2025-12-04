import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:undebt/core/constants/app_colors.dart';
import 'package:undebt/core/providers/debt_provider.dart';
import 'package:undebt/core/widgets/button_3d.dart';
import 'package:undebt/features/dashboard/widgets/monster_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool _showAllMonsters = false;

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
          child: Consumer<DebtProvider>(
            builder: (context, debtProvider, child) {
              final debts = debtProvider.getPrioritizedDebts();
              final totalDebt = debtProvider.getTotalDebt();
              final totalOriginalDebt = debts.fold(
                0.0,
                (sum, debt) => sum + debt.originalBalance,
              );
              final overallProgress = totalOriginalDebt > 0
                  ? ((totalOriginalDebt - totalDebt) / totalOriginalDebt * 100)
                  : 0.0;

              return _showAllMonsters
                  ? _buildMonsterGallery(context, debts)
                  : _buildBattlefield(context, debts, overallProgress);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBattlefield(
    BuildContext context,
    List debts,
    double overallProgress,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Monsters',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textOnDark,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your battlefield of debts to conquer',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textOnDark.withValues(alpha: 0.6),
                ),
          ),

          const SizedBox(height: 32),

          // Accumulative Health Bar
          _buildAccumulativeHealthBar(context, overallProgress),

          const SizedBox(height: 32),

          // 3D Battlefield with monsters
          _build3DBattlefield(context, debts),

          const SizedBox(height: 32),

          // Show All Monsters Button
          Center(
            child: Button3D(
              onPressed: () => setState(() => _showAllMonsters = true),
              gradient: AppColors.primaryGradient,
              child: const Text('Show All Monsters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccumulativeHealthBar(BuildContext context, double progress) {
    final healthPercent = 100 - progress;
    Color barColor;
    
    if (progress >= 100) {
      barColor = AppColors.progressComplete;
    } else if (progress >= 67) {
      barColor = AppColors.progressHigh;
    } else if (progress >= 34) {
      barColor = AppColors.progressMedium;
    } else {
      barColor = AppColors.progressLow;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.textOnDark.withValues(alpha: 0.1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.surfaceDark.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Health',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${healthPercent.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: barColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.textOnDark.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  height: 24,
                  width: double.infinity,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (progress / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [barColor, barColor.withValues(alpha: 0.7)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: barColor.withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3DBattlefield(BuildContext context, List debts) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceDark,
            AppColors.primaryBlue.withValues(alpha: 0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.textOnDark.withValues(alpha: 0.1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.surfaceDark.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Monster sprites scattered on the battlefield
            if (debts.isNotEmpty)
              ...debts.asMap().entries.map((entry) {
                final index = entry.key;
                final debt = entry.value;
                final monsterData = _getMonsterDataForDebt(debt);

                // Position monsters in a scattered pattern
                final positions = [
                  const Offset(0.2, 0.3),
                  const Offset(0.7, 0.4),
                  const Offset(0.5, 0.6),
                  const Offset(0.3, 0.7),
                  const Offset(0.8, 0.7),
                ];

                final position = positions[index % positions.length];

                return Positioned(
                  left: MediaQuery.of(context).size.width * position.dx - 60,
                  top: 300 * position.dy - 60,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: monsterData['color'].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: monsterData['color'],
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: monsterData['color'].withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      monsterData['icon'],
                      size: 40,
                      color: monsterData['color'],
                    ),
                  ),
                );
              }).toList(),

            // Empty state
            if (debts.isEmpty)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 80,
                      color: AppColors.success.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No monsters to fight!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textOnDark.withValues(alpha: 0.7),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonsterGallery(BuildContext context, List debts) {
    return Column(
      children: [
        // Header with back button
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _showAllMonsters = false),
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppColors.textOnDark,
              ),
              const SizedBox(width: 12),
              Text(
                'All Monsters',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),

        // Monster cards list
        Expanded(
          child: debts.isEmpty
              ? Center(
                  child: Text(
                    'No monsters yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textOnDark.withValues(alpha: 0.5),
                        ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                  itemCount: debts.length,
                  itemBuilder: (context, index) {
                    final debt = debts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: MonsterCard(
                        debt: debt,
                        isPriority: debt.priority == 1,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getMonsterDataForDebt(dynamic debt) {
    switch (debt.monsterType) {
      case 'dragon':
        return {
          'icon': Icons.local_fire_department_rounded,
          'color': const Color(0xFFDC2626),
        };
      case 'giant':
        return {
          'icon': Icons.fitness_center_rounded,
          'color': const Color(0xFF7C3AED),
        };
      case 'goblin':
        return {
          'icon': Icons.credit_card_rounded,
          'color': AppColors.skyBlue,
        };
      case 'wizard':
        return {
          'icon': Icons.school_rounded,
          'color': const Color(0xFF4F46E5),
        };
      case 'beast':
        return {
          'icon': Icons.directions_car_rounded,
          'color': AppColors.success,
        };
      case 'slime':
      default:
        return {
          'icon': Icons.bubble_chart_rounded,
          'color': const Color(0xFF0D9488),
        };
    }
  }
}
