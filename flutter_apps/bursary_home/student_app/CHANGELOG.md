# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New `ConfirmationPage` for user review of extracted academic data.
- `ProfileProcessingSucceeded` event in `ProfileBloc` to trigger navigation to confirmation.
- `ConfirmProfile` event in `ProfileBloc` to finalize profile update after user confirmation.
- `updateProfileFromData` method in `ProfileRepository` for direct Firestore updates from extracted data.

### Changed
- **Removed ID document upload functionality** from `complete_profile_page.dart` (UI and associated logic).
- `DocumentUploadBloc` now passes extracted data directly to the `ProfileBloc` upon successful processing.
- `ProfileBloc` now includes `confirmationRequired` status to manage the new confirmation flow.
- `complete_profile_page.dart` now navigates to `ConfirmationPage` using `BlocProvider.value` to ensure proper BLoC context.
- `ConfirmationPage` now displays extracted data and includes "Confirm & Continue" and "Go Back & Re-upload" buttons.
- Corrected `complete_profile_page.dart` to re-include the academic results upload button.

### Removed
- ID document related variables, methods, and UI components from `complete_profile_page.dart`.
- ID document processing logic from `DocumentUploadBloc` (implicitly, as it now only handles academic documents).