import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:undebt/core/constants/app_colors.dart';
import 'package:undebt/core/providers/navigation_provider.dart';

/// Bottom navigation bar with 5 tabs and smooth animations
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.surfaceDark.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Dashboard',
                  index: 0,
                  isActive: navProvider.currentIndex == 0,
                  onTap: () => navProvider.setIndex(0),
                ),
                _NavItem(
                  icon: Icons.payment_rounded,
                  label: 'Payments',
                  index: 1,
                  isActive: navProvider.currentIndex == 1,
                  onTap: () => navProvider.setIndex(1),
                ),
                // Center button with special styling
                _CenterNavButton(
                  icon: Icons.pets_rounded,
                  label: 'Monsters',
                  index: 2,
                  isActive: navProvider.currentIndex == 2,
                  onTap: () => navProvider.setIndex(2),
                ),
                _NavItem(
                  icon: Icons.emoji_events_rounded,
                  label: 'Achievements',
                  index: 3,
                  isActive: navProvider.currentIndex == 3,
                  onTap: () => navProvider.setIndex(3),
                ),
                _NavItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  index: 4,
                  isActive: navProvider.currentIndex == 4,
                  onTap: () => navProvider.setIndex(4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with glow effect when active
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isActive)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Icon(
                      icon,
                      size: 24,
                      color: isActive
                          ? AppColors.primaryBlue
                          : AppColors.textOnDark.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? AppColors.primaryBlue
                      : AppColors.textOnDark.withValues(alpha: 0.6),
                ),
                child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Special center navigation button with circular gradient background
class _CenterNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const _CenterNavButton({
    required this.icon,
    required this.label,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(35),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular gradient button
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: isActive
                      ? AppColors.primaryGradient
                      : LinearGradient(
                          colors: [
                            AppColors.surfaceDark.withValues(alpha: 0.8),
                            AppColors.surfaceDark.withValues(alpha: 0.6),
                          ],
                        ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? AppColors.primaryBlue.withValues(alpha: 0.5)
                        : AppColors.textOnDark.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    if (isActive)
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isActive
                      ? Colors.white
                      : AppColors.textOnDark.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 2),
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? AppColors.primaryBlue
                      : AppColors.textOnDark.withValues(alpha: 0.6),
                ),
                child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
