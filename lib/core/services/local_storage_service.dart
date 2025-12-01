import 'package:hive_flutter/hive_flutter.dart';
import 'package:undebt/core/models/debt_model.dart';
import 'package:undebt/core/models/payment_model.dart';
import 'package:undebt/core/models/user_model.dart';
import 'package:undebt/core/models/achievement_model.dart';

/// Local storage service using Hive for offline-first architecture
class LocalStorageService {
  static LocalStorageService? _instance;
  static LocalStorageService get instance => _instance ??= LocalStorageService._();

  LocalStorageService._();

  // Box names
  static const String _userBox = 'users';
  static const String _debtBox = 'debts';
  static const String _paymentBox = 'payments';
  static const String _achievementBox = 'achievements';
  static const String _syncQueueBox = 'sync_queue';

  /// Initialize Hive
  Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(DebtModelAdapter());
    Hive.registerAdapter(PaymentModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(AchievementModelAdapter());

    // Open boxes
    await Hive.openBox<DebtModel>(_debtBox);
    await Hive.openBox<PaymentModel>(_paymentBox);
    await Hive.openBox<UserModel>(_userBox);
    await Hive.openBox<AchievementModel>(_achievementBox);
    await Hive.openBox<Map>(_syncQueueBox);
  }

  // ===== User Operations =====

  Box<UserModel> get _users => Hive.box<UserModel>(_userBox);

  Future<void> saveUser(UserModel user) async {
    await _users.put(user.id, user);
  }

  UserModel? getUser(String userId) {
    return _users.get(userId);
  }

  UserModel? get currentUser {
    if (_users.isEmpty) return null;
    return _users.values.first;
  }

  Future<void> deleteUser(String userId) async {
    await _users.delete(userId);
  }

  // ===== Debt Operations =====

  Box<DebtModel> get _debts => Hive.box<DebtModel>(_debtBox);

  Future<void> saveDebt(DebtModel debt) async {
    await _debts.put(debt.id, debt);
    await _addToSyncQueue('debt', 'upsert', debt.toJson());
  }

  DebtModel? getDebt(String debtId) {
    return _debts.get(debtId);
  }

  List<DebtModel> getDebts(String userId) {
    return _debts.values.where((debt) => debt.userId == userId).toList();
  }

  List<DebtModel> getActiveDebts(String userId) {
    return _debts.values
        .where((debt) => debt.userId == userId && !debt.isDefeated)
        .toList();
  }

  Future<void> updateDebt(DebtModel debt) async {
    await _debts.put(debt.id, debt);
    await _addToSyncQueue('debt', 'upsert', debt.toJson());
  }

  Future<void> deleteDebt(String debtId) async {
    final debt = _debts.get(debtId);
    if (debt != null) {
      await _debts.delete(debtId);
      await _addToSyncQueue('debt', 'delete', {'id': debtId});
    }
  }

  // ===== Payment Operations =====

  Box<PaymentModel> get _payments => Hive.box<PaymentModel>(_paymentBox);

  Future<void> savePayment(PaymentModel payment) async {
    await _payments.put(payment.id, payment);
    await _addToSyncQueue('payment', 'upsert', payment.toJson());
  }

  PaymentModel? getPayment(String paymentId) {
    return _payments.get(paymentId);
  }

  List<PaymentModel> getPayments(String userId) {
    return _payments.values
        .where((payment) => payment.userId == userId)
        .toList()
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  }

  List<PaymentModel> getPaymentsByDebt(String debtId) {
    return _payments.values
        .where((payment) => payment.debtId == debtId)
        .toList()
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  }

  // ===== Achievement Operations =====

  Box<AchievementModel> get _achievements => Hive.box<AchievementModel>(_achievementBox);

  Future<void> saveAchievement(AchievementModel achievement) async {
    await _achievements.put(achievement.id, achievement);
    await _addToSyncQueue('achievement', 'upsert', achievement.toJson());
  }

  List<AchievementModel> getAchievements(String userId) {
    return _achievements.values
        .where((achievement) => achievement.userId == userId)
        .toList();
  }

  bool hasAchievement(String userId, String achievementId) {
    return _achievements.values.any(
      (achievement) =>
          achievement.userId == userId &&
          achievement.achievementId == achievementId,
    );
  }

  // ===== Sync Queue Operations =====

  Box<Map> get _syncQueue => Hive.box<Map>(_syncQueueBox);

  Future<void> _addToSyncQueue(
    String entityType,
    String operation,
    Map<String, dynamic> data,
  ) async {
    final queueItem = {
      'entity_type': entityType,
      'operation': operation,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await _syncQueue.add(queueItem);
  }

  List<Map> getSyncQueue() {
    return _syncQueue.values.toList();
  }

  Future<void> clearSyncQueue() async {
    await _syncQueue.clear();
  }

  Future<void> removeSyncQueueItem(int index) async {
    await _syncQueue.deleteAt(index);
  }

  // ===== Utility Methods =====

  Future<void> clearAllData() async {
    await _users.clear();
    await _debts.clear();
    await _payments.clear();
    await _achievements.clear();
    await _syncQueue.clear();
  }

  /// Get total debt defeated (for stats)
  double getTotalDebtDefeated(String userId) {
    final debts = getDebts(userId);
    return debts.fold(
      0.0,
      (sum, debt) => sum + (debt.originalBalance - debt.currentBalance),
    );
  }

  /// Get count of defeated debts
  int getDefeatedDebtsCount(String userId) {
    return _debts.values
        .where((debt) => debt.userId == userId && debt.isDefeated)
        .length;
  }
}
