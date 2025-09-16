import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class ProfileDetailsView extends StatefulWidget {
  const ProfileDetailsView({super.key});

  @override
  State<ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<ProfileDetailsView> {
  // Храним значения в метрике
  double _heightCm = 175;
  double _weightKg = 70;
  String _heightUnit = 'cm'; // cm | ft
  String _weightUnit = 'kg'; // kg | lb

  String? _goal; // похудение | набор | поддержание
  int _currentStep = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Можно подтянуть дефолтные значения из профиля при наличии
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool get _canProceed {
    if (_currentStep == 0) {
      return _heightCm >= 120 && _heightCm <= 220;
    }
    if (_currentStep == 1) {
      return _weightKg >= 40 && _weightKg <= 200;
    }
    if (_currentStep == 2) {
      return _goal != null && _goal!.isNotEmpty;
    }
    return false;
  }

  // Конвертации
  double _kgToLb(double kg) => kg * 2.2046226218;
  double _lbToKg(double lb) => lb / 2.2046226218;
  double _cmToIn(double cm) => cm / 2.54;
  double _inToCm(double inch) => inch * 2.54;

  String _formatHeight() {
    if (_heightUnit == 'cm') {
      return '${_heightCm.toStringAsFixed(0)} cm';
    }
    final totalIn = _cmToIn(_heightCm);
    final feet = totalIn ~/ 12;
    final inches = (totalIn - feet * 12).round();
    return "${feet}' ${inches}\"";
  }

  String _formatWeight() {
    if (_weightUnit == 'kg') {
      return '${_weightKg.toStringAsFixed(1)} kg';
    }
    return '${_kgToLb(_weightKg).toStringAsFixed(1)} lb';
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

  Future<void> _save() async {
    setState(() => _isSaving = true);
    // TODO: вызвать API обновления профиля с ростом/весом/целью
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    context.read<AuthProvider>().markProfileCompleted();
    setState(() => _isSaving = false);
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

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
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
                    child: Text(
                      _formatHeight(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ToggleButtons(
                  isSelected: [_heightUnit == 'cm', _heightUnit == 'ft'],
                  onPressed: (i) {
                    setState(() {
                      _heightUnit = i == 0 ? 'cm' : 'ft';
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
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                const int minCm = 120;
                const int maxCm = 220;
                final bool isFt = _heightUnit == 'ft';
                if (!isFt) {
                  // Колесо для сантиметров (целые значения)
                  final List<int> values = List.generate(
                    maxCm - minCm + 1,
                    (i) => minCm + i,
                  );
                  final int initialIndex = (_heightCm.round() - minCm).clamp(
                    0,
                    values.length - 1,
                  );
                  final controller = FixedExtentScrollController(
                    initialItem: initialIndex,
                  );
                  return SizedBox(
                    height: 180,
                    child: ListWheelScrollView.useDelegate(
                      controller: controller,
                      itemExtent: 42,
                      physics: const FixedExtentScrollPhysics(),
                      perspective: 0.0025,
                      diameterRatio: 2.0,
                      useMagnifier: true,
                      magnification: 1.15,
                      onSelectedItemChanged: (i) {
                        setState(() {
                          _heightCm = values[i].toDouble();
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0 || index >= values.length) return null;
                          final v = values[index];
                          return Center(
                            child: Text(
                              '$v cm',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  // Колесо для футов/дюймов (храним см, крутим дюймы)
                  final int minIn = _cmToIn(minCm.toDouble()).round();
                  final int maxIn = _cmToIn(maxCm.toDouble()).round();
                  final List<int> inches = List.generate(
                    maxIn - minIn + 1,
                    (i) => minIn + i,
                  );
                  final int initialIndex = (_cmToIn(_heightCm).round() - minIn)
                      .clamp(0, inches.length - 1);
                  final controller = FixedExtentScrollController(
                    initialItem: initialIndex,
                  );
                  String fmt(int totalIn) {
                    final feet = totalIn ~/ 12;
                    final inch = totalIn - feet * 12;
                    return "${feet}' ${inch}\"";
                  }

                  return SizedBox(
                    height: 180,
                    child: ListWheelScrollView.useDelegate(
                      controller: controller,
                      itemExtent: 42,
                      physics: const FixedExtentScrollPhysics(),
                      perspective: 0.0025,
                      diameterRatio: 2.0,
                      useMagnifier: true,
                      magnification: 1.15,
                      onSelectedItemChanged: (i) {
                        setState(() {
                          _heightCm = _inToCm(inches[i].toDouble());
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0 || index >= inches.length) return null;
                          final v = inches[index];
                          return Center(
                            child: Text(
                              fmt(v),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
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
                    child: Text(
                      _formatWeight(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ToggleButtons(
                  isSelected: [_weightUnit == 'kg', _weightUnit == 'lb'],
                  onPressed: (i) {
                    setState(() {
                      _weightUnit = i == 0 ? 'kg' : 'lb';
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
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final bool isLb = _weightUnit == 'lb';
                if (!isLb) {
                  // Колесо для кг с шагом 0.5
                  const double minKg = 40;
                  const double maxKg = 200;
                  final int count = (((maxKg - minKg) / 0.5).round()) + 1;
                  final List<double> values = List.generate(
                    count,
                    (i) => (minKg + i * 0.5),
                  );
                  final int initialIndex = (((_weightKg - minKg) / 0.5).round())
                      .clamp(0, values.length - 1);
                  final controller = FixedExtentScrollController(
                    initialItem: initialIndex,
                  );
                  return SizedBox(
                    height: 180,
                    child: ListWheelScrollView.useDelegate(
                      controller: controller,
                      itemExtent: 42,
                      physics: const FixedExtentScrollPhysics(),
                      perspective: 0.0025,
                      diameterRatio: 2.0,
                      useMagnifier: true,
                      magnification: 1.15,
                      onSelectedItemChanged: (i) {
                        setState(() {
                          _weightKg = values[i];
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0 || index >= values.length) return null;
                          final v = values[index];
                          return Center(
                            child: Text(
                              '${v.toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  // Колесо для фунтов, шаг 1 lb
                  final int minLb = _kgToLb(40).round();
                  final int maxLb = _kgToLb(200).round();
                  final List<int> values = List.generate(
                    maxLb - minLb + 1,
                    (i) => minLb + i,
                  );
                  final int initialIndex = (_kgToLb(_weightKg).round() - minLb)
                      .clamp(0, values.length - 1);
                  final controller = FixedExtentScrollController(
                    initialItem: initialIndex,
                  );
                  return SizedBox(
                    height: 180,
                    child: ListWheelScrollView.useDelegate(
                      controller: controller,
                      itemExtent: 42,
                      physics: const FixedExtentScrollPhysics(),
                      perspective: 0.0025,
                      diameterRatio: 2.0,
                      useMagnifier: true,
                      magnification: 1.15,
                      onSelectedItemChanged: (i) {
                        setState(() {
                          _weightKg = _lbToKg(values[i].toDouble());
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0 || index >= values.length) return null;
                          final v = values[index];
                          return Center(
                            child: Text(
                              '$v lb',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Цель тренировок',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _goal,
              dropdownColor: const Color(0xFF1A1A1A),
              items: const [
                DropdownMenuItem(
                  value: 'lose',
                  child: Text(
                    'Похудение',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem(
                  value: 'gain',
                  child: Text(
                    'Набор массы',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem(
                  value: 'maintain',
                  child: Text(
                    'Поддержание',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              onChanged: (v) => setState(() => _goal = v),
              decoration: _fieldDecoration('Выберите цель'),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _controls() {
    final isLast = _currentStep == 2;
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
                      isLast ? 'Сохранить' : 'Далее',
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
