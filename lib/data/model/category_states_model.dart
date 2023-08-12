class CategoryStatesModel {
  final String name;
  final double totalCount;
  CategoryStatesModel({
    required this.name,
    required this.totalCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'totalCount': totalCount,
    };
  }

  factory CategoryStatesModel.fromMap(Map<String, dynamic> map) {
    return CategoryStatesModel(
      name: map['name'],
      totalCount: map['totalCount'],
    );
  }

  @override
  String toString() =>
      'CategoryStatesModel(name: $name, totalCount: $totalCount)';
}
