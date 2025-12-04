import 'dart:math' as math;
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late DateTime createdAt;

  @HiveField(3)
  late String subscriptionStatus; // 'free' or 'premium'

  @HiveField(4)
  DateTime? subscriptionExpires;

  @HiveField(5)
  late String selectedMethod; // 'snowball', 'avalanche', or 'hybrid'

  @HiveField(6)
  late int level;

  @HiveField(7)
  late int totalXp;

  @HiveField(8)
  late double totalDebtDefeated;

  @HiveField(9)
  late double totalInterestSaved;

  @HiveField(10)
  late int currentStreakDays;

  @HiveField(11)
  DateTime? lastCheckIn;

  @HiveField(12)
  late bool notificationsEnabled;

  @HiveField(13)
  late bool soundEnabled;

  @HiveField(14)
  late bool hapticsEnabled;

  @HiveField(15)
  late String darkMode; // 'auto', 'light', or 'dark'

  @HiveField(16)
  late bool onboardingComplete;

  UserModel({
    String? id,
    required this.email,
    DateTime? createdAt,
    String? subscriptionStatus,
    this.subscriptionExpires,
    String? selectedMethod,
    int? level,
    int? totalXp,
    double? totalDebtDefeated,
    double? totalInterestSaved,
    int? currentStreakDays,
    this.lastCheckIn,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? hapticsEnabled,
    String? darkMode,
    bool? onboardingComplete,
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.now();
    this.subscriptionStatus = subscriptionStatus ?? 'free';
    this.selectedMethod = selectedMethod ?? 'snowball';
    this.level = level ?? 1;
    this.totalXp = totalXp ?? 0;
    this.totalDebtDefeated = totalDebtDefeated ?? 0.0;
    this.totalInterestSaved = totalInterestSaved ?? 0.0;
    this.currentStreakDays = currentStreakDays ?? 0;
    this.notificationsEnabled = notificationsEnabled ?? true;
    this.soundEnabled = soundEnabled ?? true;
    this.hapticsEnabled = hapticsEnabled ?? true;
    this.darkMode = darkMode ?? 'auto';
    this.onboardingComplete = onboardingComplete ?? false;
  }

  /// Check if user is premium
  bool get isPremium {
    if (subscriptionStatus != 'premium') return false;
    if (subscriptionExpires == null) return true;
    return DateTime.now().isBefore(subscriptionExpires!);
  }

  /// Calculate XP needed for next level
  int get xpForNextLevel {
    final nextLevel = level + 1;
    return (nextLevel * nextLevel * 100);
  }

  /// Calculate XP progress to next level
  double get xpProgress {
    final currentLevelXp = level * level * 100;
    final nextLevelXp = xpForNextLevel;
    final xpInCurrentLevel = totalXp - currentLevelXp;
    final xpNeededForLevel = nextLevelXp - currentLevelXp;
    
    if (xpNeededForLevel == 0) return 1.0;
    return (xpInCurrentLevel / xpNeededForLevel).clamp(0.0, 1.0);
  }

  /// Update streak based on last check-in
  void updateStreak() {
    final now = DateTime.now();
    
    if (lastCheckIn == null) {
      currentStreakDays = 1;
      lastCheckIn = now;
      return;
    }

    final daysSinceLastCheckIn = now.difference(lastCheckIn!).inDays;
    
    if (daysSinceLastCheckIn == 0) {
      // Same day, no change
      return;
    } else if (daysSinceLastCheckIn == 1) {
      // Consecutive day
      currentStreakDays++;
      lastCheckIn = now;
    } else {
      // Streak broken
      currentStreakDays = 1;
      lastCheckIn = now;
    }
  }

  /// Add XP and check for level up
  bool addXp(int xp) {
    final oldLevel = level;
    totalXp += xp;
    
    // Calculate new level
    level = _calculateLevel(totalXp);
    
    // Return true if leveled up
    return level > oldLevel;
  }

  /// Calculate level from total XP
  int _calculateLevel(int xp) {
    // Level = floor(sqrt(totalXP / 100))
    return math.sqrt(xp / 100).floor().clamp(1, 50);
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? email,
    String? subscriptionStatus,
    DateTime? subscriptionExpires,
    String? selectedMethod,
    int? level,
    int? totalXp,
    double? totalDebtDefeated,
    double? totalInterestSaved,
    int? currentStreakDays,
    DateTime? lastCheckIn,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? hapticsEnabled,
    String? darkMode,
    bool? onboardingComplete,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      createdAt: createdAt,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionExpires: subscriptionExpires ?? this.subscriptionExpires,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      level: level ?? this.level,
      totalXp: totalXp ?? this.totalXp,
      totalDebtDefeated: totalDebtDefeated ?? this.totalDebtDefeated,
      totalInterestSaved: totalInterestSaved ?? this.totalInterestSaved,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      darkMode: darkMode ?? this.darkMode,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'subscription_status': subscriptionStatus,
      'subscription_expires': subscriptionExpires?.toIso8601String(),
      'selected_method': selectedMethod,
      'level': level,
      'total_xp': totalXp,
      'total_debt_defeated': totalDebtDefeated,
      'total_interest_saved': totalInterestSaved,
      'current_streak_days': currentStreakDays,
      'last_check_in': lastCheckIn?.toIso8601String(),
      'notifications_enabled': notificationsEnabled,
      'sound_enabled': soundEnabled,
      'haptics_enabled': hapticsEnabled,
      'dark_mode': darkMode,
      'onboarding_complete': onboardingComplete,
    };
  }

  /// Create from JSON (Supabase)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      subscriptionStatus: json['subscription_status'] as String,
      subscriptionExpires: json['subscription_expires'] != null
          ? DateTime.parse(json['subscription_expires'] as String)
          : null,
      selectedMethod: json['selected_method'] as String,
      level: json['level'] as int,
      totalXp: json['total_xp'] as int,
      totalDebtDefeated: (json['total_debt_defeated'] as num).toDouble(),
      totalInterestSaved: (json['total_interest_saved'] as num).toDouble(),
      currentStreakDays: json['current_streak_days'] as int,
      lastCheckIn: json['last_check_in'] != null
          ? DateTime.parse(json['last_check_in'] as String)
          : null,
      notificationsEnabled: json['notifications_enabled'] as bool,
      soundEnabled: json['sound_enabled'] as bool,
      hapticsEnabled: json['haptics_enabled'] as bool,
      darkMode: json['dark_mode'] as String,
      onboardingComplete: json['onboarding_complete'] as bool,
    );
  }
}
