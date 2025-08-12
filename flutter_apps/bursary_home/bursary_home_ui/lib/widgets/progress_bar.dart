import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/theme_colors.dart';

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: 4.0, // 4px
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress / 100.0,
              child: Container(
                height: 4.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).extension<ThemeColors>()!.primaryColor,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
