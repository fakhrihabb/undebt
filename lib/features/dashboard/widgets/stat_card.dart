import 'package:flutter/material.dart';
import 'package:undebt/core/constants/app_colors.dart';

/// Stat card widget for displaying dashboard statistics
class StatCard extends StatelessWidget {
  final String? imagePath; // Path to custom image icon
  final IconData? icon; // Fallback to Material icon
  final String label;
  final String value;
  final Color? iconColor;
  final Gradient? gradient;

  const StatCard({
    super.key,
    this.imagePath,
    this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? AppColors.surfaceDark : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textOnDark.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.surfaceDark.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon centered vertically (takes up space)
          Expanded(
            child: Center(
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      icon ?? Icons.help_outline,
                      size: 56,
                      color: iconColor ?? AppColors.primaryBlue,
                    ),
            ),
          ),
          
          // Value and Label at bottom
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textOnDark,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textOnDark.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
