import 'package:drift/drift.dart';

/// Category table definition
@DataClassName('CategoryTableData')
class CategoryTable extends Table {
  @override
  String get tableName => 'category_table';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get iconName => text()();
  IntColumn get color => integer()();
  TextColumn get type => text()(); // 'income' or 'expense'
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    "CHECK (type IN ('income', 'expense'))",
    // Allow full 32-bit ARGB colors stored by Flutter (0..4294967295)
    'CHECK (color BETWEEN 0 AND 4294967295)',
    "UNIQUE (name, type)",
  ];
}
