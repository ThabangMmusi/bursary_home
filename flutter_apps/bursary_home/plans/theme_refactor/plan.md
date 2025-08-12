# Plan: Theme Refactor (Redo)

**Date:** 2025-08-11

## 1. Goal

To refactor the `bursary_home_ui` widgets to use theme-based colors instead of hardcoded `AppColors`, ensuring maintainability and adherence to the application's theming system.

## 2. Plan Details

### Phase 1: Core Theming Setup - Revised for Theme-Specific Colors

1.  **Step 1.1: Define Theme-Specific Color Palettes**
    *   **Goal:** Create a mechanism to provide distinct `primaryColor` and `backgroundColor` (and potentially other colors) for Student and Provider themes. This might involve creating separate `AppColors` classes (e.g., `StudentAppColors`, `ProviderAppColors`) or a dynamic color provider.
    *   **Action:** Modify `bursary_home_ui/lib/theme/app_colors.dart` and potentially introduce new color definition files.
    *   **Approval:** User approval required before coding.

2.  **Step 1.2: Update `themes.dart` to Utilize Theme-Specific Colors**
    *   **Goal:** Configure `studentTheme` and `providerTheme` in `themes.dart` to correctly use their respective theme-specific `primaryColor` and `backgroundColor` (and other relevant colors).
    *   **Action:** Modify `bursary_home_ui/lib/theme/themes.dart`.
    *   **Approval:** User approval required before coding.

### Phase 2: Widget Refactoring (Iterative)

This phase will involve refactoring each identified widget to use the new theme-based colors. Each widget will be a separate step.

1.  **Step 2.1: Refactor `alert_message.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/alert_message.dart`.
    *   **Approval:** User approval required before coding.

2.  **Step 2.2: Refactor `auth_form_container.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/auth_form_container.dart`.
    *   **Approval:** User approval required before coding.

3.  **Step 2.3: Refactor `auth_layout.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/auth_layout.dart`.
    *   **Approval:** User approval required before coding.

4.  **Step 2.4: Refactor `bursary_card.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/bursary_card.dart`.
    *   **Approval:** User approval required before coding.

5.  **Step 2.5: Refactor `custom_input_field.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/custom_input_field.dart`.
    *   **Approval:** User approval required before coding.

6.  **Step 2.6: Refactor `custom_modal.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/custom_modal.dart`.
    *   **Approval:** User approval required before coding.

7.  **Step 2.7: Refactor `dashboard_header_section.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/dashboard_header_section.dart`.
    *   **Approval:** User approval required before coding.

8.  **Step 2.8: Refactor `file_upload_widget.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/file_upload_widget.dart`.
    *   **Approval:** User approval required before coding.

9.  **Step 2.9: Refactor `form_section_header.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/form_section_header.dart`.
    *   **Approval:** User approval required before coding.

10. **Step 2.10: Refactor `logo_component.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/logo_component.dart`.
    *   **Approval:** User approval required before coding.

11. **Step 2.11: Refactor `progress_bar.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/progress_bar.dart`.
    *   **Approval:** User approval required before coding.

12. **Step 2.12: Refactor `sidebar_navigation_item.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/sidebar_navigation_item.dart`.
    *   **Approval:** User approval required before coding.

13. **Step 2.13: Refactor `status_label.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/status_label.dart`.
    *   **Approval:** User approval required before coding.

14. **Step 2.14: Refactor `success_dialog.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/success_dialog.dart`.
    *   **Approval:** User approval required before coding.

15. **Step 2.15: Refactor `top_header_bar.dart`**
    *   **Goal:** Replace hardcoded `AppColors` with `Theme.of(context).colorScheme` properties.
    *   **Action:** Modify `bursary_home_ui/lib/widgets/top_header_bar.dart`.
    *   **Approval:** User approval required before coding.

### Phase 3: UI Element Refinements

1.  **Step 3.1: Remove Border Radius from Input Forms**
    *   **Goal:** Set `borderRadius.zero` for input fields in relevant forms.
    *   **Action:** Identify and modify relevant input form widgets (e.g., `custom_input_field.dart` if it's used for forms).
    *   **Approval:** User approval required before coding.

## 3. Verification Strategy

1.  **Visual Inspection:** After each widget refactoring, visually inspect the UI to ensure that the colors are correctly applied and no visual regressions have occurred.
2.  **Code Review:** Ensure that all hardcoded `AppColors` instances within the refactored widgets have been replaced with `Theme.of(context).colorScheme` properties.
3.  **Unit/Widget Tests:** If applicable, run existing unit or widget tests to ensure functionality remains intact.
