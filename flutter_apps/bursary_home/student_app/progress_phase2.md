# Progress Report: Phase 2 - Simplify Profile Completion Check

**Goal:** Remove the explicit `profileStatus` field and determine profile completion by checking for the existence of the `users/{userId}/more_details/academics` document.

**Implementation Status:** **COMPLETED**

**Details of Implementation:**

*   **`ProfileRepository` (`lib/data/repositories/profile_repository.dart`):**
    *   The `hasAcademicDetails` method was added. This method checks for the existence of the `users/{userId}/more_details/academics` document in Firestore.
    *   The `saveCompleteProfile` method was updated to remove the `status` field from the Firestore `set` operation.
    *   The academic details subcollection document name was changed from `details` to `academics` within `more_details` in `saveAcademicDetails`.

*   **`AppUser` (`lib/data/models/app_user.dart`):**
    *   The `profileStatus` field was removed.
    *   A new boolean field, `hasCompletedProfile`, was added to represent the profile completion status.
    *   The `copyWith` method and `props` list were updated accordingly.

*   **`AuthBloc` (`lib/features/auth/bloc/auth_bloc.dart`):**
    *   The `_onAuthUserChanged` method was modified to use `_profileRepository.hasAcademicDetails` to set the `hasCompletedProfile` field in the `AppUser` object.

*   **`AppRouter` (`lib/core/routes/app_router.dart`):**
    *   The redirect logic was updated to rely on `authBloc.state.user.hasCompletedProfile` for determining whether to navigate to the complete profile page or the dashboard.

*   **`StudentProfile` (`lib/data/models/profile_model.dart`):**
    *   The `status` field was removed from the `StudentProfile` model.
    *   The `fromFirestore` and `toFirestore` methods were adjusted to reflect this change.

*   **`ProfileBloc` (`lib/features/profile/bloc/profile_bloc.dart` and `profile_state.dart`):**
    *   The `status` field was removed from `ProfileState`.
    *   The `_onLoadProfile` method was updated to fetch `hasCompletedProfile` from Firestore and pass it to `StudentProfile`.
    *   All remaining references to the old `status` field were removed.

**Verification:**

All checks outlined in the plan for Phase 2 were successfully verified. The profile completion is now determined by the existence of the `academics` document, and the `AuthBloc` correctly reflects this status.
