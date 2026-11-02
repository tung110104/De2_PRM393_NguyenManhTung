import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/settings_repository.dart';

part 'currency_viewmodel.g.dart';

const double kUsdRate = 25000;

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) => SettingsRepository();

@Riverpod(keepAlive: true)
class CurrencySetting extends _$CurrencySetting {
  @override
  Future<String> build() {
    return ref.read(settingsRepositoryProvider).getCurrency();
  }

  Future<void> setCurrency(String value) async {
    state = AsyncData(value);
    await ref.read(settingsRepositoryProvider).saveCurrency(value);
  }
}

String formatMoney(double amountVnd, String currency) {
  if (currency == 'USD') {
    return '${NumberFormat('#,##0.00').format(amountVnd / kUsdRate)} USD';
  }
  return '${NumberFormat('#,###').format(amountVnd)} VND';
}
