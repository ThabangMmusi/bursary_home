# Purpose

This file defines the themes for the app.

# Functionality

This file defines the `AppTheme` class, which contains the light and dark themes for the app.

# Changelog
*   **2025-08-12:** Refactored `studentTheme` and `providerTheme` to reduce redundancy by introducing a shared `_buildSharedThemeData` method. This method now encapsulates common `ThemeData` properties, making theme definitions simpler and more maintainable.