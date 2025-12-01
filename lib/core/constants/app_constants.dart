/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Undebt';
  static const String appTagline = 'Turn your debt into enemies and defeat them one by one';
  static const String appVersion = '1.0.0';

  // Free Tier Limits
  static const int maxDebtsFreeTier = 3;
  static const int maxLevelFreeTier = 20;

  // XP System
  static const int xpMinimumPayment = 10;
  static const double xpExtraPaymentMultiplier = 0.1; // XP = extra amount / 10
  static const int xpDebtDefeated = 500;
  static const int xpDailyCheckIn = 5;
  static const int xpUpdateDebtInfo = 2;
  static const double xpStreakMultiplier = 1.2;

  // Leveling
  static const int maxLevel = 50;
  static const int xpBaseForLevel = 100; // Level = floor(sqrt(totalXP / 100))

  // Debt Types
  static const List<String> debtTypes = [
    'Credit Card',
    'Personal Loan',
    'Auto Loan',
    'Student Loan',
    'Medical Debt',
    'Mortgage',
    'Other',
  ];

  // Repayment Methods
  static const String methodSnowball = 'snowball';
  static const String methodAvalanche = 'avalanche';
  static const String methodHybrid = 'hybrid';

  // Animation Durations
  static const int paymentAnimationDuration = 2500; // ms
  static const int levelUpAnimationDuration = 3500; // ms
  static const int achievementAnimationDuration = 2000; // ms
  static const int progressBarAnimationDuration = 800; // ms

  // APR Thresholds
  static const double aprLowThreshold = 10.0;
  static const double aprHighThreshold = 20.0;

  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';
  static const String monthYearFormat = 'MMMM yyyy';

  // Validation
  static const double minDebtBalance = 1.0;
  static const double maxDebtBalance = 999999999.99;
  static const double minApr = 0.0;
  static const double maxApr = 50.0;
  static const double minPayment = 0.01;

  // Quick Payment Amounts
  static const List<double> quickPaymentAmounts = [50, 100, 200, 500];

  // Notification Types
  static const String notifPaymentReminder = 'payment_reminder';
  static const String notifWeeklyProgress = 'weekly_progress';
  static const String notifAchievement = 'achievement';
  static const String notifMilestone = 'milestone';
  static const String notifDebtFreeDate = 'debt_free_date';
  static const String notifMotivational = 'motivational';

  // Storage Keys
  static const String keyUserId = 'user_id';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keySelectedMethod = 'selected_method';
  static const String keyDarkMode = 'dark_mode';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyHapticsEnabled = 'haptics_enabled';
  static const String keyNotificationsEnabled = 'notifications_enabled';
}
