import '../models/expense.dart';
import 'database_helper.dart';

class ExpenseRepository {
  final DatabaseHelper _helper;
  ExpenseRepository(this._helper);

  Future<List<Expense>> getAll() async {
    final db = await _helper.database;
    final rows = await db.query('expenses', orderBy: 'date DESC');
    return rows.map(Expense.fromMap).toList();
  }

  Future<int> update(Expense e) async {
    final db = await _helper.database;
    return db.update('expenses', e.toMap(),
        where: 'id = ?', whereArgs: [e.id]);
  }

  Future<int> insert(Expense e) async {
    final db = await _helper.database;
    final map = e.toMap()..remove('id');
    return db.insert('expenses', map);
  }
}
