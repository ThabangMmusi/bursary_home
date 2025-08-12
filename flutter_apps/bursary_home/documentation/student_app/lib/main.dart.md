# Purpose

This is the main entry point for the student app.

# Functionality

This file initializes the app, including Firebase, the BLoCs, and the router. It also sets up the `MultiRepositoryProvider` and `MultiBlocProvider` to make the repositories and BLoCs available to the rest of the app.

# Changelog
*   **2025-08-12:** Modified `main.dart` to dispatch the `ThemeStarted` event to the `ThemeBloc` on app startup, ensuring that the saved theme preference is loaded and applied.
*   **2025-08-12:** Corrected an erroneous string literal in `main.dart` that was introduced during a previous modification, restoring proper import statements.