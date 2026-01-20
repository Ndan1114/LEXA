import 'package:flutter/material.dart';
import '../models/simulation_result.dart';

class SimulationResultDialog extends StatelessWidget {
  final SimulationResult result;

  const SimulationResultDialog({super.key, required this.result});

  Color _getRiskColor(double probability) {
    if (probability < 30) return Colors.green.shade600;
    if (probability < 60) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Color _getConfidenceColor(String level) {
    switch (level.toLowerCase()) {
      case 'tinggi':
        return Colors.green.shade600;
      case 'sedang':
        return Colors.orange.shade600;
      case 'rendah':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String _getRiskLabel(double probability) {
    if (probability < 30) return 'Risiko Rendah';
    if (probability < 60) return 'Risiko Sedang';
    return 'Risiko Tinggi';
  }

  String _getConfidenceLabel(String level) {
    switch (level.toLowerCase()) {
      case 'tinggi':
        return 'Keyakinan Tinggi';
      case 'sedang':
        return 'Keyakinan Sedang';
      case 'rendah':
        return 'Keyakinan Rendah';
      default:
        return 'Tidak Diketahui';
    }
  }

  IconData _getRiskIcon(double probability) {
    if (probability < 30) return Icons.check_circle_outline;
    if (probability < 60) return Icons.warning_amber_outlined;
    return Icons.error_outline;
  }

  IconData _getConfidenceIcon(String level) {
    switch (level.toLowerCase()) {
      case 'tinggi':
        return Icons.verified_outlined;
      case 'sedang':
        return Icons.thumb_up_outlined;
      case 'rendah':
        return Icons.thumb_down_outlined;
      default:
        return Icons.help_outline;
    }
  }

  // Helper untuk responsive size
  double _responsiveSize(
    BuildContext context, {
    double small = 12,
    double medium = 16,
    double large = 20,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return small;
    if (width < 600) return medium;
    return large;
  }

  // Helper untuk font size
  double _fontSize(BuildContext context, {double base = 14}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return base * 0.85;
    if (width < 600) return base;
    return base * 1.1;
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
    IconData? icon,
    String? unit,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Container(
        padding: EdgeInsets.all(
          _responsiveSize(context, small: 12, medium: 16, large: 20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: _responsiveSize(
                  context,
                  small: 18,
                  medium: 20,
                  large: 22,
                ),
                color: color,
              ),
              SizedBox(
                height: _responsiveSize(
                  context,
                  small: 6,
                  medium: 8,
                  large: 10,
                ),
              ),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: _fontSize(context, base: 12),
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: _responsiveSize(context, small: 4, medium: 6, large: 8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: _fontSize(context, base: 22),
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (unit != null) ...[
                  SizedBox(
                    width: _responsiveSize(
                      context,
                      small: 2,
                      medium: 3,
                      large: 4,
                    ),
                  ),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: _fontSize(context, base: 12),
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          _responsiveSize(context, small: 12, medium: 16, large: 20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: _responsiveSize(
                    context,
                    small: 28,
                    medium: 32,
                    large: 36,
                  ),
                  height: _responsiveSize(
                    context,
                    small: 28,
                    medium: 32,
                    large: 36,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: _responsiveSize(
                      context,
                      small: 14,
                      medium: 16,
                      large: 18,
                    ),
                    color: Colors.blue.shade600,
                  ),
                ),
                SizedBox(
                  width: _responsiveSize(
                    context,
                    small: 10,
                    medium: 12,
                    large: 14,
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: _fontSize(context, base: 15),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: _responsiveSize(
                context,
                small: 10,
                medium: 12,
                large: 14,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: _fontSize(context, base: 13),
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationChip(
    BuildContext context,
    String text,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _responsiveSize(context, small: 10, medium: 12, large: 14),
        vertical: _responsiveSize(context, small: 6, medium: 8, large: 10),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: _fontSize(context, base: 12),
          fontWeight: FontWeight.w500,
          color: color,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmall = screenWidth < 360;
    final isSmall = screenWidth < 400;
    final isMedium = screenWidth < 600;
    final screenHeight = MediaQuery.of(context).size.height;

    final riskColor = _getRiskColor(result.riskProbability);
    final confidenceColor = _getConfidenceColor(result.confidenceLevel);
    final riskLabel = _getRiskLabel(result.riskProbability);
    final confidenceLabel = _getConfidenceLabel(result.confidenceLevel);

    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isVerySmall
              ? 8
              : isSmall
              ? 12
              : 16,
          vertical: MediaQuery.of(context).padding.top + 8,
        ),
        constraints: BoxConstraints(
          maxWidth: isMedium ? screenWidth : 500,
          maxHeight: screenHeight * 0.85,
        ),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(
                    _responsiveSize(context, small: 16, medium: 20, large: 24),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Hasil Simulasi',
                              style: TextStyle(
                                fontSize: _fontSize(context, base: 20),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: _responsiveSize(
                                context,
                                small: 18,
                                medium: 20,
                                large: 22,
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _responsiveSize(
                          context,
                          small: 4,
                          medium: 6,
                          large: 8,
                        ),
                      ),
                      Text(
                        'Analisis dampak kebijakan dan rekomendasi',
                        style: TextStyle(
                          fontSize: _fontSize(context, base: 13),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(
                    _responsiveSize(context, small: 16, medium: 20, large: 24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Key Metrics
                      Text(
                        'Metrik Utama',
                        style: TextStyle(
                          fontSize: _fontSize(context, base: 16),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),

                      SizedBox(
                        height: _responsiveSize(
                          context,
                          small: 12,
                          medium: 16,
                          large: 20,
                        ),
                      ),

                      // Grid metrics
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              context,
                              title: 'Probabilitas Risiko',
                              value: result.riskProbability.toStringAsFixed(1),
                              unit: '%',
                              color: riskColor,
                              icon: _getRiskIcon(result.riskProbability),
                            ),
                          ),
                          SizedBox(
                            width: _responsiveSize(
                              context,
                              small: 8,
                              medium: 12,
                              large: 16,
                            ),
                          ),
                          Expanded(
                            child: _buildMetricCard(
                              context,
                              title: 'Tingkat Keyakinan',
                              value: confidenceLabel,
                              color: confidenceColor,
                              icon: _getConfidenceIcon(result.confidenceLevel),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: _responsiveSize(
                          context,
                          small: 20,
                          medium: 24,
                          large: 28,
                        ),
                      ),

                      // Impact Analysis
                      Text(
                        'Analisis Dampak',
                        style: TextStyle(
                          fontSize: _fontSize(context, base: 16),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),

                      SizedBox(
                        height: _responsiveSize(
                          context,
                          small: 12,
                          medium: 16,
                          large: 20,
                        ),
                      ),

                      Column(
                        children: [
                          _buildImpactCard(
                            context,
                            title: 'Dampak Jangka Pendek',
                            description: result.shortTermImpact,
                            icon: Icons.timelapse_outlined,
                          ),
                          SizedBox(
                            height: _responsiveSize(
                              context,
                              small: 12,
                              medium: 16,
                              large: 20,
                            ),
                          ),
                          _buildImpactCard(
                            context,
                            title: 'Dampak Jangka Panjang',
                            description: result.longTermImpact,
                            icon: Icons.timeline_outlined,
                          ),
                        ],
                      ),

                      SizedBox(
                        height: _responsiveSize(
                          context,
                          small: 20,
                          medium: 24,
                          large: 28,
                        ),
                      ),

                      // Risk Summary
                      Container(
                        padding: EdgeInsets.all(
                          _responsiveSize(
                            context,
                            small: 12,
                            medium: 16,
                            large: 20,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: riskColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _getRiskIcon(result.riskProbability),
                              color: riskColor,
                              size: _responsiveSize(
                                context,
                                small: 18,
                                medium: 20,
                                large: 22,
                              ),
                            ),
                            SizedBox(
                              width: _responsiveSize(
                                context,
                                small: 10,
                                medium: 12,
                                large: 14,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ringkasan Risiko',
                                    style: TextStyle(
                                      fontSize: _fontSize(context, base: 14),
                                      fontWeight: FontWeight.w600,
                                      color: riskColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: _responsiveSize(
                                      context,
                                      small: 4,
                                      medium: 6,
                                      large: 8,
                                    ),
                                  ),
                                  Text(
                                    'Simulasi ini menunjukkan skenario $riskLabel. '
                                    'Tingkat keyakinan untuk hasil ini adalah ${result.confidenceLevel}.',
                                    style: TextStyle(
                                      fontSize: _fontSize(context, base: 12),
                                      color: Colors.grey.shade700,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: _responsiveSize(
                          context,
                          small: 20,
                          medium: 24,
                          large: 28,
                        ),
                      ),

                      // Recommendations
                      Text(
                        'Rekomendasi',
                        style: TextStyle(
                          fontSize: _fontSize(context, base: 16),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),

                      SizedBox(
                        height: _responsiveSize(
                          context,
                          small: 10,
                          medium: 12,
                          large: 14,
                        ),
                      ),

                      Wrap(
                        spacing: _responsiveSize(
                          context,
                          small: 6,
                          medium: 8,
                          large: 10,
                        ),
                        runSpacing: _responsiveSize(
                          context,
                          small: 6,
                          medium: 8,
                          large: 10,
                        ),
                        children: [
                          _buildRecommendationChip(
                            context,
                            'Pantau indikator utama',
                            Colors.blue.shade600,
                          ),
                          _buildRecommendationChip(
                            context,
                            'Pertimbangkan implementasi bertahap',
                            Colors.orange.shade600,
                          ),
                          _buildRecommendationChip(
                            context,
                            'Tinjau umpan balik pemangku kepentingan',
                            Colors.purple.shade600,
                          ),
                          if (result.riskProbability >= 60)
                            _buildRecommendationChip(
                              context,
                              'Kembangkan rencana kontinjensi',
                              Colors.red.shade600,
                            ),
                        ],
                      ),

                      SizedBox(
                        height: _responsiveSize(
                          context,
                          small: 24,
                          medium: 28,
                          large: 32,
                        ),
                      ),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: isVerySmall
                            ? 44
                            : isSmall
                            ? 46
                            : 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: _responsiveSize(
                                context,
                                small: 12,
                                medium: 16,
                                large: 20,
                              ),
                            ),
                          ),
                          child: Text(
                            'Tutup Hasil',
                            style: TextStyle(
                              fontSize: _fontSize(context, base: 14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
