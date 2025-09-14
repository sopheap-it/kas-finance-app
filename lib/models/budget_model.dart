import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../core/core.dart';

class BudgetModel {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final double amount;
  final double spent;
  final String? categoryId;
  final DateTime startDate;
  final DateTime endDate;
  final String currency;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BudgetModel({
    String? id,
    required this.userId,
    required this.name,
    this.description,
    required this.amount,
    this.spent = 0.0,
    this.categoryId,
    required this.startDate,
    required this.endDate,
    this.currency = 'USD',
    this.isActive = true,
    DateTime? createdAt,
    this.updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  double get remainingAmount => amount - spent;
  double get spentPercentage => amount > 0 ? (spent / amount) * 100 : 0;
  bool get isOverBudget => spent > amount;
  bool get isNearLimit => spentPercentage >= 80;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'amount': amount,
      'spent': spent,
      'categoryId': categoryId,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'currency': currency,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String?,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      spent: (map['spent'] as num?)?.toDouble() ?? 0.0,
      categoryId: map['categoryId'] as String?,
      startDate: DateTime.fromMillisecondsSinceEpoch(
        (map['startDate'] as int?) ?? 0,
      ),
      endDate: DateTime.fromMillisecondsSinceEpoch(
        (map['endDate'] as int?) ?? 0,
      ),
      currency: map['currency'] as String? ?? 'USD',
      isActive: map['isActive'] as bool? ?? true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['createdAt'] as int?) ?? 0,
      ),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  // Database conversion methods
  factory BudgetModel.fromDatabase(BudgetTableData data) {
    return BudgetModel(
      id: data.id,
      userId: data.userId,
      name: data.name,
      description: data.description,
      amount: data.amount,
      spent: data.spent,
      categoryId: data.categoryId,
      startDate: data.startDate,
      endDate: data.endDate,
      currency: data.currency,
      isActive: data.isActive,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  BudgetTableCompanion toCompanion() {
    return BudgetTableCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      description: Value(description),
      amount: Value(amount),
      spent: Value(spent),
      categoryId: Value(categoryId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      currency: Value(currency),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  BudgetModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    double? amount,
    double? spent,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    String? currency,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      categoryId: categoryId ?? this.categoryId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
