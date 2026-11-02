import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'expenses.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            date INTEGER NOT NULL
          )
        ''');

        int d(int day) => DateTime(2026, 10, day).millisecondsSinceEpoch;
        final seed = [
          {'name': 'Ăn uống', 'amount': 150000, 'category': 'Sinh hoạt', 'date': d(29)},
          {'name': 'Di chuyển', 'amount': 50000, 'category': 'Đi lại', 'date': d(28)},
          {'name': 'Mua sách', 'amount': 200000, 'category': 'Học tập', 'date': d(27)},
          {'name': 'Mua sắm', 'amount': 1500000, 'category': 'Sinh hoạt', 'date': d(25)},
          {'name': 'Khám bệnh', 'amount': 3550000, 'category': 'Sức khỏe', 'date': d(22)},
        ];
        for (final row in seed) {
          await db.insert('expenses', row);
        }
      },
    );
  }
}
