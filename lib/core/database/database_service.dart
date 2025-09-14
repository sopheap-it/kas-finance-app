import 'app_database.dart';

/// Singleton service for managing the application database
class DatabaseService {
  static DatabaseService? _instance;
  static AppDatabase? _database;

  DatabaseService._internal();

  /// Get the singleton instance of DatabaseService
  static DatabaseService get instance {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }

  /// Get the database instance
  AppDatabase get database {
    _database ??= AppDatabase();
    return _database!;
  }

  /// Close the database connection
  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  /// Reset the database (for testing or data clearing)
  Future<void> reset() async {
    await close();
    _database = null;
  }
}
