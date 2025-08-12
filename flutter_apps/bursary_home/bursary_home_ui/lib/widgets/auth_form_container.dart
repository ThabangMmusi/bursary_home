import 'package:flutter/material.dart';

class AuthFormContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry padding;

  const AuthFormContainer({
    super.key,
    required this.child,
    this.width,
    this.padding = const EdgeInsets.all(32.0), // Equivalent to 2rem
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 4), // 0 4px 6px rgba(0, 0, 0, 0.1)
          ),
        ],
      ),
      child: child,
    );
  }
}