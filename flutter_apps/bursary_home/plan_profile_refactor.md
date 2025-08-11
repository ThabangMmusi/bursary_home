### **Plan: Differentiating Profile Completion and Profile Viewing/Editing**

**Objective:** To correctly display a dedicated `ProfilePage` (as a dialog) for viewing and editing existing user data, while retaining `CompleteProfilePage` for initial profile setup.

---

### **Part 1: Enhance `ProfileBloc` and `ProfileRepository` for Academic Data Retrieval**

**Objective:** Ensure `ProfileBloc` can load and manage academic details, leveraging existing `ProfileRepository` methods.

1.  **Verify `getAcademicDetails` in `ProfileRepository`:**
    *   **File:** `data_layer/lib/src/repositories/profile_repository.dart`
    *   **Action:** Confirm that `getAcademicDetails(String userId)` method exists and returns `Future<Map<String, dynamic>?>`. (Based on our previous interaction, this method should already be there).

2.  **Modify `ProfileState`:**
    *   **File:** `student_app/lib/features/profile/bloc/profile_state.dart`
    *   **Action:** Add a new field: `final Map<String, dynamic>? academicDetails;` (default `null`).
    *   Update `copyWith` and `props` to include `academicDetails`.

3.  **Modify `ProfileBloc` (`_onLoadProfile` handler):**
    *   **File:** `student_app/lib/features/profile/bloc/profile_bloc.dart`
    *   **Action:** Inside the `_onLoadProfile` handler, after fetching the `AppUser` data:
        *   Call `_profileRepository.getAcademicDetails(user.uid)`.
        *   Update the `ProfileState` to include the fetched `academicDetails`.

---

### **Part 2: Create/Refactor `ProfilePage` for Viewing/Editing**

**Objective:** Design `ProfilePage` to load and display existing user profile and academic data, and to be presented as a dialog.

1.  **Modify `ProfilePage` (`student_app/lib/features/profile/views/profile_page.dart`)**
    *   **Action:** This page will be presented as a dialog. It should **not** contain a `Scaffold` directly, but rather a `Column` or similar layout.
    *   **Data Display:**
        *   Use `BlocBuilder<ProfileBloc, ProfileState>` to access the `profile` (`AppUser`) and `academicDetails` from the state.
        *   Display the user's name, email, GPA, and academic details (qualification, subjects).
    *   **Edit Functionality:** Add an "Edit Profile" button. When pressed, this button should open the `CompleteProfilePage` as a dialog, potentially pre-filling it with current data (though pre-filling is outside the scope of this specific plan, it's good to keep in mind for future).

---

### **Part 3: Update `AppShell` to Show `ProfilePage` Dialog**

**Objective:** Change the "Profile" button in `SideMenu` to open the new `ProfilePage` as a dialog.

1.  **Modify `AppShell` (`student_app/lib/features/shell/views/app_shell.dart`)**
    *   **Action:** In the `onProfilePressed` callback, change the `showDialog` content from `CompleteProfilePage()` to `ProfilePage()`.
    *   **BlocProvider:** Ensure `ProfileBloc` is provided to the `ProfilePage` within the dialog.

---

### **Part 4: Review `CompleteProfilePage` Usage**

**Objective:** Ensure `CompleteProfilePage` is only used for initial profile completion.

1.  **Review `AppRouter` (`student_app/lib/core/routes/app_router.dart`)**
    *   **Action:** Confirm that `CompleteProfilePage` is only used in the `/complete-profile` route and is not inadvertently used elsewhere for viewing/editing.

---

### **Part 5: Documentation Updates**

**Objective:** Update the changelog for all modified files in the `documentation` folder.

1.  **Update Documentation Files:**
    *   `documentation/student_app/lib/features/profile/views/profile_page.dart.md`
    *   `documentation/student_app/lib/features/profile/bloc/profile_bloc.dart.md`
    *   `documentation/student_app/lib/features/profile/bloc/profile_state.dart.md`
    *   `documentation/student_app/lib/features/shell/views/app_shell.dart.md`
    *   Add entries to the "Changelog" section of each updated file, detailing the purpose and functionality of the changes.
