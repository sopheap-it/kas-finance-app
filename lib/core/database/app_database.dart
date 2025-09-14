import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/user_table.dart';
import 'tables/transaction_table.dart';
import 'tables/category_table.dart';
import 'tables/budget_table.dart';

part 'app_database.g.dart';

/// Main database class for the application
@DriftDatabase(
  tables: [UserTable, TransactionTable, CategoryTable, BudgetTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _insertDefaultCategories();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Targeted fixes for earlier incorrect constraints
        if (from < 2) {
          // Recreate category_table to apply corrected constraints
          await m.drop(categoryTable);
          await m.create(categoryTable);
          await _insertDefaultCategories();
        }
        if (from < 3) {
          // Recreate transaction_table to apply corrected constraints
          await m.drop(transactionTable);
          await m.create(transactionTable);
        }
        if (from < 4) {
          // Recreate user_table to apply corrected constraints
          await m.drop(userTable);
          await m.create(userTable);
        }
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');

        // Set WAL mode for better performance
        await customStatement('PRAGMA journal_mode = WAL');

        // Set synchronous mode for better performance
        await customStatement('PRAGMA synchronous = NORMAL');

        // Set cache size
        await customStatement('PRAGMA cache_size = 10000');

        // Set temp store to memory
        await customStatement('PRAGMA temp_store = MEMORY');
      },
    );
  }

  /// Insert default categories on database creation
  Future<void> _insertDefaultCategories() async {
    final defaultCategories = [
      // Income categories
      CategoryTableCompanion.insert(
        id: 'income_salary',
        name: 'Salary',
        iconName: 'work',
        color: 0xFF4CAF50,
        type: 'income',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'income_business',
        name: 'Business',
        iconName: 'business',
        color: 0xFF2196F3,
        type: 'income',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'income_investment',
        name: 'Investment',
        iconName: 'trending_up',
        color: 0xFF9C27B0,
        type: 'income',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'income_other',
        name: 'Other Income',
        iconName: 'attach_money',
        color: 0xFF607D8B,
        type: 'income',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),

      // Expense categories
      CategoryTableCompanion.insert(
        id: 'expense_food',
        name: 'Food & Dining',
        iconName: 'restaurant',
        color: 0xFFFF9800,
        type: 'expense',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'expense_transport',
        name: 'Transportation',
        iconName: 'directions_car',
        color: 0xFF3F51B5,
        type: 'expense',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'expense_shopping',
        name: 'Shopping',
        iconName: 'shopping_bag',
        color: 0xFFE91E63,
        type: 'expense',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'expense_entertainment',
        name: 'Entertainment',
        iconName: 'movie',
        color: 0xFF9C27B0,
        type: 'expense',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'expense_bills',
        name: 'Bills & Utilities',
        iconName: 'receipt',
        color: 0xFF795548,
        type: 'expense',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'expense_healthcare',
        name: 'Healthcare',
        iconName: 'local_hospital',
        color: 0xFFF44336,
        type: 'expense',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'expense_education',
        name: 'Education',
        iconName: 'school',
        color: 0xFF4CAF50,
        type: 'expense',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'expense_travel',
        name: 'Travel',
        iconName: 'flight',
        color: 0xFF00BCD4,
        type: 'expense',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
      CategoryTableCompanion.insert(
        id: 'expense_other',
        name: 'Other Expenses',
        iconName: 'more_horiz',
        color: 0xFF607D8B,
        type: 'expense',
        isDefault: const Value(true),
        createdAt: DateTime.now(),
      ),
    ];

    for (final category in defaultCategories) {
      await into(categoryTable).insert(category);
    }
  }

  // User queries
  Future<List<UserTableData>> getAllUsers() => select(userTable).get();

  Future<UserTableData?> getUserById(String id) =>
      (select(userTable)..where((u) => u.id.equals(id))).getSingleOrNull();

  Future<int> insertUser(UserTableCompanion user) =>
      into(userTable).insert(user);

  Future<bool> updateUser(UserTableCompanion user) =>
      update(userTable).replace(user);

  Future<int> deleteUser(String id) =>
      (delete(userTable)..where((u) => u.id.equals(id))).go();

  // Transaction queries
  Future<List<TransactionTableData>> getAllTransactions({String? userId}) {
    final query = select(transactionTable);
    if (userId != null) {
      query.where((t) => t.userId.equals(userId));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
    ]);
    return query.get();
  }

  Future<List<TransactionTableData>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
    String? categoryId,
    String? type,
  }) {
    final query = select(transactionTable);

    query.where(
      (t) => t.date.isBetween(Variable(startDate), Variable(endDate)),
    );

    if (userId != null) {
      query.where((t) => t.userId.equals(userId));
    }

    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }

    if (type != null) {
      query.where((t) => t.type.equals(type));
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
    ]);

    return query.get();
  }

  Future<TransactionTableData?> getTransactionById(String id) => (select(
    transactionTable,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertTransaction(TransactionTableCompanion transaction) =>
      into(transactionTable).insert(transaction);

  Future<bool> updateTransaction(TransactionTableCompanion transaction) =>
      update(transactionTable).replace(transaction);

  Future<int> deleteTransaction(String id) =>
      (delete(transactionTable)..where((t) => t.id.equals(id))).go();

  // Category queries
  Future<List<CategoryTableData>> getAllCategories({String? type}) {
    final query = select(categoryTable);
    if (type != null) {
      query.where((c) => c.type.equals(type));
    }
    query.where((c) => c.isActive.equals(true));
    query.orderBy([
      (c) => OrderingTerm(expression: c.name, mode: OrderingMode.asc),
    ]);
    return query.get();
  }

  Future<CategoryTableData?> getCategoryById(String id) =>
      (select(categoryTable)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> insertCategory(CategoryTableCompanion category) =>
      into(categoryTable).insert(category);

  Future<bool> updateCategory(CategoryTableCompanion category) =>
      update(categoryTable).replace(category);

  Future<int> deleteCategory(String id) =>
      (update(categoryTable)..where((c) => c.id.equals(id))).write(
        const CategoryTableCompanion(isActive: Value(false)),
      );

  // Budget queries
  Future<List<BudgetTableData>> getAllBudgets({String? userId}) {
    final query = select(budgetTable);
    if (userId != null) {
      query.where((b) => b.userId.equals(userId));
    }
    query.where((b) => b.isActive.equals(true));
    query.orderBy([
      (b) => OrderingTerm(expression: b.startDate, mode: OrderingMode.desc),
    ]);
    return query.get();
  }

  Future<List<BudgetTableData>> getActiveBudgets(String userId) {
    final now = DateTime.now();
    return (select(budgetTable)..where(
          (b) =>
              b.userId.equals(userId) &
              b.isActive.equals(true) &
              b.startDate.isSmallerOrEqualValue(now) &
              b.endDate.isBiggerOrEqualValue(now),
        ))
        .get();
  }

  Future<BudgetTableData?> getBudgetById(String id) =>
      (select(budgetTable)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<int> insertBudget(BudgetTableCompanion budget) =>
      into(budgetTable).insert(budget);

  Future<bool> updateBudget(BudgetTableCompanion budget) =>
      update(budgetTable).replace(budget);

  Future<int> deleteBudget(String id) =>
      (update(budgetTable)..where((b) => b.id.equals(id))).write(
        const BudgetTableCompanion(isActive: Value(false)),
      );

  // Analytics queries
  Future<Map<String, double>> getSpendingByCategory(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final query = customSelect(
      '''
      SELECT c.name, SUM(t.amount) as total
      FROM transaction_table t
      JOIN category_table c ON t.category_id = c.id
      WHERE t.user_id = ? AND t.type = 'expense' 
        AND t.date BETWEEN ? AND ?
      GROUP BY c.id, c.name
      ORDER BY total DESC
      ''',
      variables: [
        Variable.withString(userId),
        Variable.withDateTime(startDate),
        Variable.withDateTime(endDate),
      ],
      readsFrom: {transactionTable, categoryTable},
    );

    final results = await query.get();
    return Map.fromEntries(
      results.map(
        (row) => MapEntry(
          row.data['name'] as String,
          (row.data['total'] as num).toDouble(),
        ),
      ),
    );
  }

  Future<double> getTotalBalance(String userId) async {
    final incomeQuery = customSelect(
      '''
      SELECT SUM(amount) as total
      FROM transaction_table
      WHERE user_id = ? AND type = 'income'
      ''',
      variables: [Variable.withString(userId)],
      readsFrom: {transactionTable},
    );

    final expenseQuery = customSelect(
      '''
      SELECT SUM(amount) as total
      FROM transaction_table
      WHERE user_id = ? AND type = 'expense'
      ''',
      variables: [Variable.withString(userId)],
      readsFrom: {transactionTable},
    );

    final incomeResult = await incomeQuery.getSingle();
    final expenseResult = await expenseQuery.getSingle();

    final totalIncome = (incomeResult.data['total'] as num?)?.toDouble() ?? 0.0;
    final totalExpense =
        (expenseResult.data['total'] as num?)?.toDouble() ?? 0.0;

    return totalIncome - totalExpense;
  }

  Future<Map<String, double>> getMonthlyTrend(String userId, int months) async {
    final endDate = DateTime.now();
    final startDate = DateTime(endDate.year, endDate.month - months, 1);

    final query = customSelect(
      '''
      SELECT 
        strftime('%Y-%m', date) as month,
        SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as income,
        SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as expense
      FROM transaction_table
      WHERE user_id = ? AND date BETWEEN ? AND ?
      GROUP BY strftime('%Y-%m', date)
      ORDER BY month
      ''',
      variables: [
        Variable.withString(userId),
        Variable.withDateTime(startDate),
        Variable.withDateTime(endDate),
      ],
      readsFrom: {transactionTable},
    );

    final results = await query.get();
    final trend = <String, double>{};

    for (final row in results) {
      final month = row.data['month'] as String;
      final income = (row.data['income'] as num?)?.toDouble() ?? 0.0;
      final expense = (row.data['expense'] as num?)?.toDouble() ?? 0.0;
      trend[month] = income - expense;
    }

    return trend;
  }

  // Utility methods
  Future<void> clearAllData() async {
    await delete(transactionTable).go();
    await delete(budgetTable).go();
    await delete(userTable).go();
    // Don't delete categories as they might be default
    await (delete(categoryTable)..where((c) => c.isDefault.equals(false))).go();
  }

  Future<void> clearUserData(String userId) async {
    await (delete(
      transactionTable,
    )..where((t) => t.userId.equals(userId))).go();
    await (delete(budgetTable)..where((b) => b.userId.equals(userId))).go();
    await (delete(userTable)..where((u) => u.id.equals(userId))).go();
  }
}

/// Database connection setup
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kas_finance.db'));

    // Make sure SQLite3 is available
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
