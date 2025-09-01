import 'package:flutter/material.dart';

class ValidationRequirement {
  final String name;
  final bool Function(String) validator;
  bool isValid;

  ValidationRequirement({
    required this.name,
    required this.validator,
    this.isValid = false,
  });
}

class PasswordValidator extends ChangeNotifier {
  String password = "";
  bool isPasswordVisible = false;
  late List<ValidationRequirement> requirements;
  bool isValid = false;

  PasswordValidator({List<ValidationRequirement>? customRequirements}) {
    requirements = customRequirements ?? defaultRequirements;
  }

  void updatePassword(String newPassword) {
    password = newPassword;
    _validatePassword(newPassword);
    notifyListeners();
  }

  void toggleVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void _validatePassword(String password) {
    for (var i = 0; i < requirements.length; i++) {
      requirements[i].isValid = requirements[i].validator(password);
      if (!requirements[i].isValid) {
        for (var j = i + 1; j < requirements.length; j++) {
          requirements[j].isValid = false;
        }
        break;
      }
    }
    isValid = requirements.every((r) => r.isValid);
  }

  static List<ValidationRequirement> defaultRequirements = [
    ValidationRequirement(
      name: "8 characters",
      validator: (p) => p.length >= 8,
    ),
    ValidationRequirement(
      name: "Number",
      validator: (p) => p.contains(RegExp(r'[0-9]')),
    ),
    ValidationRequirement(
      name: "Special character",
      validator: (p) => p.contains(RegExp(r'[!@#\$%^&*()_\-+=<>?/]')),
    ),
  ];
}
