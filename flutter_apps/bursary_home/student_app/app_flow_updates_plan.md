# App Flow Updates Plan

This document outlines the planned phases for refactoring the application's user authentication and profile completion flow.

## Overall Goal

Refactor profile and authentication logic to centralize profile status and GPA in `AuthBloc`, separate academic details into a dedicated Firestore sub-collection, and ensure GPA is calculated and saved on profile submission.

## Phase 1: Refactor Name and Surname Sourcing

**Goal:** Ensure the user's name and surname are consistently sourced from the database (`StudentProfile`) rather than the authentication provider's display name.

**Key Changes:**
*   `AuthBloc`: Modified to fetch name/surname from `StudentProfile` (database).
*   `AppUser`: Updated to include `name` and `surname` fields.
*   `StudentProfile`: Updated to include `name` and `surname` fields, and handle them in Firestore serialization/deserialization.

## Phase 2: Simplify Profile Completion Check

**Goal:** Remove the explicit `profileStatus` field and determine profile completion by checking for the existence of the `users/{userId}/more_details/academics` document.

**Key Changes:**
*   `ProfileRepository`: Added `hasAcademicDetails` method to check for the existence of the academic details document.
*   `AppUser`: Removed `profileStatus` and added `hasCompletedProfile` boolean flag.
*   `AuthBloc`: Modified to use `hasAcademicDetails` to set `AppUser.hasCompletedProfile`.
*   `AppRouter`: Updated redirect logic to rely on `authBloc.state.user.hasCompletedProfile`.
*   `StudentProfile`: Removed the `status` field.
*   `ProfileRepository`: Changed the academic details subcollection document name from `details` to `academics` within `more_details`.

## Phase 3: Clean-up and Verification

**Goal:** Remove redundant code, ensure all components interact correctly with the new data structures, and verify the application's functionality.

**Key Activities:**
*   Remove any remaining references to old data structures (e.g., `extractedData`).
*   Review and update UI components to align with new data models.
*   Run `flutter analyze` to catch any remaining static analysis issues.
*   Perform manual testing of the entire user flow (login, profile completion, dashboard navigation).
