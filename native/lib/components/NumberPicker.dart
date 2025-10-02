import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberPicker extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double step;
  final double initialValue;
  final ValueChanged<double>? onChanged;
  final String unit;

  const NumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    this.step = 1,
    this.initialValue = 0,
    this.onChanged,
    this.unit = '',
  });

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late TextEditingController _controller;
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(
      text: _formatValueForDisplay(widget.initialValue),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValueForDisplay(double value) {
    return "${value.toStringAsFixed(widget.step < 1 ? 1 : 0)}";
  }

  void _onChanged(String value) {
    final parsedValue = double.tryParse(value);
    if (parsedValue != null) {
      final clampedValue = parsedValue.clamp(widget.minValue, widget.maxValue);

      if (clampedValue != _currentValue) {
        setState(() {
          _currentValue = clampedValue;
        });

        // Вибрация при изменении значения
        HapticFeedback.selectionClick();

        widget.onChanged?.call(clampedValue);
      }
    }
  }

  void _onSubmitted(String value) {
    final parsedValue = double.tryParse(value);
    if (parsedValue != null) {
      final clampedValue = parsedValue.clamp(widget.minValue, widget.maxValue);

      setState(() {
        _currentValue = clampedValue;
        _controller.text = _formatValueForDisplay(clampedValue);
      });

      widget.onChanged?.call(clampedValue);
    } else {
      // Если ввод неверный, возвращаем к предыдущему значению
      _controller.text = _formatValueForDisplay(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        onSubmitted: _onSubmitted,
        keyboardType: TextInputType.numberWithOptions(decimal: widget.step < 1),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: "175",
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
