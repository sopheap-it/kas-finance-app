import 'package:drift/drift.dart';

/// Transaction table definition
@DataClassName('TransactionTableData')
class TransactionTable extends Table {
  @override
  String get tableName => 'transaction_table';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  RealColumn get amount => real()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get categoryId => text()();
  TextColumn get type => text()(); // 'income' or 'expense'
  DateTimeColumn get date => dateTime()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get receiptImageUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (amount > 0)',
    "CHECK (type IN ('income', 'expense'))",
  ];
}
