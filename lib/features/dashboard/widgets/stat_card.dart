import 'package:flutter/material.dart';
import 'package:undebt/core/constants/app_colors.dart';

/// Stat card widget for displaying dashboard statistics
class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Gradient? gradient;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Shadow layer (3D effect)
        Container(
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // Main card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? AppColors.surfaceDark : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.textOnDark.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primaryBlue).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? AppColors.primaryBlue,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Value
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textOnDark,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // Label
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textOnDark.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
