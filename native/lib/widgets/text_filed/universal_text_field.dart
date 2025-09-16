import 'package:flutter/material.dart';

class UniversalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isSecure;
  final bool isShowPasswordErrors;
  final String? errorMessage;

  const UniversalTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.isSecure = false,
    this.isShowPasswordErrors = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isSecure) {
      return TextFieldComponent(
        controller: controller,
        placeholder: placeholder,
        isSecure: true,
        errorMessage: errorMessage,
        isShowPasswordErrors: isShowPasswordErrors,
      );
    } else {
      return TextFieldComponent(
        controller: controller,
        placeholder: placeholder,
        isSecure: false,
        errorMessage: errorMessage,
      );
    }
  }
}

class TextFieldComponent extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isSecure;
  final String? errorMessage;
  final bool isShowPasswordErrors;

  const TextFieldComponent({
    super.key,
    required this.controller,
    required this.placeholder,
    this.isSecure = false,
    this.errorMessage,
    this.isShowPasswordErrors = false,
  });

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent>
    with SingleTickerProviderStateMixin {
  bool isTextVisible = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF181818),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    TextField(
                      controller: widget.controller,
                      obscureText: widget.isSecure && !isTextVisible,
                      style: const TextStyle(color: Colors.white),
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: widget.placeholder,
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isSecure)
                IconButton(
                  onPressed: () {
                    setState(() {
                      isTextVisible = !isTextVisible;
                    });
                  },
                  icon: Icon(
                    isTextVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                    size: 18,
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                ),
            ],
          ),
        ),
        if (widget.errorMessage != null &&
            widget.errorMessage!.isNotEmpty &&
            widget.isShowPasswordErrors)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              if (widget.errorMessage!.isNotEmpty) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
              return SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    widget.errorMessage!,
                    style: const TextStyle(color: Color(0xFFDC2626)),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
