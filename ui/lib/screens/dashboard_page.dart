import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/country_input_dialog.dart';
import '../widgets/policy_input_dialog.dart';
import '../widgets/simulation_result_dialog.dart';
import '../models/country_data.dart';
import '../models/policy_data.dart';
import '../models/simulation_result.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? _userData;
  CountryData? _currentCountryData;
  bool _isLoading = true;
  SimulationResult? _latestSimulationResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          _userData = args;
        });
        _loadUserCountryData();
      }
    });
  }

  Future<void> _loadUserCountryData() async {
    if (_userData == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.getUserCountryData(_userData!['id']);
      if (result['success'] && result['data'] != null) {
        setState(() {
          _currentCountryData = CountryData.fromJson(result['data']);
        });
      }
    } catch (e) {
      _showSnackBar('Kesalahan memuat data negara');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCountryData(CountryData data) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.saveCountryData(data);
      if (result['success']) {
        setState(() {
          _currentCountryData = data;
          _currentCountryData!.id = result['data']['country_data_id'];
        });
        _showSnackBar('Data negara berhasil disimpan', isError: false);
      } else {
        _showSnackBar('Kesalahan: ${result['message']}');
      }
    } catch (e) {
      _showSnackBar('Kesalahan koneksi');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _runSimulation(PolicyData policyData) async {
    if (_currentCountryData == null || _currentCountryData!.id == null) {
      _showSnackBar('Harap input data negara terlebih dahulu');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.runSimulation(
        _userData!['id'],
        _currentCountryData!.id!,
        policyData,
      );

      if (result['success']) {
        final simulationResult = SimulationResult.fromJson(result['data']);
        setState(() {
          _latestSimulationResult = simulationResult;
        });

        showDialog(
          context: context,
          builder: (context) =>
              SimulationResultDialog(result: simulationResult),
        );
      } else {
        _showSnackBar('Kesalahan: ${result['message']}');
      }
    } catch (e) {
      _showSnackBar('Kesalahan koneksi');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showCountryInputDialog() {
    showDialog(
      context: context,
      builder: (context) => CountryInputDialog(
        userId: _userData!['id'],
        onSave: _saveCountryData,
      ),
    ).then((_) => _loadUserCountryData());
  }

  void _showPolicyInputDialog() {
    showDialog(
      context: context,
      builder: (context) => PolicyInputDialog(onSimulate: _runSimulation),
    );
  }

  void _navigateToHistory() {
    Navigator.pushNamed(context, '/history', arguments: _userData);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  title: Text(
                    'Dasbor',
                    style: TextStyle(
                      fontSize: isDesktop ? 24 : 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.history_outlined,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: _navigateToHistory,
                      tooltip: 'Riwayat Simulasi',
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.person_outline,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: () {
                        // Profile action
                      },
                      tooltip: 'Profil',
                    ),
                  ],
                ),

                // Main Content
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop
                        ? 40
                        : isTablet
                        ? 24
                        : 16,
                    vertical: 20,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Welcome Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade100,
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat datang kembali, ${_userData?['username'] ?? 'Pengguna'}!',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Platform Simulasi Kebijakan AI',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Country Data Card
                      _buildCountryDataCard(isDesktop, isTablet),

                      const SizedBox(height: 20),

                      // Quick Actions Grid
                      _buildQuickActionsGrid(isDesktop, isTablet),

                      const SizedBox(height: 20),

                      // Latest Simulation Result
                      if (_latestSimulationResult != null)
                        _buildLatestResultCard(isDesktop, isTablet),

                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCountryDataCard(bool isDesktop, bool isTablet) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isDesktop
              ? 28
              : isTablet
              ? 24
              : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Data Negara',
                  style: TextStyle(
                    fontSize: isDesktop ? 20 : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                if (_currentCountryData != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Terkonfigurasi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _currentCountryData != null
                ? _buildCountryDataDetails(isDesktop, isTablet)
                : _buildEmptyState(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: isDesktop ? 52 : 48,
              child: ElevatedButton(
                onPressed: _showCountryInputDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _currentCountryData != null
                          ? Icons.edit_outlined
                          : Icons.add_outlined,
                      size: isDesktop ? 20 : 18,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _currentCountryData != null
                          ? 'Edit Data Negara'
                          : 'Konfigurasi Data Negara',
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryDataDetails(bool isDesktop, bool isTablet) {
    return Column(
      children: [
        Row(
          children: [
            _buildDataItem(
              icon: Icons.people_outline,
              label: 'Populasi',
              value: _currentCountryData!.population.toString(),
            ),
            const SizedBox(width: 16),
            _buildDataItem(
              icon: Icons.location_city_outlined,
              label: 'Urbanisasi',
              value: '${_currentCountryData!.urbanizationRate}%',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildDataItem(
              icon: Icons.local_gas_station_outlined,
              label: 'Ketergantungan Bahan Bakar',
              value: _currentCountryData!.fuelDependency,
            ),
            const SizedBox(width: 16),
            _buildDataItem(
              icon: Icons.attach_money_outlined,
              label: 'Tingkat Pendapatan',
              value: _currentCountryData!.incomeLevel,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildDataItem(
              icon: Icons.policy_outlined,
              label: 'Stabilitas Politik',
              value: _currentCountryData!.politicalStability,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.blue.shade600),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Belum Ada Data Negara',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(bool isDesktop, bool isTablet) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isDesktop
              ? 28
              : isTablet
              ? 24
              : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aksi Cepat',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isDesktop
                  ? 3
                  : isTablet
                  ? 2
                  : 1,
              childAspectRatio: isDesktop
                  ? 2
                  : isTablet
                  ? 2.5
                  : 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildActionCard(
                  icon: Icons.play_arrow_outlined,
                  title: 'Jalankan Simulasi',
                  description: 'Simulasi kebijakan',
                  color: Colors.blue.shade600,
                  onTap: _currentCountryData != null
                      ? _showPolicyInputDialog
                      : null,
                ),
                _buildActionCard(
                  icon: Icons.timeline_outlined,
                  title: 'Lihat Riwayat',
                  description: 'Hasil simulasi sebelumnya',
                  color: Colors.purple.shade600,
                  onTap: _navigateToHistory,
                ),
                _buildActionCard(
                  icon: Icons.insights_outlined,
                  title: 'Analitik',
                  description: 'Analisis lanjutan',
                  color: Colors.green.shade600,
                  onTap: () {
                    // Analytics action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_outlined, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestResultCard(bool isDesktop, bool isTablet) {
    final result = _latestSimulationResult!;

    Color riskColor;
    if (result.riskProbability < 0.3) {
      riskColor = Colors.green;
    } else if (result.riskProbability < 0.6) {
      riskColor = Colors.orange;
    } else {
      riskColor = Colors.red;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wawasan Simulasi AI',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            _buildInsightItem(
              'Dampak Jangka Pendek',
              result.shortTermImpact,
              Icons.flash_on_outlined,
              Colors.blue,
            ),
            const SizedBox(height: 12),

            _buildInsightItem(
              'Dampak Jangka Panjang',
              result.longTermImpact,
              Icons.trending_up_outlined,
              Colors.purple,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _buildResultMetric(
                  label: 'Probabilitas Risiko',
                  value:
                      '${(result.riskProbability * 100).toStringAsFixed(1)}%',
                  color: riskColor,
                ),
                const SizedBox(width: 16),
                _buildResultMetric(
                  label: 'Tingkat Keyakinan',
                  value: result.confidenceLevel,
                  color: Colors.blueGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultMetric({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
