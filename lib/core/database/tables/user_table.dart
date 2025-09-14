import 'package:drift/drift.dart';

/// User table definition
@DataClassName('UserTableData')
class UserTable extends Table {
  @override
  String get tableName => 'user_table';

  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  BoolColumn get isEmailVerified =>
      boolean().withDefault(const Constant(false))();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ["CHECK (email LIKE '%@%.%')"];
}
