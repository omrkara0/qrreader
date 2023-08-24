import 'package:qrreader/model/historyModel.dart';
import 'package:sqflite/sqflite.dart';

Future<void> insertHistory(HistoryModel historyModel, Database database) async {
  // Get a reference to the database.
  final db = await database;

  await db.insert(
    'history',
    historyModel.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
