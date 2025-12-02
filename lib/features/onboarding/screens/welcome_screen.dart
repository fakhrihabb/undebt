import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:undebt/core/constants/app_colors.dart';
import 'package:undebt/core/constants/app_constants.dart';
import 'package:undebt/core/theme/app_theme.dart';

/// Welcome screen - modern design with gradients
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                
                // App Logo/Icon with gradient
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.skyBlue.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                ).animate().scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),
                
                const SizedBox(height: 32),
                
                // App Name with gradient text
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 500.ms,
                ),
                
                const SizedBox(height: 16),
                
                // Tagline
                Text(
                  AppConstants.appTagline,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms).slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 500.ms,
                ),
                
                const SizedBox(height: 48),
                
                // Feature Highlights with glass cards
                _FeatureItem(
                  icon: Icons.psychology_outlined,
                  title: 'Science-Backed Methods',
                  description: 'Built on Northwestern & Harvard research',
                  gradient: AppColors.primaryGradient,
                ).animate().fadeIn(delay: 600.ms).slideX(
                  begin: -0.2,
                  end: 0,
                  duration: 400.ms,
                ),
                
                const SizedBox(height: 16),
                
                _FeatureItem(
                  icon: Icons.videogame_asset_outlined,
                  title: 'Gamified Experience',
                  description: 'Turn debts into monsters and defeat them',
                  gradient: AppColors.successGradient,
                ).animate().fadeIn(delay: 700.ms).slideX(
                  begin: -0.2,
                  end: 0,
                  duration: 400.ms,
                ),
                
                const SizedBox(height: 16),
                
                _FeatureItem(
                  icon: Icons.trending_up_outlined,
                  title: 'Track Your Progress',
                  description: 'See your debt-free date and celebrate wins',
                  gradient: AppColors.primaryGradient,
                ).animate().fadeIn(delay: 800.ms).slideX(
                  begin: -0.2,
                  end: 0,
                  duration: 400.ms,
                ),
                
                const Spacer(),
                
                // Get Started Button with gradient
                GradientButton(
                  onPressed: () => context.go('/method-quiz'),
                  gradient: AppColors.primaryGradient,
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ).animate().fadeIn(delay: 1000.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 400.ms,
                  curve: Curves.easeOut,
                ),
                
                const SizedBox(height: 16),
                
                // Skip Button
                TextButton(
                  onPressed: () => context.go('/dashboard'),
                  child: Text(
                    'I already have an account',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ).animate().fadeIn(delay: 1100.ms),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon with gradient background
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
