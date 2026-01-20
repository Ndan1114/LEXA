class SimulationResult {
  int? simulationId;
  String shortTermImpact;
  String longTermImpact;
  double riskProbability;
  String confidenceLevel;

  SimulationResult({
    this.simulationId,
    required this.shortTermImpact,
    required this.longTermImpact,
    required this.riskProbability,
    required this.confidenceLevel,
  });

  factory SimulationResult.fromJson(Map<String, dynamic> json) {
    return SimulationResult(
      simulationId: json['simulation_id'],
      shortTermImpact: json['short_term_impact'] ?? '-',
      longTermImpact: json['long_term_impact'] ?? '-',
      riskProbability: json['risk_probability'] == null
          ? 0.0
          : json['risk_probability'] is num
          ? (json['risk_probability'] as num).toDouble()
          : double.tryParse(json['risk_probability'].toString()) ?? 0.0,
      confidenceLevel: json['confidence_level'] ?? 'Unknown',
    );
  }
}
