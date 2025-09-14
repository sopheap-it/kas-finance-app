import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../core/core.dart';
import '../core/database/database_service.dart';

class TransactionProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final AppDatabase _database;

  List<TransactionModel> _transactions = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filters
  TransactionType? _filterType;
  String? _filterCategoryId;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;

  // Getters
  List<TransactionModel> get transactions => _getFilteredTransactions();
  List<TransactionModel> get allTransactions => _transactions;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filter getters
  TransactionType? get filterType => _filterType;
  String? get filterCategoryId => _filterCategoryId;
  DateTime? get filterStartDate => _filterStartDate;
  DateTime? get filterEndDate => _filterEndDate;

  // Statistics
  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  Map<String, double> get expensesByCategory {
    final Map<String, double> expenses = {};
    for (final transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        final category = _categories.firstWhere(
          (c) => c.id == transaction.categoryId,
          orElse: () => CategoryModel(
            name: 'Unknown',
            iconName: 'help_outline',
            color: Colors.grey,
            type: 'expense',
          ),
        );
        expenses[category.name] =
            (expenses[category.name] ?? 0) + transaction.amount;
      }
    }
    return expenses;
  }

  TransactionProvider() {
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = DatabaseService.instance.database;
    await loadCategories();
    await loadTransactions();
  }

  Future<void> loadTransactions({String? userId}) async {
    try {
      _setLoading(true);
      _clearError();

      // Determine guest mode by conventional userId value
      final bool isGuest = userId == null || userId == 'guest';

      // Load from local database first (for guest, don't filter by userId)
      final dbTransactions = await _database.getAllTransactions(
        userId: isGuest ? null : userId,
      );
      _transactions = dbTransactions
          .map((t) => TransactionModel.fromDatabase(t))
          .toList();
      notifyListeners();

      // Firebase sync disabled for phase 1 - only use local storage
      // TODO: Enable Firebase sync in future phases
    } catch (e) {
      _setError('Failed to load transactions: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadDemoData() async {
    try {
      _setLoading(true);
      _clearError();

      // Check if demo data already exists in database
      final existingTransactions = await _database.getAllTransactions(
        userId: 'guest',
      );
      if (existingTransactions.isNotEmpty) {
        // Load existing demo data from database
        _transactions = existingTransactions
            .map((t) => TransactionModel.fromDatabase(t))
            .toList();
        notifyListeners();
        return;
      }

      // Create demo categories if not already loaded
      if (_categories.isEmpty) {
        _categories = [
          CategoryModel(
            id: 'income',
            name: 'Income',
            iconName: 'trending_up',
            color: Colors.green,
            type: 'income',
            isDefault: true,
          ),
          CategoryModel(
            id: 'food',
            name: 'Food & Dining',
            iconName: 'restaurant',
            color: Colors.orange,
            type: 'expense',
            isDefault: true,
          ),
          CategoryModel(
            id: 'transport',
            name: 'Transportation',
            iconName: 'directions_car',
            color: Colors.blue,
            type: 'expense',
            isDefault: true,
          ),
          CategoryModel(
            id: 'entertainment',
            name: 'Entertainment',
            iconName: 'movie',
            color: Colors.purple,
            type: 'expense',
            isDefault: true,
          ),
          CategoryModel(
            id: 'shopping',
            name: 'Shopping',
            iconName: 'shopping_bag',
            color: Colors.pink,
            type: 'expense',
            isDefault: true,
          ),
        ];
      }

      // Create demo transactions and save to database
      final demoTransactions = [
        TransactionModel(
          id: 'demo_1',
          userId: 'guest',
          amount: 2500.00,
          title: 'Salary',
          description: 'Monthly salary payment',
          categoryId: 'income',
          type: TransactionType.income,
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
        TransactionModel(
          id: 'demo_2',
          userId: 'guest',
          amount: 700.00,
          title: 'Freelance Work',
          description: 'Web development project',
          categoryId: 'income',
          type: TransactionType.income,
          date: DateTime.now().subtract(const Duration(days: 10)),
        ),
        TransactionModel(
          id: 'demo_3',
          userId: 'guest',
          amount: 120.50,
          title: 'Grocery Shopping',
          description: 'Weekly groceries',
          categoryId: 'food',
          type: TransactionType.expense,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        TransactionModel(
          id: 'demo_4',
          userId: 'guest',
          amount: 85.00,
          title: 'Gas Station',
          description: 'Fuel for car',
          categoryId: 'transport',
          type: TransactionType.expense,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        TransactionModel(
          id: 'demo_5',
          userId: 'guest',
          amount: 45.99,
          title: 'Netflix Subscription',
          description: 'Monthly streaming service',
          categoryId: 'entertainment',
          type: TransactionType.expense,
          date: DateTime.now().subtract(const Duration(days: 15)),
        ),
        TransactionModel(
          id: 'demo_6',
          userId: 'guest',
          amount: 200.00,
          title: 'Restaurant',
          description: 'Dinner with friends',
          categoryId: 'food',
          type: TransactionType.expense,
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

      // Save demo transactions to database
      for (final transaction in demoTransactions) {
        await _database.insertTransaction(transaction.toCompanion());
      }

      _transactions = demoTransactions;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load demo data: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadCategories() async {
    try {
      // Load categories from local database
      final dbCategories = await _database.getAllCategories();
      _categories = dbCategories
          .map((c) => CategoryModel.fromDatabase(c))
          .toList();

      // If no categories exist, the default categories are inserted during database creation
      notifyListeners();
    } catch (e) {
      _setError('Failed to load categories: $e');
    }
  }

  Future<bool> addTransaction(TransactionModel transaction) async {
    try {
      _setLoading(true);
      _clearError();

      // Add to local database only (Firebase sync disabled for phase 1)
      await _database.insertTransaction(transaction.toCompanion());
      _transactions.add(transaction);
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Failed to add transaction: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateTransaction(TransactionModel transaction) async {
    try {
      _setLoading(true);
      _clearError();

      // Update in local database only (Firebase sync disabled for phase 1)
      await _database.updateTransaction(transaction.toCompanion());

      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError('Failed to update transaction: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteTransaction(String transactionId) async {
    try {
      _setLoading(true);
      _clearError();

      // Delete from local database only (Firebase sync disabled for phase 1)
      await _database.deleteTransaction(transactionId);
      _transactions.removeWhere((t) => t.id == transactionId);
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Failed to delete transaction: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addCategory(CategoryModel category) async {
    try {
      await _database.insertCategory(category.toCompanion());
      _categories.add(category);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add category: $e');
      return false;
    }
  }

  Future<void> _syncWithFirestore(String userId) async {
    // Firebase sync disabled for phase 1 - only use local storage
    // TODO: Enable Firebase sync in future phases
    return;
  }

  // Filter methods
  void setTypeFilter(TransactionType? type) {
    _filterType = type;
    notifyListeners();
  }

  void setCategoryFilter(String? categoryId) {
    _filterCategoryId = categoryId;
    notifyListeners();
  }

  void setDateFilter(DateTime? startDate, DateTime? endDate) {
    _filterStartDate = startDate;
    _filterEndDate = endDate;
    notifyListeners();
  }

  void clearFilters() {
    _filterType = null;
    _filterCategoryId = null;
    _filterStartDate = null;
    _filterEndDate = null;
    notifyListeners();
  }

  List<TransactionModel> _getFilteredTransactions() {
    return _transactions.where((transaction) {
      // Type filter
      if (_filterType != null && transaction.type != _filterType) {
        return false;
      }

      // Category filter
      if (_filterCategoryId != null &&
          transaction.categoryId != _filterCategoryId) {
        return false;
      }

      // Date filter
      if (_filterStartDate != null &&
          transaction.date.isBefore(_filterStartDate!)) {
        return false;
      }
      if (_filterEndDate != null && transaction.date.isAfter(_filterEndDate!)) {
        return false;
      }

      return true;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _transactions
        .where(
          (t) =>
              t.date.isAfter(start.subtract(const Duration(days: 1))) &&
              t.date.isBefore(end.add(const Duration(days: 1))),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> getRecentTransactions({int limit = 10}) {
    final sorted = List<TransactionModel>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  CategoryModel? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
