# Plan: Theme Refactor

This plan outlines the process of refactoring the widgets in the `bursary_home_ui` package to use theme-based colors instead of hardcoded `AppColors`.

## Steps

1.  **Theme Refactoring:**
    *   Update `app_colors.dart` to include the new student-specific colors and rename the existing colors for clarity.
    *   Refactor `themes.dart` to create the `studentTheme` and `providerTheme`.
    *   Update `bursary_home_ui.dart` to export the new themes.
2.  **Widget Refactoring:**
    *   Identify all widgets that use hardcoded `AppColors`.
    *   For each widget, replace the hardcoded colors with theme-based colors using `Theme.of(context)`.
    *   Update the documentation for each widget to reflect the changes.

## Research

I will now conduct research to identify all the widgets that need to be refactored.
