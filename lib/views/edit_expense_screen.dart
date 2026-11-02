import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import '../viewmodels/expense_viewmodel.dart';

class EditExpenseScreen extends ConsumerStatefulWidget {
  final Expense expense;
  const EditExpenseScreen({super.key, required this.expense});

  @override
  ConsumerState<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _amountCtrl;
  late String _category;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final e = widget.expense;
    _nameCtrl = TextEditingController(text: e.name);
    _amountCtrl = TextEditingController(text: e.amount.toStringAsFixed(0));
    _category = kCategories.contains(e.category) ? e.category : kCategories.first;
    _date = e.date;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final updated = widget.expense.copyWith(
      name: _nameCtrl.text.trim(),
      amount: _parseAmount(_amountCtrl.text)!,
      category: _category,
      date: _date,
    );
    await ref.read(expenseListProvider.notifier).updateExpense(updated);
    if (mounted) Navigator.pop(context);
  }

  double? _parseAmount(String? text) =>
      double.tryParse((text ?? '').trim().replaceAll(RegExp(r'[,.\s]'), ''));

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 6),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(10));

    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa khoản chi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            _label('Tên khoản chi *'),
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(border: border),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Vui lòng nhập tên khoản chi'
                  : null,
            ),
            _label('Số tiền *'),
            TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: border, suffixText: 'VND'),
              validator: (v) {
                final n = _parseAmount(v);
                if (n == null || n <= 0) return 'Số tiền không hợp lệ';
                return null;
              },
            ),
            _label('Danh mục *'),
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: _category,
              decoration: InputDecoration(border: border),
              items: kCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            _label('Ngày chi tiêu *'),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  border: border,
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                child: Text(DateFormat('dd/MM/yyyy').format(_date)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
