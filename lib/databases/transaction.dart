import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 128)();
  IntColumn get category_id => integer().autoIncrement()();
  IntColumn get amount => integer().autoIncrement()();
  DateTimeColumn get transcation_date => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deltedAt => dateTime().nullable()();
}
