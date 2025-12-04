import 'package:flutter/material.dart';
import 'package:undebt/core/models/debt_model.dart';
import 'package:undebt/core/models/payment_model.dart';
import 'package:undebt/core/utils/debt_calculator.dart';

/// Provider for managing debt data and state
class DebtProvider extends ChangeNotifier {
  List<DebtModel> _debts = [];
  List<PaymentModel> _payments = [];
  String _selectedMethod = 'snowball';

  List<DebtModel> get debts => _debts;
  List<PaymentModel> get payments => _payments;
  String get selectedMethod => _selectedMethod;

  /// Get only active (non-defeated) debts
  List<DebtModel> get activeDebts =>
      _debts.where((debt) => !debt.isDefeated).toList();

  /// Get defeated debts
  List<DebtModel> get defeatedDebts =>
      _debts.where((debt) => debt.isDefeated).toList();

  /// Initialize with mock data for Phase 4
  void initializeMockDebts() {
    _debts = [
      DebtModel(
        name: 'Chase Credit Card',
        debtType: 'Credit Card',
        originalBalance: 3500.0,
        currentBalance: 3500.0,
        apr: 18.99,
        minimumPayment: 105.0,
        dueDate: 15,
        userId: 'mock-user-id',
      ),
      DebtModel(
        name: 'Student Loan',
        debtType: 'Student Loan',
        originalBalance: 12000.0,
        currentBalance: 12000.0,
        apr: 5.5,
        minimumPayment: 150.0,
        dueDate: 1,
        userId: 'mock-user-id',
      ),
      DebtModel(
        name: 'Car Payment',
        debtType: 'Auto Loan',
        originalBalance: 8500.0,
        currentBalance: 8500.0,
        apr: 7.2,
        minimumPayment: 280.0,
        dueDate: 20,
        userId: 'mock-user-id',
      ),
    ];
    _prioritizeDebts();
    notifyListeners();
  }

  /// Set the repayment method
  void setMethod(String method) {
    _selectedMethod = method;
    _prioritizeDebts();
    notifyListeners();
  }

  /// Prioritize debts based on selected method
  void _prioritizeDebts() {
    final prioritized = DebtCalculator.prioritizeDebts(_debts, _selectedMethod);
    // Update priorities in the original list
    for (int i = 0; i < prioritized.length; i++) {
      final debt = _debts.firstWhere((d) => d.id == prioritized[i].id);
      debt.priority = prioritized[i].priority;
    }
  }

  /// Get debts sorted by priority
  List<DebtModel> getPrioritizedDebts() {
    final active = activeDebts;
    active.sort((a, b) => a.priority.compareTo(b.priority));
    return active;
  }

  /// Add a new debt
  void addDebt(DebtModel debt) {
    _debts.add(debt);
    _prioritizeDebts();
    notifyListeners();
  }

  /// Update an existing debt
  void updateDebt(DebtModel updatedDebt) {
    final index = _debts.indexWhere((debt) => debt.id == updatedDebt.id);
    if (index != -1) {
      _debts[index] = updatedDebt;
      _prioritizeDebts();
      notifyListeners();
    }
  }

  /// Delete a debt
  void deleteDebt(String debtId) {
    _debts.removeWhere((debt) => debt.id == debtId);
    _prioritizeDebts();
    notifyListeners();
  }

  /// Make a payment on a debt
  void makePayment({
    required String debtId,
    required double amount,
    DateTime? paymentDate,
  }) {
    final debtIndex = _debts.indexWhere((debt) => debt.id == debtId);
    if (debtIndex == -1) return;

    final debt = _debts[debtIndex];
    final newBalance = (debt.currentBalance - amount).clamp(0.0, debt.currentBalance);
    
    // Update debt balance
    _debts[debtIndex] = debt.copyWith(
      currentBalance: newBalance,
      status: newBalance <= 0 ? 'defeated' : 'active',
      paidOffAt: newBalance <= 0 ? DateTime.now() : null,
    );

    // Determine payment type
    final isMinimum = amount <= debt.minimumPayment;
    final paymentType = isMinimum ? 'minimum' : 'extra';
    
    // Calculate XP earned (simplified for now)
    final xpEarned = isMinimum ? 10 : (amount / 10).floor();

    // Create payment record
    final payment = PaymentModel(
      debtId: debtId,
      userId: debt.userId,
      amount: amount,
      paymentDate: paymentDate ?? DateTime.now(),
      paymentType: paymentType,
      xpEarned: xpEarned,
    );
    _payments.add(payment);

    _prioritizeDebts();
    notifyListeners();
  }

  /// Calculate total debt remaining
  double getTotalDebt() {
    return DebtCalculator.calculateTotalDebt(_debts);
  }

  /// Calculate total monthly payment (sum of minimums)
  double getTotalMonthlyPayment() {
    return activeDebts.fold(0.0, (sum, debt) => sum + debt.minimumPayment);
  }

  /// Calculate estimated debt-free date
  DateTime? getDebtFreeDate() {
    if (activeDebts.isEmpty) return DateTime.now();
    
    // Calculate average monthly payment from history
    // For now, use total minimum payments as baseline
    final averagePayment = getTotalMonthlyPayment();
    
    return DebtCalculator.calculateDebtFreeDate(
      debts: _debts,
      averageMonthlyPayment: averagePayment,
    );
  }

  /// Calculate total interest to pay (if only paying minimums)
  double getTotalInterestToPay() {
    double totalInterest = 0;
    
    for (final debt in activeDebts) {
      // Simplified calculation: estimate based on current balance and APR
      // Assuming average payoff time of 3 years for estimation
      final monthlyRate = debt.apr / 100 / 12;
      final estimatedMonths = 36; // 3 years
      final estimatedInterest = debt.currentBalance * monthlyRate * estimatedMonths * 0.5;
      totalInterest += estimatedInterest;
    }
    
    return totalInterest;
  }

  /// Calculate overall progress percentage
  double getOverallProgress() {
    return DebtCalculator.calculateOverallProgress(_debts);
  }

  /// Get debt by ID
  DebtModel? getDebtById(String debtId) {
    try {
      return _debts.firstWhere((debt) => debt.id == debtId);
    } catch (e) {
      return null;
    }
  }

  /// Clear all debts (for testing)
  void clearDebts() {
    _debts.clear();
    _payments.clear();
    notifyListeners();
  }

  /// Load debts from storage (placeholder for future implementation)
  Future<void> loadDebts() async {
    // TODO: Implement Hive/Supabase loading in future phase
    // For now, use mock data
    initializeMockDebts();
  }

  /// Save debts to storage (placeholder for future implementation)
  Future<void> saveDebts() async {
    // TODO: Implement Hive/Supabase saving in future phase
  }
}
