# Plan: Integrate Academic Details into Profile View

**Date:** 2025-08-11

## 1. Goal

To fix the bug where academic details are not displayed on the user's profile page. This involves fetching the academic details from Firestore and plumbing them through the BLoC to the UI.

## 2. Plan Details

### Phase 1: Data Layer and State Management

1.  **`ProfileRepository`:**
    *   Create a new method `getAcademicDetails(String userId)` that fetches the document from the `users/{userId}/more_details/academics` sub-collection and returns it as a `Future<Map<String, dynamic>?>`.

2.  **`ProfileState` (`lib/features/profile/bloc/profile_state.dart`):**
    *   Add a new field: `final Map<String, dynamic>? academicDetails;`.
    *   Update the constructor, `copyWith` method, and `props` to include the new field.

3.  **`ProfileBloc` (`lib/features/profile/bloc/profile_bloc.dart`):**
    *   Modify the `_onLoadProfile` event handler.
    *   Inside the `listen` callback, after fetching the main user data, call the new `_profileRepository.getAcademicDetails(user.uid)` method.
    *   Update the `emit` call to pass the fetched academic details to the `academicDetails` field in the new state.

### Phase 2: UI Layer

1.  **`ProfilePage` (`lib/features/profile/presentation/pages/profile_page.dart`):**
    *   No major changes are expected here initially, as it already attempts to access `state.academicDetails`. However, once data is flowing, we will add type safety.
    *   **Refinement:** Replace the unsafe cast `(academicDetails['subjects'] as List)` with a safer method, like using a model class or at least performing a type check before casting.

## 3. Verification Strategy

1.  After Phase 1 is complete, run the app and navigate to the profile page.
2.  Use the debugger and `print` statements to verify that the `academicDetails` are being fetched by the `ProfileBloc` and are present in the `ProfileState`.
3.  After Phase 2 is complete, visually confirm that the qualification name and the list of subjects are correctly displayed on the profile page.
4.  Test with a user who has no academic details to ensure the UI gracefully handles the null case and displays "No academic details found.".
