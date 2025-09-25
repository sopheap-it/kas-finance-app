import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../core/core.dart';
import '../core/database/database_service.dart';

class TransactionProvider with ChangeNotifier {
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

      // Migrate any legacy categoryIds from older demo data to current IDs
      await _migrateLegacyCategoryIdsIfNeeded();
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

      // Ensure categories list is loaded from database
      if (_categories.isEmpty) {
        final dbCategories = await _database.getAllCategories();
        _categories = dbCategories
            .map((c) => CategoryModel.fromDatabase(c))
            .toList();
      }

      String? _categoryIdByName(String name) {
        try {
          return _categories.firstWhere((c) => c.name == name).id;
        } catch (_) {
          return null;
        }
      }

      // Create demo transactions and save to database
      final demoTransactions = [
        TransactionModel(
          id: 'demo_1',
          userId: 'guest',
          amount: 2500.00,
          title: 'Salary',
          description: 'Monthly salary payment',
          categoryId:
              _categoryIdByName('Salary') ??
              _categoryIdByName('Business') ??
              _categories.firstWhere((c) => c.type == 'income').id,
          type: TransactionType.income,
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
        TransactionModel(
          id: 'demo_2',
          userId: 'guest',
          amount: 700.00,
          title: 'Freelance Work',
          description: 'Web development project',
          categoryId:
              _categoryIdByName('Business') ??
              _categoryIdByName('Salary') ??
              _categories.firstWhere((c) => c.type == 'income').id,
          type: TransactionType.income,
          date: DateTime.now().subtract(const Duration(days: 10)),
        ),
        TransactionModel(
          id: 'demo_3',
          userId: 'guest',
          amount: 120.50,
          title: 'Grocery Shopping',
          description: 'Weekly groceries',
          categoryId:
              _categoryIdByName('Food & Dining') ??
              _categories.firstWhere((c) => c.type == 'expense').id,
          type: TransactionType.expense,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        TransactionModel(
          id: 'demo_4',
          userId: 'guest',
          amount: 85.00,
          title: 'Gas Station',
          description: 'Fuel for car',
          categoryId:
              _categoryIdByName('Transportation') ??
              _categories.firstWhere((c) => c.type == 'expense').id,
          type: TransactionType.expense,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        TransactionModel(
          id: 'demo_5',
          userId: 'guest',
          amount: 45.99,
          title: 'Netflix Subscription',
          description: 'Monthly streaming service',
          categoryId:
              _categoryIdByName('Entertainment') ??
              _categories.firstWhere((c) => c.type == 'expense').id,
          type: TransactionType.expense,
          date: DateTime.now().subtract(const Duration(days: 15)),
        ),
        TransactionModel(
          id: 'demo_6',
          userId: 'guest',
          amount: 200.00,
          title: 'Restaurant',
          description: 'Dinner with friends',
          categoryId:
              _categoryIdByName('Food & Dining') ??
              _categories.firstWhere((c) => c.type == 'expense').id,
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

  // One-time migration to map legacy demo category ids (e.g. 'food')
  // to the seeded database category ids (e.g. 'expense_food').
  Future<void> _migrateLegacyCategoryIdsIfNeeded() async {
    if (_categories.isEmpty) {
      final dbCategories = await _database.getAllCategories();
      _categories = dbCategories
          .map((c) => CategoryModel.fromDatabase(c))
          .toList();
    }

    final Map<String, String> nameToId = {
      for (final c in _categories) c.name: c.id,
    };

    bool updated = false;
    for (final t in List<TransactionModel>.from(_transactions)) {
      String? mappedId;
      switch (t.categoryId) {
        case 'income':
          mappedId = nameToId['Salary'] ?? nameToId['Business'];
          break;
        case 'food':
          mappedId = nameToId['Food & Dining'];
          break;
        case 'transport':
          mappedId = nameToId['Transportation'];
          break;
        case 'entertainment':
          mappedId = nameToId['Entertainment'];
          break;
        case 'shopping':
          mappedId = nameToId['Shopping'];
          break;
      }

      if (mappedId != null && mappedId != t.categoryId) {
        final updatedTx = t.copyWith(categoryId: mappedId);
        await _database.updateTransaction(updatedTx.toCompanion());
        final idx = _transactions.indexWhere((x) => x.id == t.id);
        if (idx != -1) _transactions[idx] = updatedTx;
        updated = true;
      }
    }

    if (updated) {
      notifyListeners();
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
