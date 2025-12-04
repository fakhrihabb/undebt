import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase service for backend operations
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  SupabaseClient? _client;
  SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  /// Initialize Supabase
  Future<void> initialize() async {
    await dotenv.load(fileName: '.env');

    final url = dotenv.env['SUPABASE_PROJECT_URL'];
    final anonKey = dotenv.env['SUPABASE_PUBLIC_KEY'];

    if (url == null || anonKey == null) {
      throw Exception('Supabase credentials not found in .env file');
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );

    _client = Supabase.instance.client;
  }

  /// Get current user
  User? get currentUser => client.auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // ===== User Operations =====

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  /// Create or update user profile
  Future<void> upsertUserProfile(Map<String, dynamic> userData) async {
    await client.from('users').upsert(userData);
  }

  // ===== Debt Operations =====

  /// Get all debts for a user
  Future<List<Map<String, dynamic>>> getDebts(String userId) async {
    final response = await client
        .from('debts')
        .select()
        .eq('user_id', userId)
        .order('priority');
    return List<Map<String, dynamic>>.from(response);
  }

  /// Create a new debt
  Future<Map<String, dynamic>> createDebt(Map<String, dynamic> debtData) async {
    final response = await client
        .from('debts')
        .insert(debtData)
        .select()
        .single();
    return response;
  }

  /// Update a debt
  Future<void> updateDebt(String debtId, Map<String, dynamic> debtData) async {
    await client
        .from('debts')
        .update(debtData)
        .eq('id', debtId);
  }

  /// Delete a debt
  Future<void> deleteDebt(String debtId) async {
    await client
        .from('debts')
        .delete()
        .eq('id', debtId);
  }

  /// Listen to debt changes
  Stream<List<Map<String, dynamic>>> watchDebts(String userId) {
    return client
        .from('debts')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('priority')
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  // ===== Payment Operations =====

  /// Get all payments for a user
  Future<List<Map<String, dynamic>>> getPayments(String userId) async {
    final response = await client
        .from('payments')
        .select()
        .eq('user_id', userId)
        .order('payment_date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Get payments for a specific debt
  Future<List<Map<String, dynamic>>> getPaymentsByDebt(String debtId) async {
    final response = await client
        .from('payments')
        .select()
        .eq('debt_id', debtId)
        .order('payment_date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Create a new payment
  Future<Map<String, dynamic>> createPayment(Map<String, dynamic> paymentData) async {
    final response = await client
        .from('payments')
        .insert(paymentData)
        .select()
        .single();
    return response;
  }

  /// Listen to payment changes
  Stream<List<Map<String, dynamic>>> watchPayments(String userId) {
    return client
        .from('payments')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('payment_date', ascending: false)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  // ===== Achievement Operations =====

  /// Get all achievements for a user
  Future<List<Map<String, dynamic>>> getAchievements(String userId) async {
    final response = await client
        .from('achievements')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Unlock an achievement
  Future<Map<String, dynamic>> unlockAchievement(Map<String, dynamic> achievementData) async {
    final response = await client
        .from('achievements')
        .insert(achievementData)
        .select()
        .single();
    return response;
  }

  /// Listen to achievement changes
  Stream<List<Map<String, dynamic>>> watchAchievements(String userId) {
    return client
        .from('achievements')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }
}
