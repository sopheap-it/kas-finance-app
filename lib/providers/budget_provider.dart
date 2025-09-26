import 'package:flutter/material.dart';
import '../core/database/app_database.dart';
import '../core/database/database_service.dart';
import '../models/budget_model.dart';
import '../models/transaction_model.dart';
import '../services/notification_service.dart';

class BudgetProvider with ChangeNotifier {
  late final AppDatabase _databaseService;

  List<BudgetModel> _budgets = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<BudgetModel> get budgets => _budgets;
  List<BudgetModel> get activeBudgets =>
      _budgets.where((b) => b.isActive).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  BudgetProvider() {
    // Defer initialization to avoid notifyListeners during widget build
    Future.microtask(_initializeDatabase);
  }

  Future<void> _initializeDatabase() async {
    _databaseService = DatabaseService.instance.database;
    await loadBudgets();
  }

  Future<void> loadBudgets({String? userId}) async {
    try {
      _setLoading(true);
      _clearError();

      // Determine guest mode
      final bool isGuest = userId == null || userId == 'guest';

      // Load from local database first (don't filter by userId for guest)
      final dbBudgets = await _databaseService.getAllBudgets(
        userId: isGuest ? null : userId,
      );
      _budgets = dbBudgets.map((b) => BudgetModel.fromDatabase(b)).toList();
      notifyListeners();

      // Firebase sync disabled for phase 1 - only use local storage
      // TODO: Enable Firebase sync in future phases
    } catch (e) {
      _setError('Failed to load budgets: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadDemoData() async {
    try {
      _setLoading(true);
      _clearError();

      // Check if demo data already exists in database
      final existingBudgets = await _databaseService.getAllBudgets(
        userId: 'guest',
      );
      if (existingBudgets.isNotEmpty) {
        // Load existing demo data from database
        _budgets = existingBudgets
            .map((b) => BudgetModel.fromDatabase(b))
            .toList();
        notifyListeners();
        return;
      }

      // Create demo budgets and save to database
      final demoBudgets = [
        BudgetModel(
          id: 'demo_budget_1',
          userId: 'guest',
          name: 'Food & Dining',
          amount: 500.00,
          spent: 320.50,
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
          categoryId: 'food',
        ),
        BudgetModel(
          id: 'demo_budget_2',
          userId: 'guest',
          name: 'Transportation',
          amount: 200.00,
          spent: 85.00,
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
          categoryId: 'transport',
        ),
        BudgetModel(
          id: 'demo_budget_3',
          userId: 'guest',
          name: 'Entertainment',
          amount: 150.00,
          spent: 145.99,
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
          categoryId: 'entertainment',
        ),
        BudgetModel(
          id: 'demo_budget_4',
          userId: 'guest',
          name: 'Shopping',
          amount: 300.00,
          spent: 120.00,
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
          categoryId: 'shopping',
        ),
      ];

      // Save demo budgets to database
      for (final budget in demoBudgets) {
        await _databaseService.insertBudget(budget.toCompanion());
      }

      _budgets = demoBudgets;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load demo data: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addBudget(BudgetModel budget) async {
    try {
      _setLoading(true);
      _clearError();

      // Add to local database only (Firebase sync disabled for phase 1)
      await _databaseService.insertBudget(budget.toCompanion());
      _budgets.add(budget);
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Failed to add budget: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateBudget(BudgetModel budget) async {
    try {
      _setLoading(true);
      _clearError();

      // Update in local database
      await _databaseService.updateBudget(budget.toCompanion());

      final index = _budgets.indexWhere((b) => b.id == budget.id);
      if (index != -1) {
        _budgets[index] = budget;
        notifyListeners();
      }

      // Firebase sync disabled for phase 1 - only use local storage

      return true;
    } catch (e) {
      _setError('Failed to update budget: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteBudget(String budgetId) async {
    try {
      _setLoading(true);
      _clearError();

      // Delete from local database (soft delete)
      await _databaseService.deleteBudget(budgetId);
      _budgets.removeWhere((b) => b.id == budgetId);
      notifyListeners();

      // Firebase sync disabled for phase 1 - only use local storage

      return true;
    } catch (e) {
      _setError('Failed to delete budget: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateBudgetSpending(List<TransactionModel> transactions) async {
    for (final budget in _budgets) {
      if (!budget.isActive) continue;

      // Calculate spent amount for this budget
      final spent = transactions
          .where(
            (t) =>
                t.type == TransactionType.expense &&
                t.categoryId == budget.categoryId &&
                t.date.isAfter(
                  budget.startDate.subtract(const Duration(days: 1)),
                ) &&
                t.date.isBefore(budget.endDate.add(const Duration(days: 1))),
          )
          .fold(0.0, (sum, t) => sum + t.amount);

      if (spent != budget.spent) {
        final updatedBudget = budget.copyWith(spent: spent);
        await updateBudget(updatedBudget);

        // Check for budget alerts
        await _checkBudgetAlerts(updatedBudget);
      }
    }
  }

  Future<void> _checkBudgetAlerts(BudgetModel budget) async {
    if (budget.isNearLimit && !budget.isOverBudget) {
      // Send warning notification at 80%
      await NotificationService.showBudgetAlert(
        category: budget.name,
        spent: budget.spent,
        budget: budget.amount,
      );
    } else if (budget.isOverBudget) {
      // Send critical notification when over budget
      await NotificationService.showBudgetAlert(
        category: budget.name,
        spent: budget.spent,
        budget: budget.amount,
      );
    }
  }

  Future<void> _syncWithFirestore(String userId) async {
    // Firebase sync disabled for phase 1 - only use local storage
    // TODO: Enable Firebase sync in future phases
    return;
  }

  // Analytics and statistics
  List<BudgetModel> getBudgetsForCategory(String categoryId) {
    return _budgets
        .where((b) => b.categoryId == categoryId && b.isActive)
        .toList();
  }

  List<BudgetModel> getCurrentBudgets() {
    final now = DateTime.now();
    return _budgets
        .where(
          (b) =>
              b.isActive && b.startDate.isBefore(now) && b.endDate.isAfter(now),
        )
        .toList();
  }

  List<BudgetModel> getUpcomingBudgets() {
    final now = DateTime.now();
    return _budgets
        .where((b) => b.isActive && b.startDate.isAfter(now))
        .toList();
  }

  List<BudgetModel> getExpiredBudgets() {
    final now = DateTime.now();
    return _budgets
        .where((b) => b.isActive && b.endDate.isBefore(now))
        .toList();
  }

  List<BudgetModel> getOverBudgets() {
    return _budgets.where((b) => b.isActive && b.isOverBudget).toList();
  }

  List<BudgetModel> getNearLimitBudgets() {
    return _budgets
        .where((b) => b.isActive && b.isNearLimit && !b.isOverBudget)
        .toList();
  }

  double getTotalBudgetAmount() {
    return getCurrentBudgets().fold(0.0, (sum, budget) => sum + budget.amount);
  }

  double getTotalSpentAmount() {
    return getCurrentBudgets().fold(0.0, (sum, budget) => sum + budget.spent);
  }

  double getOverallBudgetHealth() {
    final currentBudgets = getCurrentBudgets();
    if (currentBudgets.isEmpty) return 100.0;

    final totalBudget = getTotalBudgetAmount();
    final totalSpent = getTotalSpentAmount();

    return totalBudget > 0
        ? ((totalBudget - totalSpent) / totalBudget) * 100
        : 0.0;
  }

  BudgetModel? getBudgetById(String budgetId) {
    try {
      return _budgets.firstWhere((b) => b.id == budgetId);
    } catch (e) {
      return null;
    }
  }

  List<BudgetModel> searchBudgets(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _budgets
        .where(
          (b) =>
              b.name.toLowerCase().contains(lowercaseQuery) ||
              (b.description?.toLowerCase().contains(lowercaseQuery) ?? false),
        )
        .toList();
  }

  // Create suggested budgets based on spending patterns
  List<BudgetModel> createSuggestedBudgets(
    String userId,
    List<TransactionModel> transactions,
    List<String> categoryIds,
  ) {
    final suggestions = <BudgetModel>[];
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    for (final categoryId in categoryIds) {
      // Calculate average spending for this category over last 3 months
      double totalSpent = 0;
      int monthsWithSpending = 0;

      for (int i = 0; i < 3; i++) {
        final monthStart = DateTime(now.year, now.month - i, 1);
        final monthEnd = DateTime(now.year, now.month - i + 1, 0);

        final monthlySpent = transactions
            .where(
              (t) =>
                  t.type == TransactionType.expense &&
                  t.categoryId == categoryId &&
                  t.date.isAfter(
                    monthStart.subtract(const Duration(days: 1)),
                  ) &&
                  t.date.isBefore(monthEnd.add(const Duration(days: 1))),
            )
            .fold(0.0, (sum, t) => sum + t.amount);

        if (monthlySpent > 0) {
          totalSpent += monthlySpent;
          monthsWithSpending++;
        }
      }

      if (monthsWithSpending > 0) {
        final averageSpending = totalSpent / monthsWithSpending;
        final suggestedAmount = averageSpending * 1.1; // Add 10% buffer

        suggestions.add(
          BudgetModel(
            userId: userId,
            name: 'Monthly Budget',
            amount: suggestedAmount,
            categoryId: categoryId,
            startDate: startOfMonth,
            endDate: endOfMonth,
          ),
        );
      }
    }

    return suggestions;
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
