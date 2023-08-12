class MonthlySalesModel {
  final String name;
  final String count;
  MonthlySalesModel({
    required this.name,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'count': count,
    };
  }

  factory MonthlySalesModel.fromMap(Map<String, dynamic> map) {
    return MonthlySalesModel(
      name: map['name'] as String,
      count: map['count'] as String,
    );
  }

  @override
  String toString() => 'MonthlyEarningModel(name: $name, count: $count)';
}
