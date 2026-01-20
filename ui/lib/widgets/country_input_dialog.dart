import 'package:flutter/material.dart';
import '../models/country_data.dart';

class CountryInputDialog extends StatefulWidget {
  final int userId;
  final Function(CountryData) onSave;

  const CountryInputDialog({
    super.key,
    required this.userId,
    required this.onSave,
  });

  @override
  _CountryInputDialogState createState() => _CountryInputDialogState();
}

class _CountryInputDialogState extends State<CountryInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _populationController = TextEditingController();
  final _urbanizationController = TextEditingController();

  String? _selectedFuelDependency;
  String? _selectedIncomeLevel;
  String? _selectedPoliticalStability;

  final Map<String, String> fuelDependencyOptions = {
    'low': 'Rendah',
    'medium': 'Sedang',
    'high': 'Tinggi',
  };

  final Map<String, String> incomeLevelOptions = {
    'low': 'Rendah',
    'lower-middle': 'Menengah Bawah',
    'upper-middle': 'Menengah Atas',
    'high': 'Tinggi',
  };

  final Map<String, String> politicalStabilityOptions = {
    'low': 'Rendah',
    'medium': 'Sedang',
    'high': 'Tinggi',
  };

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final countryData = CountryData(
        userId: widget.userId,
        population: int.parse(_populationController.text),
        urbanizationRate: double.parse(_urbanizationController.text),
        fuelDependency: _selectedFuelDependency!,
        incomeLevel: _selectedIncomeLevel!,
        politicalStability: _selectedPoliticalStability!,
      );

      widget.onSave(countryData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final isDesktop = screenWidth >= 1024;

    // Menentukan tinggi maksimum dialog berdasarkan ukuran layar
    final maxDialogHeight = screenHeight * 0.85;
    final dialogWidth = isDesktop
        ? screenWidth * 0.5
        : isTablet
        ? screenWidth * 0.7
        : screenWidth * 0.9;

    return Dialog(
      insetPadding: EdgeInsets.zero, // Reset padding untuk kontrol penuh
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: maxDialogHeight,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(
              isDesktop
                  ? 32
                  : isTablet
                  ? 24
                  : 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        'Konfigurasi Negara',
                        style: TextStyle(
                          fontSize: isDesktop
                              ? 24
                              : isTablet
                              ? 20
                              : 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_outlined,
                        color: Colors.grey.shade500,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Population Input
                      _buildInputSection(
                        icon: Icons.people_outlined,
                        title: 'Populasi',
                        description: 'Jumlah total populasi',
                        child: TextFormField(
                          controller: _populationController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: isDesktop ? 16 : 15),
                          decoration: InputDecoration(
                            hintText: 'Masukkan total populasi',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.blue.shade400,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(
                              Icons.numbers_outlined,
                              color: Colors.grey.shade500,
                            ),
                            suffixText: 'orang',
                            suffixStyle: TextStyle(color: Colors.grey.shade500),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Populasi wajib diisi';
                            }
                            final pop = int.tryParse(value);
                            if (pop == null || pop <= 0) {
                              return 'Masukkan angka positif';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Urbanization Rate Input
                      _buildInputSection(
                        icon: Icons.location_city_outlined,
                        title: 'Tingkat Urbanisasi',
                        description: '',
                        child: TextFormField(
                          controller: _urbanizationController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: TextStyle(fontSize: isDesktop ? 16 : 15),
                          decoration: InputDecoration(
                            hintText: '0 - 100',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.blue.shade400,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(
                              Icons.trending_up_outlined,
                              color: Colors.grey.shade500,
                            ),
                            suffixText: '%',
                            suffixStyle: TextStyle(color: Colors.grey.shade500),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tingkat urbanisasi wajib diisi';
                            }
                            final rate = double.tryParse(value);
                            if (rate == null || rate < 0 || rate > 100) {
                              return 'Masukkan nilai antara 0 dan 100';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Fuel Dependency Dropdown
                      _buildInputSection(
                        icon: Icons.local_gas_station_outlined,
                        title: 'Ketergantungan Bahan Bakar',
                        description: 'Tingkat ketergantungan pada bahan bakar',
                        child: DropdownButtonFormField<String>(
                          value: _selectedFuelDependency,
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 15,
                            color: Colors.grey.shade800,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Pilih tingkat ketergantungan',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.blue.shade400,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(
                              Icons.opacity_outlined,
                              color: Colors.grey.shade500,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          items: fuelDependencyOptions.entries.map((entry) {
                            return DropdownMenuItem(
                              value: entry.key,
                              child: Row(
                                children: [
                                  _buildDependencyIndicator(entry.key),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      entry.value,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFuelDependency = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Harap pilih tingkat ketergantungan bahan bakar';
                            }
                            return null;
                          },
                          isExpanded: true,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Income Level Dropdown
                      _buildInputSection(
                        icon: Icons.attach_money_outlined,
                        title: 'Tingkat Pendapatan',
                        description: 'Tingkat pendapatan rata-rata populasi',
                        child: DropdownButtonFormField<String>(
                          value: _selectedIncomeLevel,
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 15,
                            color: Colors.grey.shade800,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Pilih tingkat pendapatan',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.blue.shade400,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.grey.shade500,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          items: incomeLevelOptions.entries.map((entry) {
                            return DropdownMenuItem(
                              value: entry.key,
                              child: Row(
                                children: [
                                  _buildIncomeIndicator(entry.key),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      entry.value,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedIncomeLevel = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Harap pilih tingkat pendapatan';
                            }
                            return null;
                          },
                          isExpanded: true,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Political Stability Dropdown
                      _buildInputSection(
                        icon: Icons.policy_outlined,
                        title: 'Stabilitas Politik',
                        description: '',
                        child: DropdownButtonFormField<String>(
                          value: _selectedPoliticalStability,
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 15,
                            color: Colors.grey.shade800,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Pilih tingkat stabilitas',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.blue.shade400,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(
                              Icons.shield_outlined,
                              color: Colors.grey.shade500,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          items: politicalStabilityOptions.entries.map((entry) {
                            return DropdownMenuItem(
                              value: entry.key,
                              child: Row(
                                children: [
                                  _buildStabilityIndicator(entry.key),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      entry.value,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPoliticalStability = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Harap pilih tingkat stabilitas politik';
                            }
                            return null;
                          },
                          isExpanded: true,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isVerticalLayout = constraints.maxWidth < 400;

                          return isVerticalLayout
                              ? Column(
                                  children: [
                                    OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.grey.shade700,
                                        side: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: isDesktop ? 16 : 14,
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          'Batal',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isDesktop ? 16 : 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade600,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: isDesktop ? 16 : 14,
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.save_outlined,
                                              size: isDesktop ? 20 : 18,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Simpan Konfigurasi',
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
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.grey.shade700,
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: isDesktop ? 16 : 14,
                                          ),
                                        ),
                                        child: Text(
                                          'Batal',
                                          style: TextStyle(
                                            fontSize: isDesktop ? 16 : 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue.shade600,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: isDesktop ? 16 : 14,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.save_outlined,
                                              size: isDesktop ? 20 : 18,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Simpan Konfigurasi',
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
                                );
                        },
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

  Widget _buildInputSection({
    required IconData icon,
    required String title,
    required String description,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: Colors.blue.shade600),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildDependencyIndicator(String level) {
    Color color;
    switch (level) {
      case 'low':
        color = Colors.green.shade600;
        break;
      case 'medium':
        color = Colors.orange.shade600;
        break;
      case 'high':
        color = Colors.red.shade600;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildIncomeIndicator(String level) {
    IconData icon;
    Color color;
    switch (level) {
      case 'low':
        icon = Icons.arrow_downward_outlined;
        color = Colors.red.shade600;
        break;
      case 'lower-middle':
        icon = Icons.arrow_downward_outlined;
        color = Colors.orange.shade600;
        break;
      case 'upper-middle':
        icon = Icons.arrow_upward_outlined;
        color = Colors.green.shade600;
        break;
      case 'high':
        icon = Icons.arrow_upward_outlined;
        color = Colors.blue.shade600;
        break;
      default:
        icon = Icons.remove_outlined;
        color = Colors.grey;
    }

    return Icon(icon, size: 14, color: color);
  }

  Widget _buildStabilityIndicator(String level) {
    IconData icon;
    Color color;
    switch (level) {
      case 'low':
        icon = Icons.warning_outlined;
        color = Colors.red.shade600;
        break;
      case 'medium':
        icon = Icons.remove_outlined;
        color = Colors.orange.shade600;
        break;
      case 'high':
        icon = Icons.check_circle_outlined;
        color = Colors.green.shade600;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Icon(icon, size: 14, color: color);
  }

  @override
  void dispose() {
    _populationController.dispose();
    _urbanizationController.dispose();
    super.dispose();
  }
}
