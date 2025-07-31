# Plan: Refactor Bursary and Application Display

This plan details the steps to remove the old matching logic, implement a new GPA visualizer, and fix the data loading for the "My Applications" screen.

**Assumed Project Structure:**

```
/ (parent folder)
├── student_app/
│   └── ... (Flutter student application)
└── ui/
    └── bursary_home_ui/
        └── ... (Flutter UI package)
```

---

### **Part 1: Remove Old Match Logic & Implement GPA Visualizer**

**Objective:** Completely remove the deprecated "match percentage" and replace it with an intuitive stacked progress bar that visualizes the student's GPA against the bursary's required GPA.

**Files to be Modified / Created:**

1.  **Create New Widget:** `ui/bursary_home_ui/lib/widgets/gpa_progress_bar.dart`
    *   This widget will be created to display the two-part (orange and green) GPA bar.
    *   It will take `userGpa` and `requiredGpa` as input.

2.  **Modify Bursary Card:** `ui/bursary_home_ui/lib/widgets/bursary_card.dart`
    *   **Remove** the `matchPercentage` parameter entirely.
    *   Add two new parameters: `double? userGpa` and `double? requiredGpa`.
    *   Integrate the new `<GpaProgressBar />` into the card's layout. It should only be visible when the card `type` is `BursaryCardType.bursary`.

3.  **Update Dashboard & Bursaries Pages:**
    *   `student_app/lib/features/dashboard/views/dashboard_page.dart`
    *   `student_app/lib/features/dashboard/views/bursaries_page.dart`
    *   In both files, find the `BursaryCard` instance.
    *   **Remove** the old `matchPercentage` property.
    *   Pass the `userGpa` from the `AuthBloc` and `bursary.gpa` as the `requiredGpa`.

---

### **Part 2: Fix Application Data Loading and Display**

**Objective:** Refactor the `Application` model and associated logic to correctly load and display full bursary details on the "My Applications" screen.

**Files to be Modified:**

1.  **Fix Application Model:** `student_app/lib/data/models/application_model.dart`
    *   The model should contain `final String bursaryId;` (to read from Firestore) and `final Bursary? bursary;` (to hold the fetched data).
    *   The `bursary` field should not be part of the `fromFirestore` constructor.
    *   Ensure a `copyWith({Bursary? bursary})` method exists to attach the fetched bursary object later.

2.  **Fix Application Bloc:** `student_app/lib/features/applications/bloc/applications_bloc.dart`
    *   In the `_onLoadApplications` method, iterate through the fetched applications.
    *   For each application, use the `application.bursaryId` to fetch the corresponding `Bursary` object from the `BursaryRepository`.
    *   Use the `application.copyWith(bursary: ...)` method to create a new list of `Application` objects that contain the complete `Bursary` data.

3.  **Fix Applications Page UI:** `student_app/lib/features/applications/views/applications_page.dart`
    *   Access the nested bursary object: `application.bursary`.
    *   Replace all placeholder text with the actual data (e.g., `application.bursary!.name`).
    *   The `BursaryCard` for applications will not show the GPA progress bar.

---

### **Part 3: Enhance Application Management**

**Objective:** Add a cancellation feature and visual status tags to the application cards.

**Files to be Modified:**

1.  **Update Bursary Card:** `ui/bursary_home_ui/lib/widgets/bursary_card.dart`
    *   Add `final VoidCallback? onCancelPressed;`.
    *   Add `final ApplicationStatus? status;`.
    *   When `type` is `BursaryCardType.application`, display a "Cancel" button and a status tag with the correct color based on the `status` enum.

2.  **Implement Cancellation Logic:**
    *   `student_app/lib/features/applications/bloc/applications_event.dart`: Add `CancelApplication` event.
    *   `student_app/lib/features/applications/bloc/applications_bloc.dart`: Add handler to process the `CancelApplication` event and update Firestore.

3.  **Update Applications Page UI:** `student_app/lib/features/applications/views/applications_page.dart`
    *   Pass the `application.status` to the `BursaryCard`.
    *   Call the `onCancelPressed` callback to trigger the cancellation event.