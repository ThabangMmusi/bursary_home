# Plan: Role-Based Theme Switch & App State Evolution

This plan outlines the integration of a theme switching mechanism based on user roles, with persistence, and the evolution of the application's state management.

## Phase 1: Theme Management & Persistence (Initial Focus)

The primary goal of this phase is to establish the ability to switch themes and persist that choice, independent of user authentication initially.

### Step 1.1: Introduce Theme Persistence

*   **Objective:** Save and load the selected theme preference (student or provider) using `shared_preferences`.
*   **Actions:**
    *   Add `shared_preferences` to `pubspec.yaml` in `student_app`.
    *   Create a new `theme_preferences.dart` file (e.g., `student_app/lib/core/theme/theme_preferences.dart`) with methods to save and load the theme type (e.g., `ThemeType.student` or `ThemeType.provider`).

### Step 1.2: Create `ThemeBloc`

*   **Objective:** Design a dedicated Bloc to manage the current theme state and handle theme change events.
*   **Actions:**
    *   Create `student_app/lib/core/theme/bloc/theme_event.dart`, `theme_state.dart`, and `theme_bloc.dart`.
    *   The `ThemeBloc` will:
        *   Load the initial theme from `ThemePreferences` on startup.
        *   Handle `ThemeChanged` events, updating its state and saving the new preference.
        *   Expose the current `ThemeData` (either `AppTheme.studentTheme` or `AppTheme.providerTheme`) as part of its state.

### Step 1.3: Integrate `ThemeBloc` into `MyApp`

*   **Objective:** Make the application's theme dynamic based on the `ThemeBloc`'s state.
*   **Actions:**
    *   Wrap `MaterialApp.router` in `main.dart` with a `BlocBuilder<ThemeBloc, ThemeState>`.
    *   Set the `theme` property of `MaterialApp.router` based on the `ThemeState`.

### Step 1.4: Implement Pre-Login Theme Switch UI

*   **Objective:** Provide a UI element on the login screen to allow users to manually switch themes *only when unauthenticated*. This will also initiate a login animation (details of animation to be decided later).
*   **Actions:**
    *   Modify `login_page.dart` to include a `TextButton` (or similar) below the `AuthFormContainer`.
    *   The text of this button will dynamically change based on the *current* theme (e.g., "Login as Provider" if the current theme is student, and "Login as Student" if the current theme is provider).
    *   This button will only be visible/enabled if the `AuthBloc` state indicates `AuthStatus.unauthenticated`.
    *   On press, this button will:
        *   Dispatch a `ThemeChanged` event to the `ThemeBloc` to switch to the *other* theme.
        *   Trigger a placeholder for the login animation (actual animation implementation will be in Phase 3).

## Phase 2: App State Evolution & Role-Based Theming

This phase will involve evolving the `AuthBloc` into a more comprehensive `AppBloc` that manages the application's overall state, including the user's role, which will be derived directly from the active theme. Once a user logs in, the role determined by the active theme at that point will persist throughout their authenticated session.

*   **Step 2.1: Evolve `AuthBloc` to `AppBloc`:** Rename and refactor `AuthBloc` to `AppBloc` to manage authentication, user data, and other global app states.
*   **Step 2.2: Integrate Theme Role into `AppBloc` State:** The `AppBloc` will observe the `ThemeBloc`'s state to determine the current user role (student or provider). This role will then be part of the `AppBloc`'s state and used throughout the authenticated session. The `User` model in `data_layer` will *not* be modified to include a `role` property at this stage.
*   **Step 2.3: Update Authentication Flow to Align with Theme Role:** The authentication process will be updated to ensure that the user's login attempt aligns with the currently selected theme/role. If a user attempts to log in as a student while the provider theme is active (or vice-versa), appropriate handling (e.g., error message, automatic theme switch before login) will be considered.

## Phase 3: Role-Dependent UI & Animated Transitions (Future Steps)

This phase will focus on adapting the UI based on the user's role and implementing smooth visual transitions.

*   **Step 3.1: Identify Role-Dependent UI:** Systematically review all UI components (images, text, specific widgets) that need to change based on the user's role.
*   **Step 3.2: Implement Conditional UI Rendering:** Use `BlocBuilder` or `context.select` to conditionally render UI elements based on the user's role.
*   **Step 3.3: Implement Animated Transitions:** Research and apply appropriate animation techniques for theme and image transitions, especially during the login process.