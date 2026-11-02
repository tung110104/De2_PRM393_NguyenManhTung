import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/database_helper.dart';
import '../data/expense_repository.dart';
import '../models/expense.dart';

part 'expense_viewmodel.g.dart';

@Riverpod(keepAlive: true)
ExpenseRepository expenseRepository(Ref ref) {
  return ExpenseRepository(DatabaseHelper.instance);
}

@Riverpod(keepAlive: true)
class ExpenseList extends _$ExpenseList {
  @override
  Future<List<Expense>> build() async {
    return ref.read(expenseRepositoryProvider).getAll();
  }

  Future<void> updateExpense(Expense expense) async {
    await ref.read(expenseRepositoryProvider).update(expense);
    ref.invalidateSelf();
    await future;
  }
}
