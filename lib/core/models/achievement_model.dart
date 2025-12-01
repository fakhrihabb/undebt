import 'package:hive/hive.dart';

part 'achievement_model.g.dart';

@HiveType(typeId: 3)
class AchievementModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late String achievementId;

  @HiveField(3)
  late DateTime unlockedAt;

  @HiveField(4)
  late int progress;

  AchievementModel({
    required this.id,
    required this.userId,
    required this.achievementId,
    required this.unlockedAt,
    this.progress = 100,
  });

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'achievement_id': achievementId,
      'unlocked_at': unlockedAt.toIso8601String(),
      'progress': progress,
    };
  }

  /// Create from JSON (Supabase)
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      achievementId: json['achievement_id'] as String,
      unlockedAt: DateTime.parse(json['unlocked_at'] as String),
      progress: json['progress'] as int,
    );
  }
}

/// Achievement definition (not stored in Hive, just definitions)
class AchievementDefinition {
  final String id;
  final String name;
  final String description;
  final String category;
  final String iconName;
  final int targetValue;

  const AchievementDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.iconName,
    this.targetValue = 1,
  });
}

/// All achievement definitions
class Achievements {
  Achievements._();

  // First Steps
  static const welcomeWarrior = AchievementDefinition(
    id: 'welcome_warrior',
    name: 'Welcome Warrior',
    description: 'Create your account',
    category: 'First Steps',
    iconName: 'shield',
  );

  static const battleReady = AchievementDefinition(
    id: 'battle_ready',
    name: 'Battle Ready',
    description: 'Add your first debt',
    category: 'First Steps',
    iconName: 'sword',
  );

  static const firstStrike = AchievementDefinition(
    id: 'first_strike',
    name: 'First Strike',
    description: 'Make your first payment',
    category: 'First Steps',
    iconName: 'attack',
  );

  static const firstBlood = AchievementDefinition(
    id: 'first_blood',
    name: 'First Blood',
    description: 'Eliminate your first debt',
    category: 'First Steps',
    iconName: 'trophy',
  );

  // Progress
  static const doubleTrouble = AchievementDefinition(
    id: 'double_trouble',
    name: 'Double Trouble',
    description: 'Eliminate 2 debts',
    category: 'Progress',
    iconName: 'double_trophy',
    targetValue: 2,
  );

  static const hatTrick = AchievementDefinition(
    id: 'hat_trick',
    name: 'Hat Trick',
    description: 'Eliminate 3 debts',
    category: 'Progress',
    iconName: 'triple_trophy',
    targetValue: 3,
  );

  static const undebChampion = AchievementDefinition(
    id: 'undebt_champion',
    name: 'Undebt Champion',
    description: 'Eliminate 5 debts',
    category: 'Progress',
    iconName: 'champion',
    targetValue: 5,
  );

  static const debtFreeHero = AchievementDefinition(
    id: 'debt_free_hero',
    name: 'Debt-Free Hero',
    description: 'Eliminate all debts',
    category: 'Progress',
    iconName: 'hero',
  );

  // Consistency
  static const weekendWarrior = AchievementDefinition(
    id: 'weekend_warrior',
    name: 'Weekend Warrior',
    description: '7-day login streak',
    category: 'Consistency',
    iconName: 'calendar_week',
    targetValue: 7,
  );

  static const monthlyMaster = AchievementDefinition(
    id: 'monthly_master',
    name: 'Monthly Master',
    description: '30-day login streak',
    category: 'Consistency',
    iconName: 'calendar_month',
    targetValue: 30,
  );

  static const paymentPro = AchievementDefinition(
    id: 'payment_pro',
    name: 'Payment Pro',
    description: 'Make payment 3 months in a row',
    category: 'Consistency',
    iconName: 'consistent',
    targetValue: 3,
  );

  static const neverMiss = AchievementDefinition(
    id: 'never_miss',
    name: 'Never Miss',
    description: '6 months without missing minimum payment',
    category: 'Consistency',
    iconName: 'perfect',
    targetValue: 6,
  );

  // Milestones
  static const firstThousand = AchievementDefinition(
    id: 'first_thousand',
    name: 'First Thousand',
    description: 'Pay \$1,000 in debt',
    category: 'Milestones',
    iconName: 'money_1k',
    targetValue: 1000,
  );

  static const fiveGrand = AchievementDefinition(
    id: 'five_grand',
    name: 'Five Grand',
    description: 'Pay \$5,000 in debt',
    category: 'Milestones',
    iconName: 'money_5k',
    targetValue: 5000,
  );

  static const tenKClub = AchievementDefinition(
    id: 'ten_k_club',
    name: 'Ten K Club',
    description: 'Pay \$10,000 in debt',
    category: 'Milestones',
    iconName: 'money_10k',
    targetValue: 10000,
  );

  static const halfwayHero = AchievementDefinition(
    id: 'halfway_hero',
    name: 'Halfway Hero',
    description: 'Reach 50% debt eliminated',
    category: 'Milestones',
    iconName: 'halfway',
    targetValue: 50,
  );

  // Interest Savings
  static const interestAssassin = AchievementDefinition(
    id: 'interest_assassin',
    name: 'Interest Assassin',
    description: 'Save \$500 in interest',
    category: 'Interest Savings',
    iconName: 'savings_500',
    targetValue: 500,
  );

  static const savingsSavant = AchievementDefinition(
    id: 'savings_savant',
    name: 'Savings Savant',
    description: 'Save \$1,000 in interest',
    category: 'Interest Savings',
    iconName: 'savings_1k',
    targetValue: 1000,
  );

  static const interestKiller = AchievementDefinition(
    id: 'interest_killer',
    name: 'Interest Killer',
    description: 'Save \$5,000 in interest',
    category: 'Interest Savings',
    iconName: 'savings_5k',
    targetValue: 5000,
  );

  /// Get all achievement definitions
  static List<AchievementDefinition> get all => [
        // First Steps
        welcomeWarrior,
        battleReady,
        firstStrike,
        firstBlood,
        // Progress
        doubleTrouble,
        hatTrick,
        undebChampion,
        debtFreeHero,
        // Consistency
        weekendWarrior,
        monthlyMaster,
        paymentPro,
        neverMiss,
        // Milestones
        firstThousand,
        fiveGrand,
        tenKClub,
        halfwayHero,
        // Interest Savings
        interestAssassin,
        savingsSavant,
        interestKiller,
      ];

  /// Get achievement by ID
  static AchievementDefinition? getById(String id) {
    try {
      return all.firstWhere((achievement) => achievement.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get achievements by category
  static List<AchievementDefinition> getByCategory(String category) {
    return all.where((achievement) => achievement.category == category).toList();
  }

  /// Get all categories
  static List<String> get categories => [
        'First Steps',
        'Progress',
        'Consistency',
        'Milestones',
        'Interest Savings',
      ];
}
