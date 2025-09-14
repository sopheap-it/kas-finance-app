import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../core/core.dart';

class CategoryModel {
  final String id;
  final String name;
  final String iconName;
  final Color color;
  final String type; // 'income' or 'expense'
  final bool isDefault;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    String? id,
    required this.name,
    required this.iconName,
    required this.color,
    required this.type,
    this.isDefault = false,
    this.isActive = true,
    DateTime? createdAt,
    this.updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'color': color.toARGB32(),
      'type': type,
      'isDefault': isDefault,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      iconName: map['iconName'] as String,
      color: Color(map['color'] as int),
      type: map['type'] as String,
      isDefault: map['isDefault'] as bool,
      isActive: map['isActive'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  // Database conversion methods
  factory CategoryModel.fromDatabase(CategoryTableData data) {
    return CategoryModel(
      id: data.id,
      name: data.name,
      iconName: data.iconName,
      color: Color(data.color),
      type: data.type,
      isDefault: data.isDefault,
      isActive: data.isActive,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  CategoryTableCompanion toCompanion() {
    return CategoryTableCompanion(
      id: Value(id),
      name: Value(name),
      iconName: Value(iconName),
      color: Value(color.toARGB32()),
      type: Value(type),
      isDefault: Value(isDefault),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? iconName,
    Color? color,
    String? type,
    bool? isDefault,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // Default categories
  static List<CategoryModel> getDefaultCategories() {
    return [
      // Expense Categories
      CategoryModel(
        id: 'food',
        name: 'Food & Dining',
        iconName: 'restaurant',
        color: const Color(0xFFFF5722),
        type: 'expense',
        isDefault: true,
      ),
      CategoryModel(
        id: 'transport',
        name: 'Transportation',
        iconName: 'directions_car',
        color: const Color(0xFF2196F3),
        type: 'expense',
        isDefault: true,
      ),
      CategoryModel(
        id: 'shopping',
        name: 'Shopping',
        iconName: 'shopping_bag',
        color: const Color(0xFF9C27B0),
        type: 'expense',
        isDefault: true,
      ),
      CategoryModel(
        id: 'entertainment',
        name: 'Entertainment',
        iconName: 'movie',
        color: const Color(0xFFE91E63),
        type: 'expense',
        isDefault: true,
      ),
      CategoryModel(
        id: 'bills',
        name: 'Bills & Utilities',
        iconName: 'receipt',
        color: const Color(0xFFFF9800),
        type: 'expense',
        isDefault: true,
      ),
      CategoryModel(
        id: 'healthcare',
        name: 'Healthcare',
        iconName: 'local_hospital',
        color: const Color(0xFFF44336),
        type: 'expense',
        isDefault: true,
      ),
      CategoryModel(
        id: 'education',
        name: 'Education',
        iconName: 'school',
        color: const Color(0xFF3F51B5),
        type: 'expense',
        isDefault: true,
      ),
      // Income Categories
      CategoryModel(
        id: 'salary',
        name: 'Salary',
        iconName: 'work',
        color: const Color(0xFF4CAF50),
        type: 'income',
        isDefault: true,
      ),
      CategoryModel(
        id: 'business',
        name: 'Business',
        iconName: 'business',
        color: const Color(0xFF607D8B),
        type: 'income',
        isDefault: true,
      ),
      CategoryModel(
        id: 'investment',
        name: 'Investment',
        iconName: 'trending_up',
        color: const Color(0xFF009688),
        type: 'income',
        isDefault: true,
      ),
      CategoryModel(
        id: 'gift',
        name: 'Gifts',
        iconName: 'card_giftcard',
        color: const Color(0xFFFF4081),
        type: 'income',
        isDefault: true,
      ),
    ];
  }
}
