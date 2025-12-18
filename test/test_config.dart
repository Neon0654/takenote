import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupTestEnvironment() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
