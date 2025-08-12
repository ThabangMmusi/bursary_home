# `login_page.dart` Documentation

## Purpose
This file defines the `LoginPage` widget, which serves as the primary entry point for user authentication in the student application. It handles user sign-in processes, including Google and Microsoft authentication, and manages navigation based on authentication status.

## Functionality
- Displays UI for user login.
- Integrates with `SignInBloc` for authentication logic.
- Handles navigation to the dashboard upon successful authentication.
- Provides a theme switching button to toggle between student and provider themes.

## Dependencies
- `bursary_home_ui` package for UI components (`AuthLayout`, `Buttons`, `StyledLoadSpinner`, `LogoComponent`, `Insets`, `AppColors`, `ThemeType`).
- `flutter_bloc` for state management (`BlocConsumer`, `BlocBuilder`).
- `ionicons` for icons.
- `go_router` for navigation.
- `student_app/features/auth/bloc/sign_in_bloc.dart` for sign-in events.
- `student_app/features/auth/bloc/app_bloc.dart` for overall app authentication state.
- `student_app/core/theme/bloc/theme_bloc.dart` for theme management.

## Changelog

### 2025-08-11
- **Enabled Theme Switching Button:** Uncommented and activated the theme switching functionality on the login page. Users can now toggle between 'Student' and 'Provider' themes directly from the login screen.
