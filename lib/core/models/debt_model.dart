import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'debt_model.g.dart';

@HiveType(typeId: 0)
class DebtModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String debtType;

  @HiveField(3)
  late double originalBalance;

  @HiveField(4)
  late double currentBalance;

  @HiveField(5)
  late double apr;

  @HiveField(6)
  late double minimumPayment;

  @HiveField(7)
  int? dueDate; // Day of month (1-31)

  @HiveField(8)
  late DateTime createdAt;

  @HiveField(9)
  DateTime? paidOffAt;

  @HiveField(10)
  late String status; // 'active' or 'defeated'

  @HiveField(11)
  late int priority;

  @HiveField(12)
  late String monsterType;

  @HiveField(13)
  late String userId;

  DebtModel({
    String? id,
    required this.name,
    required this.debtType,
    required this.originalBalance,
    required this.currentBalance,
    required this.apr,
    required this.minimumPayment,
    this.dueDate,
    DateTime? createdAt,
    this.paidOffAt,
    String? status,
    int? priority,
    String? monsterType,
    required this.userId,
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.now();
    this.status = status ?? 'active';
    this.priority = priority ?? 0;
    this.monsterType = monsterType ?? _determineMonsterType();
  }

  /// Determine monster type based on debt characteristics
  String _determineMonsterType() {
    // High interest = dangerous monster
    if (apr >= 20) return 'dragon';
    
    // Large balance = big monster
    if (currentBalance >= 10000) return 'giant';
    
    // Credit card = specific monster
    if (debtType.toLowerCase().contains('credit')) return 'goblin';
    
    // Student loan = specific monster
    if (debtType.toLowerCase().contains('student')) return 'wizard';
    
    // Auto loan = specific monster
    if (debtType.toLowerCase().contains('auto')) return 'beast';
    
    // Default small monster
    return 'slime';
  }

  /// Calculate percentage paid off
  double get percentPaid {
    if (originalBalance == 0) return 100;
    return ((originalBalance - currentBalance) / originalBalance * 100).clamp(0, 100);
  }

  /// Check if debt is defeated
  bool get isDefeated => currentBalance <= 0 || status == 'defeated';

  /// Get progress color based on percentage paid
  String get progressColor {
    if (percentPaid >= 100) return 'complete';
    if (percentPaid >= 67) return 'high';
    if (percentPaid >= 34) return 'medium';
    return 'low';
  }

  /// Get APR severity level
  String get aprSeverity {
    if (apr >= 20) return 'high';
    if (apr >= 10) return 'medium';
    return 'low';
  }

  /// Get fire icon count based on APR
  int get fireIconCount {
    if (apr >= 25) return 5;
    if (apr >= 20) return 4;
    if (apr >= 15) return 3;
    if (apr >= 10) return 2;
    return 1;
  }

  /// Create a copy with updated fields
  DebtModel copyWith({
    String? name,
    String? debtType,
    double? originalBalance,
    double? currentBalance,
    double? apr,
    double? minimumPayment,
    int? dueDate,
    DateTime? paidOffAt,
    String? status,
    int? priority,
    String? monsterType,
  }) {
    return DebtModel(
      id: id,
      name: name ?? this.name,
      debtType: debtType ?? this.debtType,
      originalBalance: originalBalance ?? this.originalBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      apr: apr ?? this.apr,
      minimumPayment: minimumPayment ?? this.minimumPayment,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      paidOffAt: paidOffAt ?? this.paidOffAt,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      monsterType: monsterType ?? this.monsterType,
      userId: userId,
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'debt_type': debtType,
      'original_balance': originalBalance,
      'current_balance': currentBalance,
      'apr': apr,
      'minimum_payment': minimumPayment,
      'due_date': dueDate,
      'created_at': createdAt.toIso8601String(),
      'paid_off_at': paidOffAt?.toIso8601String(),
      'status': status,
      'priority': priority,
      'monster_type': monsterType,
    };
  }

  /// Create from JSON (Supabase)
  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      debtType: json['debt_type'] as String,
      originalBalance: (json['original_balance'] as num).toDouble(),
      currentBalance: (json['current_balance'] as num).toDouble(),
      apr: (json['apr'] as num).toDouble(),
      minimumPayment: (json['minimum_payment'] as num).toDouble(),
      dueDate: json['due_date'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      paidOffAt: json['paid_off_at'] != null 
          ? DateTime.parse(json['paid_off_at'] as String) 
          : null,
      status: json['status'] as String,
      priority: json['priority'] as int,
      monsterType: json['monster_type'] as String,
    );
  }
}
