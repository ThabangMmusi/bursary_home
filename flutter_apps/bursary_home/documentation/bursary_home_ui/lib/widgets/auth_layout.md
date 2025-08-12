# `auth_layout.dart` Documentation

## Purpose
This file defines the `AuthLayout` widget, which provides a responsive layout for authentication-related screens (e.g., login, signup). It adapts its layout based on screen size and handles the display of the authentication form and associated visual elements.

## Functionality
- Provides a two-column layout for larger screens and a single-column layout for smaller screens.
- Displays a dynamic image based on the selected theme (`ThemeType.student` or `ThemeType.provider`).
- Integrates with `ThemeColors` for background and primary colors.
- Positions the `LogoComponent` and other UI elements.

## Dependencies
- `package:bursary_home_ui/theme/styles.dart` for text styles and spacing.
- `package:bursary_home_ui/widgets/logo_component.dart` for displaying the application logo.
- `package:bursary_home_ui/theme/theme_colors.dart` for custom theme colors.
- `package:bursary_home_ui/enums.dart` for `ThemeType` enum.

## Changelog

### 2025-08-11
- **Fixed Animation Issue:** Modified the `AnimatedSwitcher` transition in both large and small screen layouts to include a `FadeTransition`. This ensures that the old image fades out while the new image slides in from the left, resolving the issue where the old image was perceived as moving to the right.

### 2025-08-11
- **Reverted Animation Fix:** Reverted the previous animation changes in `AnimatedSwitcher` for both large and small screen layouts. The `FadeTransition` has been removed, and the `SlideTransition`'s `begin` offset is restored to `Offset(1.0, 0.0)` (appear from right).