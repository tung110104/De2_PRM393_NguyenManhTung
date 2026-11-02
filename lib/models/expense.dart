class Expense {
  final int? id;
  final String name;
  final double amount;
  final String category;
  final DateTime date;

  const Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
  });

  Expense copyWith({
    int? id,
    String? name,
    double? amount,
    String? category,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'amount': amount,
        'category': category,
        'date': date.millisecondsSinceEpoch,
      };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'] as int?,
        name: map['name'] as String,
        amount: (map['amount'] as num).toDouble(),
        category: map['category'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      );
}

const List<String> kCategories = [
  'Sinh hoạt',
  'Đi lại',
  'Học tập',
  'Sức khỏe',
  'Giải trí',
];
