import 'package:flutter/material.dart';
import 'package:undebt/core/models/user_model.dart';

/// Provider for managing user data and state
class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  
  bool get hasUser => _user != null;

  // Mock user for now - will load from storage in Phase 4
  void initializeMockUser() {
    _user = UserModel(
      id: 'mock-user-id',
      name: 'Debt Slayer',
      email: 'user@example.com',
      xp: 350,
      level: 3,
      totalDebtsPaid: 0,
      currentStreak: 5,
      longestStreak: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      isPremium: false,
      preferredMethod: 'snowball',
    );
    notifyListeners();
  }

  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void addXP(int amount) {
    if (_user != null) {
      _user = _user!.addXP(amount);
      notifyListeners();
    }
  }

  void incrementStreak() {
    if (_user != null) {
      _user = _user!.incrementStreak();
      notifyListeners();
    }
  }

  void resetStreak() {
    if (_user != null) {
      _user = _user!.resetStreak();
      notifyListeners();
    }
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}
