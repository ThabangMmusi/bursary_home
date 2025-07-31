# Progress Report: Phase 1 - Refactor Name and Surname Sourcing

**Goal:** Ensure the user's name and surname are consistently sourced from the database (`StudentProfile`) rather than the authentication provider's display name.

**Implementation Status:** **COMPLETED**

**Details of Implementation:**

*   **`AuthBloc` (`lib/features/auth/bloc/auth_bloc.dart`):**
    *   The `_onAuthUserChanged` method was modified to fetch `StudentProfile` from `ProfileRepository`.
    *   `firstName` and `lastName` are now assigned directly from `studentProfile?.name` and `studentProfile?.surname`.
    *   The logic that parsed `event.user?.displayName` for name/surname was removed, ensuring the database is the single source of truth for these fields.

*   **`AppUser` (`lib/data/models/app_user.dart`):**
    *   The `AppUser` class was updated to include `name` and `surname` fields.
    *   The `copyWith` method and `props` list were adjusted accordingly.

*   **`StudentProfile` (`lib/data/models/profile_model.dart`):**
    *   The `StudentProfile` model was updated to include `name` and `surname` fields.
    *   The `fromFirestore` and `toFirestore` methods were modified to correctly serialize and deserialize these fields to/from Firestore.

**Verification:**

All checks outlined in the plan for Phase 1 were successfully verified. The name and surname are now consistently sourced from the database.
