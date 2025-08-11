# Research Report: Theme Refactor

## Problem Statement

The widgets in the `bursary_home_ui` package use hardcoded `AppColors`, which makes it difficult to maintain and update the application's theme. The goal of this refactoring is to replace the hardcoded colors with theme-based colors using `Theme.of(context)`.

## Key Findings

The following widgets use hardcoded `AppColors` and need to be refactored:

*   `alert_message.dart`
*   `auth_form_container.dart`
*   `auth_layout.dart`
*   `bursary_card.dart`
*   `custom_input_field.dart`
*   `custom_modal.dart`
*   `dashboard_header_section.dart`
*   `file_upload_widget.dart`
*   `form_section_header.dart`
*   `logo_component.dart`
*   `progress_bar.dart`
*   `sidebar_navigation_item.dart`
*   `status_label.dart`
*   `success_dialog.dart`
*   `top_header_bar.dart`

## Plan

I will refactor each of these widgets to use theme-based colors. I will start with `alert_message.dart`.
