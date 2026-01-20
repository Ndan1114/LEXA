import 'package:flutter/material.dart';
import '../models/policy_data.dart';

class PolicyInputDialog extends StatefulWidget {
  final Function(PolicyData) onSimulate;

  const PolicyInputDialog({super.key, required this.onSimulate});

  @override
  _PolicyInputDialogState createState() => _PolicyInputDialogState();
}

class _PolicyInputDialogState extends State<PolicyInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _percentageController = TextEditingController();
  final _targetController = TextEditingController();

  String? _selectedPolicyType;
  String? _selectedTimeFrame;

  final List<Map<String, dynamic>> policyTypes = [
    {
      'type': 'Subsidi BBM',
      'icon': Icons.local_gas_station_outlined,
      'color': Colors.orange,
      'description': 'Penyesuaian subsidi bahan bakar',
    },
    {
      'type': 'Pajak',
      'icon': Icons.account_balance_outlined,
      'color': Colors.purple,
      'description': 'Modifikasi kebijakan pajak',
    },
    {
      'type': 'Bantuan Sosial',
      'icon': Icons.people_outline,
      'color': Colors.blue,
      'description': 'Program kesejahteraan sosial',
    },
    {
      'type': 'Upah Minimum',
      'icon': Icons.attach_money_outlined,
      'color': Colors.green,
      'description': 'Regulasi upah minimum',
    },
  ];

  final List<Map<String, dynamic>> timeFrames = [
    {
      'frame': 'pendek',
      'label': 'Jangka Pendek',
      'duration': '0-2 tahun',
      'icon': Icons.timeline_outlined,
      'color': Colors.green,
    },
    {
      'frame': 'menengah',
      'label': 'Jangka Menengah',
      'duration': '3-5 tahun',
      'icon': Icons.timeline_outlined,
      'color': Colors.orange,
    },
    {
      'frame': 'panjang',
      'label': 'Jangka Panjang',
      'duration': '6+ tahun',
      'icon': Icons.timeline_outlined,
      'color': Colors.red,
    },
  ];

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedPolicyType != null &&
        _selectedTimeFrame != null) {
      final policyData = PolicyData(
        policyType: _selectedPolicyType!,
        percentageChange: double.parse(_percentageController.text),
        policyTarget: _targetController.text,
        timeFrame: _selectedTimeFrame!,
      );

      widget.onSimulate(policyData);
      Navigator.pop(context);
    }
  }

  // Helper untuk responsive size berdasarkan screen width
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

  // Helper untuk font size yang responsif
  double _fontSize(BuildContext context, {double base = 14}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return base * 0.85;
    if (width < 600) return base;
    return base * 1.1;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isVerySmall = screenWidth < 360;
    final isSmall = screenWidth < 400;
    final isMedium = screenWidth < 600;

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
          vertical: MediaQuery.of(context).viewInsets.bottom > 0
              ? MediaQuery.of(context).viewInsets.bottom + 8
              : MediaQuery.of(context).padding.top + 8,
        ),
        constraints: BoxConstraints(
          maxWidth: isMedium ? screenWidth : 500,
          maxHeight: screenHeight * 0.85,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(
              _responsiveSize(context, small: 12, medium: 16, large: 20),
            ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - lebih compact
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Simulasi Kebijakan',
                            style: TextStyle(
                              fontSize: _fontSize(context, base: 18),
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Konfigurasi parameter kebijakan untuk simulasi',
                            style: TextStyle(
                              fontSize: _fontSize(context, base: 12),
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey.shade500,
                        size: _responsiveSize(
                          context,
                          small: 18,
                          medium: 20,
                          large: 22,
                        ),
                      ),
                      padding: EdgeInsets.all(
                        _responsiveSize(
                          context,
                          small: 4,
                          medium: 8,
                          large: 12,
                        ),
                      ),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Policy Type Selection
                      _buildSectionTitle(
                        context,
                        icon: Icons.policy_outlined,
                        title: 'Jenis Kebijakan',
                      ),

                      const SizedBox(height: 8),

                      // Grid untuk jenis kebijakan - lebih fleksibel
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final gridWidth = constraints.maxWidth;
                          final crossAxisCount = gridWidth < 300
                              ? 1
                              : gridWidth < 500
                              ? 2
                              : 4;
                          final itemSpacing = isVerySmall ? 6.0 : 8.0;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: itemSpacing,
                                  mainAxisSpacing: itemSpacing,
                                  childAspectRatio: crossAxisCount == 1
                                      ? 3.5
                                      : crossAxisCount == 2
                                      ? 1.2
                                      : 1.1,
                                ),
                            itemCount: policyTypes.length,
                            itemBuilder: (context, index) {
                              final policy = policyTypes[index];
                              final isSelected =
                                  _selectedPolicyType == policy['type'];

                              return _buildPolicyTypeCard(
                                context,
                                icon: policy['icon'] as IconData,
                                title: policy['type'] as String,
                                description: policy['description'] as String,
                                color: policy['color'] as Color,
                                isSelected: isSelected,
                                crossAxisCount: crossAxisCount,
                                onTap: () {
                                  setState(() {
                                    _selectedPolicyType =
                                        policy['type'] as String;
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),

                      if (_selectedPolicyType == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Harap pilih jenis kebijakan',
                            style: TextStyle(
                              fontSize: _fontSize(context, base: 11),
                              color: Colors.red.shade600,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Percentage Change
                      _buildSectionTitle(
                        context,
                        icon: Icons.trending_up_outlined,
                        title: 'Besaran Perubahan',
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _percentageController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        style: TextStyle(
                          fontSize: _fontSize(context, base: 14),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Masukkan persentase perubahan',
                          hintStyle: TextStyle(
                            fontSize: _fontSize(context, base: 13),
                            color: Colors.grey.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blue.shade400,
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          prefixIcon: Icon(
                            Icons.percent,
                            color: Colors.grey.shade500,
                            size: _responsiveSize(
                              context,
                              small: 18,
                              medium: 20,
                              large: 22,
                            ),
                          ),
                          suffixText: '%',
                          suffixStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: _fontSize(context, base: 13),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: _responsiveSize(
                              context,
                              small: 12,
                              medium: 14,
                              large: 16,
                            ),
                            vertical: isVerySmall ? 10 : 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Persentase perubahan wajib diisi';
                          }
                          final percentage = double.tryParse(value);
                          if (percentage == null) {
                            return 'Masukkan angka yang valid';
                          }
                          if (percentage < -100 || percentage > 100) {
                            return 'Masukkan nilai antara -100 dan 100';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Policy Target
                      _buildSectionTitle(
                        context,
                        icon: Icons.flag_outlined,
                        title: 'Target Kebijakan',
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _targetController,
                        style: TextStyle(
                          fontSize: _fontSize(context, base: 14),
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Contoh: Transportasi perkotaan, Sektor industri',
                          hintStyle: TextStyle(
                            fontSize: _fontSize(context, base: 13),
                            color: Colors.grey.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blue.shade400,
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          prefixIcon: Icon(
                            Icons.flag_outlined,
                            color: Colors.grey.shade500,
                            size: _responsiveSize(
                              context,
                              small: 18,
                              medium: 20,
                              large: 22,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: _responsiveSize(
                              context,
                              small: 12,
                              medium: 14,
                              large: 16,
                            ),
                            vertical: isVerySmall ? 10 : 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Target kebijakan wajib diisi';
                          }
                          return null;
                        },
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),

                      const SizedBox(height: 16),

                      // Time Frame Selection
                      _buildSectionTitle(
                        context,
                        icon: Icons.schedule_outlined,
                        title: 'Rentang Waktu',
                      ),

                      const SizedBox(height: 8),

                      // Time frame cards - lebih responsif
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        child: Row(
                          children: timeFrames.asMap().entries.map((entry) {
                            final index = entry.key;
                            final frame = entry.value;
                            final isSelected =
                                _selectedTimeFrame == frame['frame'];

                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < timeFrames.length - 1
                                    ? (isVerySmall ? 6 : 8)
                                    : 0,
                              ),
                              child: Container(
                                width: isVerySmall
                                    ? 100
                                    : isSmall
                                    ? 110
                                    : isMedium
                                    ? 120
                                    : 130,
                                child: _buildTimeFrameCard(
                                  context,
                                  icon: frame['icon'] as IconData,
                                  label: frame['label'] as String,
                                  duration: frame['duration'] as String,
                                  color: frame['color'] as Color,
                                  isSelected: isSelected,
                                  onTap: () {
                                    setState(() {
                                      _selectedTimeFrame =
                                          frame['frame'] as String;
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      if (_selectedTimeFrame == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Harap pilih rentang waktu',
                            style: TextStyle(
                              fontSize: _fontSize(context, base: 11),
                              color: Colors.red.shade600,
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Action Buttons - lebih responsif
                      _buildActionButtons(context),
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

  Widget _buildSectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: _responsiveSize(context, small: 28, medium: 32, large: 36),
          height: _responsiveSize(context, small: 28, medium: 32, large: 36),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: _responsiveSize(context, small: 14, medium: 16, large: 18),
            color: Colors.blue.shade600,
          ),
        ),
        SizedBox(
          width: _responsiveSize(context, small: 8, medium: 10, large: 12),
        ),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: _fontSize(context, base: 14),
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyTypeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required bool isSelected,
    required int crossAxisCount,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? color : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(
            _responsiveSize(context, small: 8, medium: 12, large: 16),
          ),
          child: crossAxisCount == 1
              ?
                // Layout horizontal untuk grid 1 kolom
                Row(
                  children: [
                    Container(
                      width: _responsiveSize(
                        context,
                        small: 32,
                        medium: 36,
                        large: 40,
                      ),
                      height: _responsiveSize(
                        context,
                        small: 32,
                        medium: 36,
                        large: 40,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(isSelected ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: _responsiveSize(
                          context,
                          small: 16,
                          medium: 18,
                          large: 20,
                        ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: _fontSize(context, base: 14),
                              fontWeight: FontWeight.w600,
                              color: isSelected ? color : Colors.grey.shade800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: _fontSize(context, base: 11),
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              :
                // Layout vertikal untuk grid 2+ kolom
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: _responsiveSize(
                        context,
                        small: 32,
                        medium: 36,
                        large: 40,
                      ),
                      height: _responsiveSize(
                        context,
                        small: 32,
                        medium: 36,
                        large: 40,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(isSelected ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: _responsiveSize(
                          context,
                          small: 16,
                          medium: 18,
                          large: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _responsiveSize(
                        context,
                        small: 6,
                        medium: 8,
                        large: 10,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: _fontSize(context, base: 12),
                        fontWeight: FontWeight.w600,
                        color: isSelected ? color : Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: _responsiveSize(
                        context,
                        small: 2,
                        medium: 4,
                        large: 6,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: _fontSize(context, base: 10),
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTimeFrameCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String duration,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? color : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(
            _responsiveSize(context, small: 8, medium: 12, large: 16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: _responsiveSize(
                      context,
                      small: 18,
                      medium: 20,
                      large: 22,
                    ),
                    height: _responsiveSize(
                      context,
                      small: 18,
                      medium: 20,
                      large: 22,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(isSelected ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      icon,
                      size: _responsiveSize(
                        context,
                        small: 9,
                        medium: 10,
                        large: 11,
                      ),
                      color: color,
                    ),
                  ),
                  SizedBox(
                    width: _responsiveSize(
                      context,
                      small: 4,
                      medium: 6,
                      large: 8,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: _fontSize(context, base: 11),
                        fontWeight: FontWeight.w600,
                        color: isSelected ? color : Colors.grey.shade800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _responsiveSize(context, small: 4, medium: 6, large: 8),
              ),
              Text(
                duration,
                style: TextStyle(
                  fontSize: _fontSize(context, base: 10),
                  color: Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmall = screenWidth < 360;
    final isSmall = screenWidth < 400;

    final buttonHeight = isVerySmall
        ? 42.0
        : isSmall
        ? 46.0
        : 48.0;
    final fontSize = _fontSize(context, base: 14);
    final horizontalPadding = isVerySmall
        ? 12.0
        : isSmall
        ? 14.0
        : 16.0;
    final buttonSpacing = isVerySmall ? 8.0 : 10.0;

    return screenWidth < 380
        ?
          // Vertical layout untuk layar sangat kecil
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: buttonSpacing),
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_outlined, size: fontSize + 2),
                      SizedBox(width: isVerySmall ? 6 : 8),
                      Flexible(
                        child: Text(
                          'Jalankan Simulasi',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        :
          // Horizontal layout untuk layar yang lebih besar
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: buttonHeight,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: buttonSpacing),
              Expanded(
                child: SizedBox(
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_outlined, size: fontSize + 2),
                        SizedBox(width: isVerySmall ? 6 : 8),
                        Flexible(
                          child: Text(
                            'Jalankan Simulasi',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  @override
  void dispose() {
    _percentageController.dispose();
    _targetController.dispose();
    super.dispose();
  }
}
