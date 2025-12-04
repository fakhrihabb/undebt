import 'package:undebt/core/models/debt_model.dart';
import 'package:undebt/core/constants/app_constants.dart';

/// Debt calculation utilities
class DebtCalculator {
  DebtCalculator._();

  /// Prioritize debts based on selected method
  static List<DebtModel> prioritizeDebts(
    List<DebtModel> debts,
    String method,
  ) {
    final activeDebts = debts.where((debt) => !debt.isDefeated).toList();

    switch (method) {
      case AppConstants.methodSnowball:
        // Sort by smallest balance first
        activeDebts.sort((a, b) => a.currentBalance.compareTo(b.currentBalance));
        break;

      case AppConstants.methodAvalanche:
        // Sort by highest APR first
        activeDebts.sort((a, b) => b.apr.compareTo(a.apr));
        break;

      case AppConstants.methodHybrid:
        // If any debt has APR >= 20%, target highest APR
        // Otherwise, use snowball method
        final highInterestDebts = activeDebts.where((debt) => debt.apr >= 20).toList();
        
        if (highInterestDebts.isNotEmpty) {
          highInterestDebts.sort((a, b) => b.apr.compareTo(a.apr));
          final otherDebts = activeDebts.where((debt) => debt.apr < 20).toList();
          otherDebts.sort((a, b) => a.currentBalance.compareTo(b.currentBalance));
          return [...highInterestDebts, ...otherDebts];
        } else {
          activeDebts.sort((a, b) => a.currentBalance.compareTo(b.currentBalance));
        }
        break;

      default:
        // Default to snowball
        activeDebts.sort((a, b) => a.currentBalance.compareTo(b.currentBalance));
    }

    // Update priorities
    for (int i = 0; i < activeDebts.length; i++) {
      activeDebts[i].priority = i + 1;
    }

    return activeDebts;
  }

  /// Calculate XP earned from a payment
  static int calculateXp({
    required double paymentAmount,
    required double minimumPayment,
    required bool isDebtDefeated,
    required int currentStreak,
  }) {
    int baseXp = 0;

    // Base XP for making minimum payment
    if (paymentAmount >= minimumPayment) {
      baseXp += AppConstants.xpMinimumPayment;
    }

    // Extra XP for payment above minimum
    if (paymentAmount > minimumPayment) {
      final extraAmount = paymentAmount - minimumPayment;
      baseXp += (extraAmount * AppConstants.xpExtraPaymentMultiplier).floor();
    }

    // Bonus XP for defeating debt
    if (isDebtDefeated) {
      baseXp += AppConstants.xpDebtDefeated;
    }

    // Streak multiplier
    if (currentStreak > 0) {
      baseXp = (baseXp * AppConstants.xpStreakMultiplier).floor();
    }

    return baseXp;
  }

  /// Calculate debt-free date based on payment history
  static DateTime? calculateDebtFreeDate({
    required List<DebtModel> debts,
    required double averageMonthlyPayment,
  }) {
    if (averageMonthlyPayment <= 0) return null;

    final activeDebts = debts.where((debt) => !debt.isDefeated).toList();
    if (activeDebts.isEmpty) return DateTime.now();

    double totalDebt = activeDebts.fold(0, (sum, debt) => sum + debt.currentBalance);
    double totalMinimumPayment = activeDebts.fold(0, (sum, debt) => sum + debt.minimumPayment);

    // If average payment is less than total minimums, can't calculate
    if (averageMonthlyPayment < totalMinimumPayment) return null;

    // Simulate month by month
    int monthsToFreedom = 0;
    final maxMonths = 600; // 50 years max
    var simulatedDebts = activeDebts.map((debt) => debt.currentBalance).toList();
    var simulatedAprs = activeDebts.map((debt) => debt.apr).toList();

    while (monthsToFreedom < maxMonths) {
      // Check if all debts paid off
      if (simulatedDebts.every((balance) => balance <= 0)) {
        break;
      }

      // Add monthly interest
      for (int i = 0; i < simulatedDebts.length; i++) {
        if (simulatedDebts[i] > 0) {
          final monthlyInterest = simulatedDebts[i] * (simulatedAprs[i] / 100 / 12);
          simulatedDebts[i] += monthlyInterest;
        }
      }

      // Apply payment (prioritize first debt in list)
      double remainingPayment = averageMonthlyPayment;
      for (int i = 0; i < simulatedDebts.length; i++) {
        if (remainingPayment <= 0) break;
        if (simulatedDebts[i] <= 0) continue;

        final payment = remainingPayment.clamp(0, simulatedDebts[i]);
        simulatedDebts[i] -= payment;
        remainingPayment -= payment;
      }

      monthsToFreedom++;
    }

    if (monthsToFreedom >= maxMonths) return null;

    return DateTime.now().add(Duration(days: monthsToFreedom * 30));
  }

  /// Calculate total interest saved compared to minimum payments only
  static double calculateInterestSaved({
    required List<DebtModel> debts,
    required double totalPaidSoFar,
  }) {
    double baselineInterest = 0;
    double actualInterest = 0;

    for (final debt in debts) {
      // Calculate interest if only paying minimums
      final baselineTotal = _calculateTotalInterest(
        balance: debt.originalBalance,
        apr: debt.apr,
        monthlyPayment: debt.minimumPayment,
      );
      baselineInterest += baselineTotal;

      // Calculate actual interest paid (simplified)
      final amountPaid = debt.originalBalance - debt.currentBalance;
      final principalPaid = amountPaid;
      // This is simplified - in reality we'd track actual interest paid
      final estimatedInterest = amountPaid * 0.1; // Rough estimate
      actualInterest += estimatedInterest;
    }

    return (baselineInterest - actualInterest).clamp(0, double.infinity);
  }

  /// Calculate total interest for a debt with fixed monthly payment
  static double _calculateTotalInterest({
    required double balance,
    required double apr,
    required double monthlyPayment,
  }) {
    if (monthlyPayment <= 0) return 0;

    double remainingBalance = balance;
    double totalInterest = 0;
    final monthlyRate = apr / 100 / 12;
    int months = 0;
    const maxMonths = 600;

    while (remainingBalance > 0 && months < maxMonths) {
      final interest = remainingBalance * monthlyRate;
      totalInterest += interest;
      
      final principal = monthlyPayment - interest;
      if (principal <= 0) break; // Payment doesn't cover interest
      
      remainingBalance -= principal;
      months++;
    }

    return totalInterest;
  }

  /// Calculate average monthly payment from payment history
  static double calculateAverageMonthlyPayment(
    List<DateTime> paymentDates,
    List<double> paymentAmounts,
  ) {
    if (paymentDates.isEmpty || paymentAmounts.isEmpty) return 0;

    final totalPaid = paymentAmounts.fold(0.0, (sum, amount) => sum + amount);
    
    // Calculate months between first and last payment
    final firstPayment = paymentDates.reduce((a, b) => a.isBefore(b) ? a : b);
    final lastPayment = paymentDates.reduce((a, b) => a.isAfter(b) ? a : b);
    
    final daysDiff = lastPayment.difference(firstPayment).inDays;
    final monthsDiff = (daysDiff / 30).clamp(1, double.infinity);

    return totalPaid / monthsDiff;
  }

  /// Calculate total debt remaining
  static double calculateTotalDebt(List<DebtModel> debts) {
    return debts
        .where((debt) => !debt.isDefeated)
        .fold(0, (sum, debt) => sum + debt.currentBalance);
  }

  /// Calculate total original debt
  static double calculateTotalOriginalDebt(List<DebtModel> debts) {
    return debts.fold(0, (sum, debt) => sum + debt.originalBalance);
  }

  /// Calculate overall progress percentage
  static double calculateOverallProgress(List<DebtModel> debts) {
    final totalOriginal = calculateTotalOriginalDebt(debts);
    if (totalOriginal == 0) return 100;

    final totalRemaining = calculateTotalDebt(debts);
    return ((totalOriginal - totalRemaining) / totalOriginal * 100).clamp(0, 100);
  }
}
