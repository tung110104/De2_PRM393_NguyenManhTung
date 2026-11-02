import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/currency_viewmodel.dart';
import '../viewmodels/expense_viewmodel.dart';
import 'edit_expense_screen.dart';
import 'widgets/currency_dialog.dart';
import 'widgets/expense_card.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListProvider);
    final currency = ref.watch(currencySettingProvider).value ?? 'VND';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => CurrencyDialog(current: currency),
            ),
          ),
        ],
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
        data: (expenses) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: expenses.length,
          itemBuilder: (context, i) => ExpenseCard(
            expense: expenses[i],
            currency: currency,
            onEdit: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditExpenseScreen(expense: expenses[i]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
