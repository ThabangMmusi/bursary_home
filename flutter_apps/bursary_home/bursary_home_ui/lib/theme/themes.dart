import 'package:bursary_home_ui/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';

class AppTheme {
  // --- Core Palette ---
  // Primary Accent Colors
  static const Color primaryAccent = AppColors.primaryColor; // Was accent1
  static const Color secondaryAccent = AppColors.backgroundColor2;

  // Neutral Surface Colors
  static const Color surfaceLight = AppColors.white; // Was surface1
  static const Color backgroundLight = AppColors.backgroundColor; // Was bg1
  static const Color surfaceDark = Color(0xff1E1E1E); // Example dark surface
  static const Color backgroundDark = Color(
    0xff121212,
  ); // Example dark background

  // Grey Scale
  static const Color greyLight = Color(
    0xffE0E0E0,
  ); // Lighter grey (was greyWeak with a slightly different value)
  static const Color greyMedium = Color(
    0xff9E9E9E,
  ); // Mid grey (was greyMedium/onInverseSurface)
  static const Color greyDark = Color(
    0xff424242,
  ); // Darker grey (was greyStrong/inversePrimary)
  static const Color greyVeryDark = Color(
    0xff212121,
  ); // Even darker for text or dark elements

  // Semantic Colors
  static const Color errorColor = AppColors.errorColor;
  static const Color onErrorColor = Colors.white;
  static const Color successColor = AppColors.successColor; // Your successColor
  static Color successColorDark = const Color(0xFF206F54);
  static const Color onSuccessColor = Colors.white;
  static const Color warningColor = Color(0xFFFFAB00); // Amber for warnings
  static const Color onWarningColor = Colors.black;
  static Color infoColor = const Color.fromARGB(
    255,
    126,
    197,
    255,
  ); // Changed to blue for distinct info messages
  static Color infoColorDark = const Color(
    0xFF2196F3,
  ); // Darker shade of blue for dark theme

  // Text Colors
  static const Color textPrimaryLight = AppColors.textDark;
  static const Color textSecondaryLight = Color(
    0xff535353,
  ); // Lighter dark text (was grey)
  static const Color textPrimaryDark = Color(
    0xffE0E0E0,
  ); // Light text on dark bg
  static const Color textSecondaryDark = Color(0xffBDBDBD); // Darker light text

  // Example additional brand colors (if needed)
  // static Color successColor = const Color(0xFF2C8769);
  // static Color infoColor = const Color(0xFF0061FE);

  // --- Utility Functions ---

  // Helper to generate MaterialColor (less common with ColorScheme, but can be useful)
  /*
  static MaterialColor getMaterialColor(Color color) {
    final int r = color.red, g = color.green, b = color.blue;
    return MaterialColor(color.value, <int, Color>{
      50: Color.fromRGBO(r, g, b, .1),
      100: Color.fromRGBO(r, g, b, .2),
      200: Color.fromRGBO(r, g, b, .3),
      300: Color.fromRGBO(r, g, b, .4),
      400: Color.fromRGBO(r, g, b, .5),
      500: Color.fromRGBO(r, g, b, .6), // Or just 'color'
      600: Color.fromRGBO(r, g, b, .7),
      700: Color.fromRGBO(r, g, b, .8),
      800: Color.fromRGBO(r, g, b, .9),
      900: Color.fromRGBO(r, g, b, 1),
    });
  }
  */

  // Helper to create slight variations of a color (for container colors)
  static Color _shiftColor(Color c, double amount, bool lighten) {
    final hsl = HSLColor.fromColor(c);
    final lightness = (hsl.lightness + (lighten ? amount : -amount)).clamp(
      0.0,
      1.0,
    );
    return hsl.withLightness(lightness).toColor();
  }

  // --- Text Theme Definition ---
  // Defines the base text theme using styles from styles.dart
  // This will be applied with appropriate colors for light/dark themes.
  static TextTheme get _baseTextTheme => TextTheme(
    displayLarge: TextStyles.displayLarge,
    displayMedium: TextStyles.displayMedium,
    displaySmall: TextStyles.displaySmall,
    headlineLarge: TextStyles.headlineLarge,
    headlineMedium: TextStyles.headlineMedium,
    headlineSmall: TextStyles.headlineSmall,
    titleLarge: TextStyles.titleLarge,
    titleMedium: TextStyles.titleMedium,
    titleSmall: TextStyles.titleSmall,
    bodyLarge: TextStyles.bodyLarge,
    bodyMedium: TextStyles.bodyMedium,
    bodySmall: TextStyles.bodySmall,
    labelLarge: TextStyles.labelLarge,
    labelMedium: TextStyles.labelMedium,
    labelSmall: TextStyles.labelSmall,
    // Material 2 TextStyles (caption and overline)
    // caption: TextStyles.caption, // M3 uses bodySmall or labelSmall
    // overline: TextStyles.overline, // M3 uses labelSmall
  );

  // --- Light Theme ---
  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryAccent,
      onPrimary: Colors.white,
      primaryContainer: _shiftColor(primaryAccent, 0.1, true), // Lighter
      onPrimaryContainer: textPrimaryLight,
      secondary: secondaryAccent,
      onSecondary: Colors.white,
      secondaryContainer: _shiftColor(secondaryAccent, 0.1, true), // Lighter
      onSecondaryContainer: textPrimaryLight,
      tertiary: greyMedium, // Example, adjust as needed
      onTertiary: textPrimaryLight,
      tertiaryContainer: greyLight,
      onTertiaryContainer: textSecondaryLight,
      error: errorColor,
      onError: onErrorColor,
      errorContainer: _shiftColor(errorColor, 0.4, true),
      onErrorContainer: textPrimaryLight,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      surfaceContainerHighest:
          backgroundLight, // For elements slightly different from surface
      onSurfaceVariant: textSecondaryLight,
      outline: greyMedium,
      outlineVariant: greyLight,
      shadow: Colors.black.withValues(alpha: 0.1),
      scrim: Colors.black.withValues(alpha: 0.3),
      inverseSurface:
          surfaceDark, // For elements on dark background in light theme
      onInverseSurface: textPrimaryDark,
      inversePrimary: primaryAccent.withValues(
        alpha: 0.8,
      ), // For interactive elements on inverseSurface
      // background and onBackground are often same as surface and onSurface
      background: backgroundLight,
      onBackground: textPrimaryLight,
    );

    final textTheme = _baseTextTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
      // decorationColor: colorScheme.primary, // if you want links etc to use primary
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: textTheme,
      primaryColor: colorScheme.primary, // Still useful for some older widgets
      scaffoldBackgroundColor: colorScheme.background,

      // fontFamily: Fonts.poppins, // Set globally if all text uses Poppins
      appBarTheme: AppBarTheme(
        color:
            colorScheme
                .surface, // Or colorScheme.primary if you want a colored AppBar
        elevation: 0, // Common modern look, or small like 1.0 or 2.0
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _shiftColor(
          colorScheme.surface,
          0.1,
          false,
        ), // Slightly darker surface
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: Corners.medBorder),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: Strokes.thin,
        space: Insets.med * 2,
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(
          colorScheme.surfaceContainerHighest,
        ),
        hintStyle: MaterialStateProperty.all(
          textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: Corners.lgBorder),
        ),
        // textStyle: ... if needed
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondaryContainer,
        disabledColor: colorScheme.outline.withValues(alpha: 0.5),
        selectedColor: colorScheme.primary,
        secondarySelectedColor: colorScheme.secondary, // Or a different color
        checkmarkColor: colorScheme.onPrimary,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSecondary,
        ), // For selected
        padding: EdgeInsets.symmetric(
          horizontal: Insets.sm,
          vertical: Insets.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: Corners.xlBorder,
        ), // More rounded for chips
        side: BorderSide.none, // Or BorderSide(color: colorScheme.outline)
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ), // Use surfaceContainerHighest
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.med,
        ),
        border: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: Strokes.thin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: Strokes.thin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: Strokes.medium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(
            color: colorScheme.error,
            width: Strokes.medium,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(
            color: colorScheme.error,
            width: Strokes.medium,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: Strokes.thin,
          ),
        ),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: Insets.button,
          shape: RoundedRectangleBorder(borderRadius: Corners.medBorder),
          textStyle: textTheme.labelLarge, // Uses global textTheme
          elevation: 2,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary, // Or colorScheme.onSurface
          side: BorderSide(color: colorScheme.outline, width: Strokes.thin),
          padding: Insets.button,
          shape: RoundedRectangleBorder(borderRadius: Corners.medBorder),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: EdgeInsets.symmetric(
            vertical: Insets.sm,
            horizontal: Insets.med,
          ),
          shape: RoundedRectangleBorder(borderRadius: Corners.smBorder),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ), // Slightly less bold
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        // M3 style filled button
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary, // Or secondary, tertiary
          foregroundColor: colorScheme.onPrimary,
          padding: Insets.button,
          shape: RoundedRectangleBorder(borderRadius: Corners.medBorder),
          textStyle: textTheme.labelLarge,
          elevation: 1,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: colorScheme.surface,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: Corners.lgBorder,
          // side: BorderSide(color: colorScheme.outlineVariant, width: Strokes.thin), // Optional border
        ),
        margin: EdgeInsets.all(Insets.xs), // Default margin for cards
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation:
            Shadows
                .medium[0]
                .blurRadius, // Using blurRadius as a proxy for elevation shadow
        shape: RoundedRectangleBorder(borderRadius: Corners.lgBorder),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected))
            return colorScheme.primary;
          return colorScheme.outline; // Thumb color when off
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected))
            return colorScheme.primary.withValues(alpha: 0.5);
          return colorScheme.surfaceContainerHighest; // Track color when off
        }),
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
        trackOutlineWidth: MaterialStateProperty.all(0),
        splashRadius: 0,
      ),
      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ), // From textTheme
        unselectedLabelStyle: textTheme.titleSmall,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: Strokes.thick,
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        preferBelow: false,
        padding: EdgeInsets.symmetric(
          horizontal: Insets.sm,
          vertical: Insets.xs,
        ),
        margin: EdgeInsets.all(Insets.xs),
        decoration: BoxDecoration(
          color: _shiftColor(
            colorScheme.surface,
            0.2,
            false,
          ).withValues(alpha: 0.95), // Darker surface
          borderRadius: Corners.smBorder,
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android:
              CupertinoPageTransitionsBuilder(), // Example: Use Cupertino transitions
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      // Define other component themes as needed...
    );
  }

  // --- Dark Theme ---
  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary:
          primaryAccent, // Keep primary accent, or choose a dark-mode friendly variant
      onPrimary: Colors.white, // Text/icons on primary
      primaryContainer: _shiftColor(
        primaryAccent,
        0.1,
        false,
      ), // Darker for dark theme
      onPrimaryContainer: textPrimaryDark,
      secondary: secondaryAccent,
      onSecondary: Colors.white,
      secondaryContainer: _shiftColor(secondaryAccent, 0.1, false), // Darker
      onSecondaryContainer: textPrimaryDark,
      tertiary: greyMedium,
      onTertiary: textPrimaryDark,
      tertiaryContainer: greyDark,
      onTertiaryContainer: textSecondaryDark,
      error: errorColor.withValues(
        alpha: 0.9,
      ), // Slightly desaturated/lighter error for dark
      onError: onErrorColor,
      errorContainer: _shiftColor(errorColor, 0.2, false),
      onErrorContainer: textPrimaryDark,
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      surfaceContainerHighest: backgroundDark,
      onSurfaceVariant: textSecondaryDark,
      outline: greyMedium,
      outlineVariant: greyDark,
      shadow: Colors.black.withValues(
        alpha: 0.3,
      ), // Shadows are less prominent in dark usually
      scrim: Colors.black.withValues(alpha: 0.5),
      inverseSurface: surfaceLight,
      onInverseSurface: textPrimaryLight,
      inversePrimary: primaryAccent.withValues(alpha: 0.8),
      background: backgroundDark,
      onBackground: textPrimaryDark,
    );

    final textTheme = _baseTextTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: textTheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,

      // fontFamily: Fonts.poppins,
      appBarTheme: AppBarTheme(
        color: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _shiftColor(
          colorScheme.surface,
          0.1,
          true,
        ), // Slightly lighter surface
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: Corners.medBorder),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: Strokes.thin,
        space: Insets.med * 2,
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(
          colorScheme.surfaceContainerHighest,
        ),
        hintStyle: MaterialStateProperty.all(
          textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: Corners.lgBorder),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondaryContainer,
        disabledColor: colorScheme.outline.withValues(alpha: 0.5),
        selectedColor: colorScheme.primary,
        secondarySelectedColor: colorScheme.secondary,
        checkmarkColor: colorScheme.onPrimary,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSecondary,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Insets.sm,
          vertical: Insets.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: Corners.xlBorder),
        side: BorderSide.none,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.med,
        ),
        border: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: Strokes.thin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: Strokes.thin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: Strokes.thin,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(color: colorScheme.error, width: Strokes.thin),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(color: colorScheme.error, width: Strokes.thin),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: Corners.medBorder,
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: Strokes.thin,
          ),
        ),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(
            vertical: Insets.med,
            horizontal: Insets.lg,
          ),
          shape: RoundedRectangleBorder(borderRadius: Corners.medBorder),
          textStyle: textTheme.labelLarge,
          elevation: 2, // Elevation can be different in dark mode
          shadowColor: colorScheme.shadow.withValues(
            alpha: 0.5,
          ), // Darker shadow base
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary, // Or colorScheme.onSurface
          side: BorderSide(color: colorScheme.outline, width: Strokes.medium),
          padding: EdgeInsets.symmetric(
            vertical: Insets.med - 2,
            horizontal: Insets.lg - 2,
          ),
          shape: RoundedRectangleBorder(borderRadius: Corners.medBorder),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: EdgeInsets.symmetric(
            vertical: Insets.sm,
            horizontal: Insets.med,
          ),
          shape: RoundedRectangleBorder(borderRadius: Corners.smBorder),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(
            vertical: Insets.med,
            horizontal: Insets.lg,
          ),
          shape: RoundedRectangleBorder(borderRadius: Corners.medBorder),
          textStyle: textTheme.labelLarge,
          elevation: 1,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 1, // Often less or no elevation in dark mode
        color:
            colorScheme
                .surfaceContainerHighest, // Use surfaceContainerHighest for cards in dark
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: Corners.lgBorder,
          // side: BorderSide(color: colorScheme.outlineVariant, width: Strokes.thin),
        ),
        margin: EdgeInsets.all(Insets.xs),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: Shadows.medium[0].blurRadius,
        shape: RoundedRectangleBorder(borderRadius: Corners.lgBorder),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected))
            return colorScheme.primary;
          return colorScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected))
            return colorScheme.primary.withValues(alpha: 0.5);
          return colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
        trackOutlineWidth: MaterialStateProperty.all(0),
        splashRadius: 0,
      ),
      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.titleSmall,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: Strokes.thick,
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        preferBelow: false,
        padding: EdgeInsets.symmetric(
          horizontal: Insets.sm,
          vertical: Insets.xs,
        ),
        margin: EdgeInsets.all(Insets.xs),
        decoration: BoxDecoration(
          color: _shiftColor(
            colorScheme.surface,
            0.2,
            true,
          ).withValues(alpha: 0.95), // Lighter surface
          borderRadius: Corners.smBorder,
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        // Consistent transitions
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      // Define other component themes for dark mode as needed...
    );
  }
}
