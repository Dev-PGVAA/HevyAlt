import 'dart:io';

import 'package:health/health.dart';

class HealthData {
  final double? height;
  final double? weight;
  final DateTime? lastUpdated;

  const HealthData({this.height, this.weight, this.lastUpdated});

  bool get hasData => height != null || weight != null;
}

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  Health? _health;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _health = Health();
    _isInitialized = true;
  }

  /// Проверяет доступность HealthKit/Health Connect на устройстве
  Future<bool> isHealthDataAvailable() async {
    await initialize();
    try {
      // Простая проверка доступности через создание экземпляра Health
      return Platform.isIOS || Platform.isAndroid;
    } catch (e) {
      print('Health data not available: $e');
      return false;
    }
  }

  /// Запрашивает разрешения для чтения данных о росте и весе
  Future<bool> requestPermissions() async {
    await initialize();

    if (!await isHealthDataAvailable()) {
      return false;
    }

    // Определяем типы данных для запроса
    final types = [HealthDataType.HEIGHT, HealthDataType.WEIGHT];

    try {
      // Сначала проверяем, есть ли уже разрешения
      final hasPermissions = await _health!.hasPermissions(
        types,
        permissions: [HealthDataAccess.READ],
      );

      if (hasPermissions == true) {
        return true;
      }

      // Запрашиваем разрешения
      final permissions = await _health!.requestAuthorization(
        types,
        permissions: [HealthDataAccess.READ],
      );

      return permissions;
    } catch (e) {
      print('Ошибка при запросе разрешений Health: $e');
      return false;
    }
  }

  /// Проверяет статус разрешений
  Future<bool> hasPermissions() async {
    await initialize();

    if (!await isHealthDataAvailable()) {
      return false;
    }

    final types = [HealthDataType.HEIGHT, HealthDataType.WEIGHT];

    try {
      final permissions = await _health!.hasPermissions(
        types,
        permissions: [HealthDataAccess.READ],
      );

      return permissions ?? false;
    } catch (e) {
      print('Ошибка при проверке разрешений Health: $e');
      return false;
    }
  }

  /// Получает данные о росте и весе из HealthKit/Health Connect
  Future<HealthData> getHealthData() async {
    await initialize();

    if (!await hasPermissions()) {
      return const HealthData();
    }

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    try {
      // Получаем данные о росте
      final heightData = await _health!.getHealthDataFromTypes(
        types: [HealthDataType.HEIGHT],
        startTime: yesterday,
        endTime: now,
      );

      // Получаем данные о весе
      final weightData = await _health!.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: yesterday,
        endTime: now,
      );

      double? height;
      double? weight;
      DateTime? lastUpdated;

      // Обрабатываем данные о росте
      if (heightData.isNotEmpty) {
        final latestHeight = heightData.last;
        if (latestHeight.value is NumericHealthValue) {
          final value = latestHeight.value as NumericHealthValue;
          height = value.numericValue.toDouble();
          lastUpdated = latestHeight.dateFrom;
        }
      }

      // Обрабатываем данные о весе
      if (weightData.isNotEmpty) {
        final latestWeight = weightData.last;
        if (latestWeight.value is NumericHealthValue) {
          final value = latestWeight.value as NumericHealthValue;
          weight = value.numericValue.toDouble();
          if (lastUpdated == null ||
              latestWeight.dateFrom.isAfter(lastUpdated)) {
            lastUpdated = latestWeight.dateFrom;
          }
        }
      }

      return HealthData(
        height: height,
        weight: weight,
        lastUpdated: lastUpdated,
      );
    } catch (e) {
      print('Ошибка при получении данных Health: $e');
      return const HealthData();
    }
  }

  /// Проверяет, поддерживается ли платформа
  bool get isPlatformSupported {
    return Platform.isIOS || Platform.isAndroid;
  }
}
