import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:undebt/core/constants/app_colors.dart';
import 'package:undebt/core/models/debt_model.dart';
import 'package:undebt/core/widgets/button_3d.dart';
import 'package:undebt/core/utils/currency_formatter.dart';

/// Monster card widget for displaying a debt
class MonsterCard extends StatelessWidget {
  final DebtModel debt;
  final bool isPriority;
  final VoidCallback? onTap;

  const MonsterCard({
    super.key,
    required this.debt,
    this.isPriority = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.push('/debt-detail/${debt.id}'),
      child: Stack(
        children: [
          // Main card with 3D effect
          Card3D(
            depth: 6,
            backgroundColor: AppColors.surfaceDark,
            borderRadius: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: isPriority
                    ? Border.all(
                        width: 2,
                        color: AppColors.rewardGold,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Monster display section with 3D grid plane
                  _build3DGridPlane(context),

                  // Debt details section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Monster name and debt details
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getMonsterData()['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: AppColors.textOnDark,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${debt.name} • ${debt.debtType}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textOnDark
                                              .withValues(alpha: 0.6),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            // APR fire icons
                            _buildAprIndicator(),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Health bar
                        _buildHealthBar(context),

                        const SizedBox(height: 16),

                        // Stats row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem(
                              context,
                              label: 'Balance',
                              value: CurrencyFormatter.format(debt.currentBalance),
                            ),
                            _buildStatItem(
                              context,
                              label: 'Minimum',
                              value: CurrencyFormatter.format(debt.minimumPayment),
                            ),
                            _buildStatItem(
                              context,
                              label: 'Progress',
                              value: '${debt.percentPaid.toStringAsFixed(0)}%',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Priority badge
          if (isPriority)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.rewardGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.rewardGold.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'CURRENT TARGET',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build 3D grid plane with monster sprite
  Widget _build3DGridPlane(BuildContext context) {
    final monsterData = _getMonsterData();
    
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            monsterData['color'].withValues(alpha: 0.3),
            monsterData['color'].withValues(alpha: 0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: monsterData['color'].withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: monsterData['color'],
              width: 2,
            ),
          ),
          child: Icon(
            monsterData['icon'],
            size: 64,
            color: monsterData['color'],
          ),
        ),
      ),
    );
  }

  /// Get monster data based on type
  Map<String, dynamic> _getMonsterData() {
    switch (debt.monsterType) {
      case 'dragon':
        return {
          'name': 'Inferno Dragon',
          'icon': Icons.local_fire_department_rounded,
          'color': const Color(0xFFDC2626),
        };
      case 'giant':
        return {
          'name': 'Debt Titan',
          'icon': Icons.fitness_center_rounded,
          'color': const Color(0xFF7C3AED),
        };
      case 'goblin':
        return {
          'name': 'Credit Goblin',
          'icon': Icons.credit_card_rounded,
          'color': AppColors.skyBlue,
        };
      case 'wizard':
        return {
          'name': 'Loan Sorcerer',
          'icon': Icons.school_rounded,
          'color': const Color(0xFF4F46E5),
        };
      case 'beast':
        return {
          'name': 'Payment Beast',
          'icon': Icons.directions_car_rounded,
          'color': AppColors.success,
        };
      case 'slime':
      default:
        return {
          'name': 'Debt Slime',
          'icon': Icons.bubble_chart_rounded,
          'color': const Color(0xFF0D9488),
        };
    }
  }

  /// Build APR fire indicator
  Widget _buildAprIndicator() {
    Color fireColor;
    if (debt.apr >= 20) {
      fireColor = AppColors.aprHigh;
    } else if (debt.apr >= 10) {
      fireColor = AppColors.aprMedium;
    } else {
      fireColor = AppColors.aprLow;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        debt.fireIconCount,
        (index) => Icon(
          Icons.local_fire_department,
          color: fireColor,
          size: 20,
        ),
      ),
    );
  }

  /// Build health bar
  Widget _buildHealthBar(BuildContext context) {
    Color barColor;
    final progress = debt.percentPaid / 100;
    final healthPercent = 100 - debt.percentPaid;

    if (debt.percentPaid >= 100) {
      barColor = AppColors.progressComplete;
    } else if (debt.percentPaid >= 67) {
      barColor = AppColors.progressHigh;
    } else if (debt.percentPaid >= 34) {
      barColor = AppColors.progressMedium;
    } else {
      barColor = AppColors.progressLow;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Health',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textOnDark.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '${healthPercent.toStringAsFixed(0)}% Health',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: barColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Background
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.textOnDark.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Progress fill
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      barColor,
                      barColor.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          barColor,
                          barColor.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build stat item
  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textOnDark.withValues(alpha: 0.6),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
