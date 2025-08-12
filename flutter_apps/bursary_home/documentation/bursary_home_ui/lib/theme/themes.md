# `themes.dart` Documentation

## Purpose
This file defines the application's themes (`studentTheme` and `providerTheme`) and related color palettes. It centralizes the theme definitions, ensuring consistency across the application.

## Functionality
- Defines `studentTheme` and `providerTheme` using `ThemeData`.
- Specifies color schemes, text themes, and component themes for each application theme.
- Provides utility functions for color manipulation.

## Dependencies
- `package:bursary_home_ui/theme/styles.dart` for text styles.
- `package:bursary_home_ui/theme/app_colors.dart` for core application colors.
- `package:bursary_home_ui/theme/theme_colors.dart` for custom theme extensions.

## Changelog

### 2025-08-11
- **Fixed ThemeColors Extension Null Issue:** Corrected the type definition for `ThemeColors` extension in `studentTheme` and `providerTheme` to `ThemeExtension<ThemeColors>` from `ThemeExtension<dynamic>`. This resolves the `null` value error when retrieving `ThemeColors` from `ThemeData`.
