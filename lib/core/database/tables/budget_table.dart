import 'package:drift/drift.dart';

/// Budget table definition
@DataClassName('BudgetTableData')
class BudgetTable extends Table {
  @override
  String get tableName => 'budget_table';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get amount => real()();
  RealColumn get spent => real().withDefault(const Constant(0.0))();
  TextColumn get categoryId => text().nullable()(); // null means overall budget
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (amount > 0)',
    'CHECK (spent >= 0)',
    "CHECK (start_date < end_date)",
  ];
}
