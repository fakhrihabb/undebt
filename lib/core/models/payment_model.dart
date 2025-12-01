import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'payment_model.g.dart';

@HiveType(typeId: 1)
class PaymentModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String debtId;

  @HiveField(2)
  late String userId;

  @HiveField(3)
  late double amount;

  @HiveField(4)
  late DateTime paymentDate;

  @HiveField(5)
  late String paymentType; // 'minimum' or 'extra'

  @HiveField(6)
  late int xpEarned;

  @HiveField(7)
  String? notes;

  @HiveField(8)
  late DateTime createdAt;

  PaymentModel({
    String? id,
    required this.debtId,
    required this.userId,
    required this.amount,
    DateTime? paymentDate,
    required this.paymentType,
    required this.xpEarned,
    this.notes,
    DateTime? createdAt,
  }) {
    this.id = id ?? const Uuid().v4();
    this.paymentDate = paymentDate ?? DateTime.now();
    this.createdAt = createdAt ?? DateTime.now();
  }

  /// Create a copy with updated fields
  PaymentModel copyWith({
    String? debtId,
    double? amount,
    DateTime? paymentDate,
    String? paymentType,
    int? xpEarned,
    String? notes,
  }) {
    return PaymentModel(
      id: id,
      debtId: debtId ?? this.debtId,
      userId: userId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentType: paymentType ?? this.paymentType,
      xpEarned: xpEarned ?? this.xpEarned,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debt_id': debtId,
      'user_id': userId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'payment_type': paymentType,
      'xp_earned': xpEarned,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON (Supabase)
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      debtId: json['debt_id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['payment_date'] as String),
      paymentType: json['payment_type'] as String,
      xpEarned: json['xp_earned'] as int,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
