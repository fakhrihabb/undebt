import 'package:flutter/material.dart';
import 'package:undebt/core/constants/app_colors.dart';

/// Character header widget showing avatar, level, and XP progress
class CharacterHeader extends StatelessWidget {
  final String name;
  final int level;
  final int currentXP;
  final int nextLevelXP;
  final String? avatarUrl;

  const CharacterHeader({
    super.key,
    required this.name,
    required this.level,
    required this.currentXP,
    required this.nextLevelXP,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final xpProgress = currentXP / nextLevelXP;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue.withValues(alpha: 0.2),
            AppColors.skyBlue.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar with level badge
          Stack(
            children: [
              // Avatar circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              // Level badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.rewardGold,
                    border: Border.all(
                      color: AppColors.surfaceDark,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.rewardGold.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$level',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Name and XP progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Level text
                Text(
                  'Level $level Debt Slayer',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textOnDark.withValues(alpha: 0.7),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // XP Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'XP',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textOnDark.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          '$currentXP / $nextLevelXP',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textOnDark.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Progress bar
                    Stack(
                      children: [
                        // Background
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Progress
                        FractionallySizedBox(
                          widthFactor: xpProgress.clamp(0.0, 1.0),
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withValues(alpha: 0.4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
