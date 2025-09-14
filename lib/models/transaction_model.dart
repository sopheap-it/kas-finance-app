import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../core/core.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String title;
  final String? description;
  final String categoryId;
  final TransactionType type;
  final DateTime date;
  final String currency;
  final String? receiptImageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TransactionModel({
    String? id,
    required this.userId,
    required this.amount,
    required this.title,
    this.description,
    required this.categoryId,
    required this.type,
    required this.date,
    this.currency = 'USD',
    this.receiptImageUrl,
    DateTime? createdAt,
    this.updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'type': type.name,
      'date': date.millisecondsSinceEpoch,
      'currency': currency,
      'receiptImageUrl': receiptImageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      amount: (map['amount'] as num).toDouble(),
      title: map['title'] as String,
      description: map['description'] as String?,
      categoryId: map['categoryId'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      currency: map['currency'] as String,
      receiptImageUrl: map['receiptImageUrl'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  // Database conversion methods
  factory TransactionModel.fromDatabase(TransactionTableData data) {
    return TransactionModel(
      id: data.id,
      userId: data.userId,
      amount: data.amount,
      title: data.title,
      description: data.description,
      categoryId: data.categoryId,
      type: data.type == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date: data.date,
      currency: data.currency,
      receiptImageUrl: data.receiptImageUrl,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  TransactionTableCompanion toCompanion() {
    return TransactionTableCompanion(
      id: Value(id),
      userId: Value(userId),
      amount: Value(amount),
      title: Value(title),
      description: Value(description),
      categoryId: Value(categoryId),
      type: Value(type.name),
      date: Value(date),
      currency: Value(currency),
      receiptImageUrl: Value(receiptImageUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? title,
    String? description,
    String? categoryId,
    TransactionType? type,
    DateTime? date,
    String? currency,
    String? receiptImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      date: date ?? this.date,
      currency: currency ?? this.currency,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
