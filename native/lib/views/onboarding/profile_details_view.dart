import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/health_service.dart';
import '../../widgets/health_permission_widget.dart';

// Function to show the non-dismissible bottom sheet
void showProfileDetailsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: false, // Prevent dismissal by tapping outside
    enableDrag: false, // Prevent dismissal by dragging
    isScrollControlled: true, // Allow full-screen content
    backgroundColor: Colors.transparent,
    builder: (context) => const ProfileDetailsView(),
  );
}

class ProfileDetailsView extends StatefulWidget {
  const ProfileDetailsView({super.key});

  @override
  State<ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<ProfileDetailsView> {
  double _heightCm = 175;
  double _weightKg = 70;
  String _heightUnit = 'cm';
  String _weightUnit = 'kg';
  int _currentStep = 0;
  bool _isSaving = false;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(
      text: _heightUnit == 'cm'
          ? _heightCm.toStringAsFixed(0)
          : _cmToIn(_heightCm).toStringAsFixed(1),
    );
    _weightController = TextEditingController(
      text: _weightUnit == 'kg'
          ? _weightKg.toStringAsFixed(1)
          : _kgToLb(_weightKg).toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Conversions
  double _kgToLb(double kg) => kg * 2.2046226218;
  double _lbToKg(double lb) => lb / 2.2046226218;
  double _cmToIn(double cm) => cm / 2.54;
  double _inToCm(double inch) => inch * 2.54;

  String _formatHeight() {
    if (_heightUnit == 'cm') {
      return _heightCm.toStringAsFixed(0);
    }
    return _cmToIn(_heightCm).toStringAsFixed(1);
  }

  String _formatWeight() {
    if (_weightUnit == 'kg') {
      return _weightKg.toStringAsFixed(1);
    }
    return _kgToLb(_weightKg).toStringAsFixed(1);
  }

  bool get _canProceed {
    if (_currentStep == 0) return _heightCm >= 120 && _heightCm <= 220;
    if (_currentStep == 1) return _weightKg >= 40 && _weightKg <= 200;
    if (_currentStep == 2) return true; // Health permission step
    return false;
  }

  void _next() {
    if (!_canProceed) return;
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    } else {
      _save();
    }
  }

  void _back() {
    if (_currentStep == 0) return;
    setState(() => _currentStep -= 1);
  }

  void _onHealthDataReceived(HealthData healthData) {
    setState(() {
      if (healthData.height != null) {
        _heightCm = healthData.height!;
        _heightController.text = _formatHeight();
      }
      if (healthData.weight != null) {
        _weightKg = healthData.weight!;
        _weightController.text = _formatWeight();
      }
      // Автоматически переходим к следующему шагу
      _currentStep = 0;
    });
  }

  void _onHealthSkip() {
    setState(() {
      _currentStep += 1;
    });
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    context.read<AuthProvider>().markProfileCompleted();
    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Параметры для тренировок',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _stepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ваш рост', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _heightController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter height',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) return; // Ignore empty input
                        final double? newValue = double.tryParse(value);
                        if (newValue != null) {
                          setState(() {
                            _heightCm = _heightUnit == 'cm'
                                ? newValue
                                : _inToCm(newValue);
                          });
                        }
                      },
                      onEditingComplete: () {
                        setState(() {
                          _heightController.text = _formatHeight();
                          _heightController
                              .selection = TextSelection.fromPosition(
                            TextPosition(offset: _heightController.text.length),
                          );
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ToggleButtons(
                  isSelected: [_heightUnit == 'cm', _heightUnit == 'ft'],
                  onPressed: (i) {
                    setState(() {
                      final newUnit = i == 0 ? 'cm' : 'ft';
                      if (newUnit != _heightUnit) {
                        _heightUnit = newUnit;
                        _heightController.text = _formatHeight();
                        _heightController
                            .selection = TextSelection.fromPosition(
                          TextPosition(offset: _heightController.text.length),
                        );
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  constraints: const BoxConstraints(
                    minWidth: 56,
                    minHeight: 40,
                  ),
                  selectedColor: Colors.black,
                  fillColor: Colors.white,
                  color: Colors.white70,
                  children: const [Text('cm'), Text('ft')],
                ),
              ],
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ваш вес', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _weightController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter weight',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) return; // Ignore empty input
                        final double? newValue = double.tryParse(value);
                        if (newValue != null) {
                          setState(() {
                            _weightKg = _weightUnit == 'kg'
                                ? newValue
                                : _lbToKg(newValue);
                          });
                        }
                      },
                      onEditingComplete: () {
                        setState(() {
                          _weightController.text = _formatWeight();
                          _weightController
                              .selection = TextSelection.fromPosition(
                            TextPosition(offset: _weightController.text.length),
                          );
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ToggleButtons(
                  isSelected: [_weightUnit == 'kg', _weightUnit == 'lb'],
                  onPressed: (i) {
                    setState(() {
                      final newUnit = i == 0 ? 'kg' : 'lb';
                      if (newUnit != _weightUnit) {
                        _weightUnit = newUnit;
                        _weightController.text = _formatWeight();
                        _weightController
                            .selection = TextSelection.fromPosition(
                          TextPosition(offset: _weightController.text.length),
                        );
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  constraints: const BoxConstraints(
                    minWidth: 56,
                    minHeight: 40,
                  ),
                  selectedColor: Colors.black,
                  fillColor: Colors.white,
                  color: Colors.white70,
                  children: const [Text('kg'), Text('lb')],
                ),
              ],
            ),
          ],
        );

      case 2:
        return HealthPermissionWidget(
          onDataReceived: _onHealthDataReceived,
          onSkip: _onHealthSkip,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _controls() {
    // Скрываем кнопки на шаге Health permissions
    if (_currentStep == 2) {
      return const SizedBox.shrink();
    }

    final isLast = _currentStep == 1;
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _isSaving ? null : _back,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Назад'),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: (!_canProceed || _isSaving) ? null : _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : Text(
                      isLast ? 'Далее' : 'Далее',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFF101010),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            Row(
              children: List.generate(3, (i) {
                final active = i <= _currentStep;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: i == 2 ? 0 : 6),
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            _stepContent(),
            const Spacer(),
            _controls(),
          ],
        ),
      ),
    );
  }
}
