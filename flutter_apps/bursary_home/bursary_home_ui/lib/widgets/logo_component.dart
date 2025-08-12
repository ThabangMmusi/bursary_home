import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bursary_home_ui/theme/styles.dart';
import 'package:bursary_home_ui/theme/theme_colors.dart';

enum LogoDirection {
  horizontal,
  vertical,
}

class LogoComponent extends StatelessWidget {
  final LogoDirection direction;
  final double imageSize;
  final double fontSize;
  final bool showText;

  const LogoComponent({
    super.key,
    this.direction = LogoDirection.horizontal,
    this.imageSize = 70.0,
    this.fontSize = 1.2,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget logoImage = SvgPicture.asset(
      'assets/images/Bursary_Logo.svg',
      width: imageSize,
      height: imageSize,
    );

    Widget logoText = Text(
      'Bursary Home',
      style: TextStyles.titleLarge.copyWith(
        color: Theme.of(context).extension<ThemeColors>()!.primaryColor,
        fontSize: fontSize * 16.0, // Convert rem to pixels
      ),
    );

    if (direction == LogoDirection.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoImage,
          SizedBox(width: 16.0), // Equivalent to 1rem
          if (showText) logoText,
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoImage,
          SizedBox(height: 8.0), // Equivalent to 0.5rem
          if (showText) logoText,
        ],
      );
    }
  }
}
