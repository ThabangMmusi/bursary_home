### **Plan: Implement "Apply Now" on Dashboard Bursary Cards**

**Objective:** To enable the "Apply Now" button on `BursaryCard` widgets displayed on the `DashboardPage` to trigger the application submission process.

---

### **Part 1: Implement Application Submission Logic**

**Objective:** Create the necessary event and handler within the `ApplicationsBloc` to process a new bursary application.

1.  **Add `ApplyForBursary` Event:**
    *   **File:** `student_app/lib/features/applications/bloc/applications_event.dart`
    *   **Action:** Add a new event `class ApplyForBursary extends ApplicationsEvent` that takes a `Bursary` object as a parameter.

2.  **Add `_onApplyForBursary` Handler:**
    *   **File:** `student_app/lib/features/applications/bloc/applications_bloc.dart`
    *   **Action:** Add a new `Future<void> _onApplyForBursary(ApplyForBursary event, Emitter<ApplicationsState> emit)` handler.
    *   **Logic:**
        *   Retrieve the current user's ID from `FirebaseAuth`.
        *   Create a new `Application` object with `bursaryId` from `event.bursary.id`, `userId`, `status: ApplicationStatus.pending`, and `appliedDate: DateTime.now()`.
        *   Call `_applicationRepository.createApplication(newApplication)`.
        *   Emit `ApplicationsStatus.loading` before the operation and `ApplicationsStatus.loaded` (or `ApplicationsStatus.error` on failure) after.
        *   Consider adding a `ScaffoldMessenger` message for user feedback (success/failure).

---

### **Part 2: Connect "Apply Now" Button on Dashboard**

**Objective:** Modify the `DashboardPage` to dispatch the application submission event when the "Apply Now" button on a `BursaryCard` is pressed.

1.  **Modify `BursaryCard` `onApplyPressed`:**
    *   **File:** `student_app/lib/features/dashboard/views/dashboard_page.dart`
    *   **Action:** For `BursaryCard` instances displayed on the Dashboard:
        *   Set `onApplyPressed` to dispatch `context.read<ApplicationsBloc>().add(ApplyForBursary(bursary))`.

---

### **Part 3: Documentation Updates**

**Objective:** Update the changelog for all modified files in the `documentation` folder.

1.  **Update Documentation Files:**
    *   `documentation/student_app/lib/features/applications/bloc/applications_event.dart.md`
    *   `documentation/student_app/lib/features/applications/bloc/applications_bloc.dart.md`
    *   `documentation/student_app/lib/features/dashboard/views/dashboard_page.dart.md`
    *   Add entries to the "Changelog" section of each updated file, detailing the purpose and functionality of the changes.
