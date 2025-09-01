import 'package:flutter/material.dart';

import '../../widgets/text_filed/password_validator.dart';
import '../../widgets/text_filed/universal_text_field.dart';
import 'auth_type.dart';

class RegisterView extends StatefulWidget {
  final ValueChanged<AuthType> onTypeChange;

  const RegisterView({super.key, required this.onTypeChange});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isFormValid = false;
  bool _isShowPasswordErrors = false;
  String? _passwordErrorMessage;

  late PasswordValidator _passwordValidator;

  @override
  void initState() {
    super.initState();
    _passwordValidator = PasswordValidator();

    // Add listeners to validate form
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validatePassword);
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordValidator.isValid;
    });
  }

  void _validatePassword() {
    _passwordValidator.updatePassword(_passwordController.text);

    if (_passwordController.text.isNotEmpty) {
      setState(() {
        _isShowPasswordErrors = true;
        if (!_passwordValidator.isValid) {
          // Get the first failed requirement for error message
          final failedRequirement = _passwordValidator.requirements.firstWhere(
            (req) => !req.isValid,
            orElse: () => _passwordValidator.requirements.first,
          );
          _passwordErrorMessage =
              "Password must contain ${failedRequirement.name}";
        } else {
          _passwordErrorMessage = null;
        }
      });
    } else {
      setState(() {
        _isShowPasswordErrors = false;
        _passwordErrorMessage = null;
      });
    }

    _validateForm();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    setState(() => _isLoading = true);

    // TODO: вызов AuthService.register(...)
    await Future.delayed(const Duration(seconds: 1)); // заглушка

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: UniversalTextField(
                controller: _firstNameController,
                placeholder: "First name",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: UniversalTextField(
                controller: _lastNameController,
                placeholder: "Last name",
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
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
          onPressed: _isFormValid && !_isLoading ? _register : null,
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
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Register",
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
