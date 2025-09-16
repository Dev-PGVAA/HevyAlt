import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/text_filed/universal_text_field.dart';
import 'auth_type.dart';

class LoginView extends StatefulWidget {
  final ValueChanged<AuthType> onTypeChange;

  const LoginView({super.key, required this.onTypeChange});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final bool _isShowPasswordErrors = false;
  String? _passwordErrorMessage;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _emailController.addListener(_onFieldsChanged);
  }

  void _validatePassword() {
    if (_passwordController.text.isNotEmpty) {
      setState(() {
        if (_passwordController.text.length < 6) {
          _passwordErrorMessage = "Password must be at least 6 characters";
        } else {
          _passwordErrorMessage = null;
        }
      });
    } else {
      setState(() {
        _passwordErrorMessage = null;
      });
    }
  }

  void _onFieldsChanged() {
    // Форсируем пересборку, чтобы активировать/деактивировать кнопку
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _emailController.removeListener(_onFieldsChanged);
    _passwordController.removeListener(_validatePassword);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UniversalTextField(controller: _emailController, placeholder: "E-mail"),
        const SizedBox(height: 12),
        UniversalTextField(
          controller: _passwordController,
          placeholder: "Password",
          isSecure: true,
          isShowPasswordErrors: _isShowPasswordErrors,
          errorMessage: _passwordErrorMessage,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed:
              _isLoading ||
                  _emailController.text.isEmpty ||
                  _passwordController.text.isEmpty
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  final ok = await context.read<AuthProvider>().login(
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                  );
                  setState(() => _isLoading = false);
                  if (!ok && mounted) {
                    final msg =
                        context.read<AuthProvider>().lastError ??
                        'Login failed';
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            disabledBackgroundColor: Colors.white.withValues(alpha: 0.8),
            disabledForegroundColor: Colors.black.withValues(alpha: 0.8),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.black)
              : const Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Divider(color: Colors.white.withValues(alpha: 0.5)),
            ),
            TextButton(
              onPressed: () => widget.onTypeChange(AuthType.main),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, size: 12, color: Color(0x7FFEFEFE)),
                  SizedBox(width: 4),
                  Text(
                    "Go Back",
                    style: TextStyle(color: Color(0x7FFEFEFE), fontSize: 15),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Divider(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ],
    );
  }
}
