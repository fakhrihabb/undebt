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
      email: 'user@example.com',
      totalXp: 350,
      level: 3,
      currentStreakDays: 5,
      selectedMethod: 'snowball',
      onboardingComplete: true,
    );
    notifyListeners();
  }

  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void addXP(int amount) {
    if (_user != null) {
      final leveledUp = _user!.addXp(amount);
      notifyListeners();
      // Could trigger level up celebration here if leveledUp is true
    }
  }

  void updateStreak() {
    if (_user != null) {
      _user!.updateStreak();
      notifyListeners();
    }
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}
