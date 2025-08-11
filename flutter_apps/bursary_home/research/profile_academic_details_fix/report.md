# Research Report: Fixing Academic Details in Profile

**Date:** 2025-08-11

## 1. Problem Statement

The user has reported an issue with "academicDetaisls uder profile". The investigation revealed that the academic details are not being displayed on the profile page.

## 2. Key Findings

- **UI (`lib/features/profile/presentation/pages/profile_page.dart`):** The profile page attempts to access `state.academicDetails` to display academic information. It expects this to be a `Map<String, dynamic>`. It contains a risky explicit cast `(academicDetails['subjects'] as List)` which could cause a runtime error if the data is not in the correct format.

- **State Object (`lib/features/profile/bloc/profile_state.dart`):** The `ProfileState` class **does not** have a field for `academicDetails`. This is the primary reason the data is not appearing on the UI.

- **Bloc (`lib/features/profile/bloc/profile_bloc.dart`):** The `ProfileBloc` is responsible for loading the user's profile data. However, it **does not** fetch the `academicDetails`. It only fetches the main user document and checks for the existence of academic details to set the `hasCompletedProfile` flag.

- **Data Location:** Based on `app_flow.md` and other files, the academic details are stored in a sub-collection document at `users/{userId}/more_details/academics`.

## 3. Root Cause

The `ProfileBloc` and `ProfileState` were not implemented to fetch and hold the academic details data from Firestore. The UI (`ProfilePage`) was built with the incorrect assumption that this data would be available in the state.

## 4. Proposed Solution Area

The solution involves modifying the profile feature's BLoC, state, and repository to correctly fetch, store, and provide the `academicDetails` to the UI. This will ensure the data is displayed correctly and will also allow for safer data handling in the UI to prevent potential crashes.