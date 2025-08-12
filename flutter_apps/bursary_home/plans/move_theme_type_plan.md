# Plan: Move `ThemeType` to `bursary_home_ui` package

This plan outlines the process of moving the `ThemeType` enum from the `student_app` package to the `bursary_home_ui` package to centralize common UI-related definitions.

## Phase 1: Move `ThemeType` Definition

### Step 1.1: Create `bursary_home_ui/lib/enums.dart`

*   **Objective:** Create a new file in `bursary_home_ui` to house the `ThemeType` enum.
*   **Action:** Create `bursary_home_ui/lib/enums.dart` with the `ThemeType` enum definition.

### Step 1.2: Remove `ThemeType` from `theme_preferences.dart`

*   **Objective:** Remove the `ThemeType` enum definition from its original location.
*   **Action:** Modify `student_app/lib/core/theme/theme_preferences.dart` to remove the `ThemeType` enum.

### Step 1.3: Export `enums.dart` from `bursary_home_ui.dart`

*   **Objective:** Make the `ThemeType` enum accessible from the `bursary_home_ui` package.
*   **Action:** Modify `bursary_home_ui/lib/bursary_home_ui.dart` to export `enums.dart`.

## Phase 2: Update References

### Step 2.1: Update `student_app` files

*   **Objective:** Update imports for `ThemeType` in all affected files within `student_app`.
*   **Actions:**
    *   Modify `student_app/lib/core/theme/theme_preferences.dart`.
    *   Modify `student_app/lib/core/theme/bloc/theme_event.dart`.
    *   Modify `student_app/lib/core/theme/bloc/theme_state.dart`.
    *   Modify `student_app/lib/core/theme/bloc/theme_bloc.dart`.
    *   Modify `student_app/lib/features/auth/views/login_page.dart`.
    *   Modify `student_app/lib/main.dart`.

### Step 2.2: Update `bursary_home_ui` files

*   **Objective:** Update imports for `ThemeType` in all affected files within `bursary_home_ui`.
*   **Actions:**
    *   Modify `bursary_home_ui/lib/widgets/auth_layout.dart`.
    *   Modify `bursary_home_ui/lib/theme/themes.dart`.

## Phase 3: Verification

### Step 3.1: Run `flutter pub get`

*   **Objective:** Ensure all dependencies are correctly resolved after file changes.
*   **Action:** Run `flutter pub get` in both `student_app` and `bursary_home_ui` directories.

### Step 3.2: Run Tests

*   **Objective:** Verify that all existing tests pass after the refactoring.
*   **Action:** Run `flutter test` in both `student_app` and `bursary_home_ui` directories.

### Step 3.3: Visual Inspection

*   **Objective:** Visually inspect the application to ensure no regressions.
*   **Action:** Run the application and verify UI elements related to theme switching.
