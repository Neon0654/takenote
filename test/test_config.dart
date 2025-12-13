import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void setupTestEnvironment() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
