class CountryData {
  int? id;
  int userId;
  int population;
  double urbanizationRate;
  String fuelDependency;
  String incomeLevel;
  String politicalStability;
  DateTime? createdAt;

  CountryData({
    this.id,
    required this.userId,
    required this.population,
    required this.urbanizationRate,
    required this.fuelDependency,
    required this.incomeLevel,
    required this.politicalStability,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'population': population,
      'urbanization_rate': urbanizationRate,
      'fuel_dependency': fuelDependency,
      'income_level': incomeLevel,
      'political_stability': politicalStability,
    };
  }

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      id: json['id'],
      userId: json['user_id'],
      population: json['population'] is int
          ? json['population']
          : int.tryParse(json['population'].toString()) ?? 0,

      urbanizationRate: json['urbanization_rate'] == null
          ? 0.0
          : json['urbanization_rate'] is num
          ? (json['urbanization_rate'] as num).toDouble()
          : double.tryParse(json['urbanization_rate'].toString()) ?? 0.0,

      fuelDependency: json['fuel_dependency']?.toString() ?? '-',
      incomeLevel: json['income_level']?.toString() ?? '-',
      politicalStability: json['political_stability']?.toString() ?? '-',

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
    );
  }
}
