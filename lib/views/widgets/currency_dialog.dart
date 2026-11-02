import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/currency_viewmodel.dart';

class CurrencyDialog extends ConsumerStatefulWidget {
  final String current;
  const CurrencyDialog({super.key, required this.current});

  @override
  ConsumerState<CurrencyDialog> createState() => _CurrencyDialogState();
}

class _CurrencyDialogState extends ConsumerState<CurrencyDialog> {
  late String _selected = widget.current;

  Widget _option(String value, String label) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(_selected == value
          ? Icons.radio_button_checked
          : Icons.radio_button_unchecked),
      title: Text(label),
      onTap: () => setState(() => _selected = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Đơn vị tiền tệ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _option('VND', 'VND (Việt Nam Đồng)'),
          _option('USD', 'USD (Đô la Mỹ)'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () async {
            await ref.read(currencySettingProvider.notifier).setCurrency(_selected);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
