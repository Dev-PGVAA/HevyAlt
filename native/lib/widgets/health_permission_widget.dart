import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/health_service.dart';

class HealthPermissionWidget extends StatefulWidget {
  final Function(HealthData) onDataReceived;
  final VoidCallback onSkip;

  const HealthPermissionWidget({
    super.key,
    required this.onDataReceived,
    required this.onSkip,
  });

  @override
  State<HealthPermissionWidget> createState() => _HealthPermissionWidgetState();
}

class _HealthPermissionWidgetState extends State<HealthPermissionWidget> {
  final HealthService _healthService = HealthService();
  bool _isLoading = false;
  bool _isCheckingAvailability = true;
  bool _isHealthAvailable = false;
  String _statusMessage = 'Проверка доступности...';

  @override
  void initState() {
    super.initState();
    _checkHealthAvailability();
  }

  Future<void> _checkHealthAvailability() async {
    setState(() {
      _isCheckingAvailability = true;
      _statusMessage = 'Проверка доступности...';
    });

    try {
      final isAvailable = await _healthService.isHealthDataAvailable();
      setState(() {
        _isHealthAvailable = isAvailable;
        _isCheckingAvailability = false;
        if (isAvailable) {
          _statusMessage = 'HealthKit/Health Connect доступен';
        } else {
          _statusMessage =
              'HealthKit/Health Connect недоступен на этом устройстве';
        }
      });
    } catch (e) {
      setState(() {
        _isHealthAvailable = false;
        _isCheckingAvailability = false;
        _statusMessage = 'Ошибка при проверке доступности';
      });
    }
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Запрос разрешений...';
    });

    try {
      print('Запрашиваем разрешения Health...');
      final hasPermission = await _healthService.requestPermissions();
      print('Результат запроса разрешений: $hasPermission');

      if (hasPermission) {
        setState(() {
          _statusMessage = 'Получение данных...';
        });

        print('Получаем данные Health...');
        final healthData = await _healthService.getHealthData();
        print(
          'Получены данные: height=${healthData.height}, weight=${healthData.weight}',
        );

        if (healthData.hasData) {
          setState(() {
            _statusMessage = 'Данные успешно получены!';
          });
          // Небольшая задержка для показа успешного сообщения
          await Future.delayed(const Duration(milliseconds: 500));
          widget.onDataReceived(healthData);
        } else {
          setState(() {
            _statusMessage =
                'Данные не найдены в HealthKit/Health Connect. Проверьте, что у вас есть записи о росте и весе.';
          });
        }
      } else {
        setState(() {
          _statusMessage =
              'Разрешения не предоставлены. Вы можете предоставить их позже в настройках приложения.';
        });
      }
    } catch (e) {
      print('Ошибка при работе с Health: $e');
      setState(() {
        _statusMessage = 'Ошибка при запросе разрешений: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildContent() {
    if (_isCheckingAvailability) {
      return _buildLoadingState();
    }

    if (!_isHealthAvailable) {
      return _buildUnavailableState();
    }

    return _buildPermissionRequestState();
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _statusMessage,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUnavailableState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.health_and_safety_outlined,
            size: 48,
            color: Colors.white38,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'HealthKit/Health Connect недоступен',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'На этом устройстве нет поддержки HealthKit или Health Connect',
          style: TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: widget.onSkip,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Продолжить без синхронизации',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionRequestState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2D5A27), Color(0xFF1A3D1A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.health_and_safety,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Синхронизация с HealthKit/Health Connect',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'Мы можем автоматически заполнить ваш рост и вес из данных HealthKit или Health Connect',
          style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        if (_statusMessage.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  Icon(_getStatusIcon(), size: 20, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _statusMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        _buildActionButtons(),
      ],
    );
  }

  Color _getStatusColor() {
    if (_isLoading) return const Color(0xFF1A3D1A);
    if (_statusMessage.contains('ошибка') ||
        _statusMessage.contains('Ошибка')) {
      return const Color(0xFF4A1A1A);
    }
    if (_statusMessage.contains('не предоставлены') ||
        _statusMessage.contains('не найдены')) {
      return const Color(0xFF4A3A1A);
    }
    return const Color(0xFF1A3D1A);
  }

  IconData _getStatusIcon() {
    if (_statusMessage.contains('ошибка') ||
        _statusMessage.contains('Ошибка')) {
      return Icons.error_outline;
    }
    if (_statusMessage.contains('не предоставлены') ||
        _statusMessage.contains('не найдены')) {
      return Icons.warning_outlined;
    }
    return Icons.info_outline;
  }

  Widget _buildActionButtons() {
    // Если разрешения не предоставлены, показываем кнопку настроек
    if (_statusMessage.contains('не предоставлены') && !_isLoading) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: widget.onSkip,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24, width: 1.5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Пропустить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _openAppSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D5A27),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.settings, size: 18),
                    label: const Text(
                      'Настройки',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Обычные кнопки для других состояний
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: _isLoading ? null : widget.onSkip,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24, width: 1.5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Пропустить',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _requestPermissions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      'Разрешить',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      print('Ошибка при открытии настроек: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
}
