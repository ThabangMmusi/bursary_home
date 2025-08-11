### **Plan: Bursary Details & Application Flow Refinement (with Bursary Model Update)**

**Objective:** To enhance the `BursaryDetailsPage` to display comprehensive company information by updating the `Bursary` model to directly include a `Company` object, integrate application submission directly from this dialog, and standardize its usage across the Dashboard, All Bursaries, and My Applications pages.

---

### **Phase 1: Update `Company` and `Bursary` Models**

**Objective:** Modify the `Bursary` model to hold a `Company` object directly, and ensure `Company` model has `fromFirestore` and `toFirestore` methods.

1.  **Update `Company` Model (`data_layer/lib/src/models/company_model.dart`)**
    *   **Action:** The `Company` model is assumed to exist and already has `fromFirestore` and `toFirestore` methods for serialization/deserialization.
    *   **Expected `Company` structure:**
        ```dart
        class Company extends Equatable {
          final String id;
          final String name; // Assuming 'name' is the field for company name
          // Add other company properties as needed

          const Company({
            required this.id,
            required this.name,
            // ...
          });

          factory Company.fromFirestore(DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Company(
              id: doc.id,
              name: data['name'] as String,
              // ...
            );
          }

          Map<String, dynamic> toFirestore() {
            return {
              'name': name,
              // ...
            };
          }

          @override
          List<Object?> get props => [id, name];
        }
        ```

2.  **Modify `Bursary` Model (`data_layer/lib/src/models/bursary_model.dart`)**
    *   **Action:**
        *   **Remove:** `final String company_id;`
        *   **Add:** `final Company? provider;` (or `required final Company provider;` if a bursary always has a provider). We'll use `Company?` for flexibility.
        *   **Update `fromFirestore` factory:**
            *   When deserializing, read the `company_id` (String) from the Firestore document.
            *   Use this `company_id` to create a `Company` object (e.g., `Company(id: companyId, name: 'Unknown')`). The full `Company` object will be fetched by the repository.
            *   Assign this `Company` object to the `provider` field.
        *   **Update `toFirestore` method:**
            *   When serializing, store `provider?.id` (String) in the Firestore map under the key `company_id`.

---

### **Phase 2: Update Repositories for `Company` Integration**

**Objective:** Adapt the `BursaryRepository` and `CompanyRepository` to correctly handle the `Company` object within the `Bursary` model.

1.  **Update `CompanyRepository` (`data_layer/lib/src/repositories/company_repository.dart`)**
    *   **Action:** Ensure `CompanyRepository` has a method (e.g., `getCompanyById(String companyId)`) that returns a `Future<Company?>`. This method will be crucial for populating the `provider` field in `Bursary` objects.

2.  **Modify `BursaryRepository` (`data_layer/lib/src/repositories/bursary_repository.dart`)**
    *   **Action:**
        *   **Modify `_getExcludedBursaryIds`:** No change expected here as it only deals with `bursaryId`.
        *   **Modify `loadStudentDashboardBursaries`, `loadStudentBursaries`, and `getBursaryById`:**
            *   After fetching bursary documents from Firestore, and before mapping them to `Bursary` objects, you will need to:
                *   Extract the `company_id` from each bursary document.
                *   Use the `CompanyRepository.getCompanyById` to fetch the corresponding `Company` object for each `company_id`.
                *   Construct the `Bursary` object with the fetched `Company` object assigned to the `provider` field.
                *   This will involve `async` operations within the stream mapping (e.g., using `asyncMap` or `Future.wait` on the list of bursaries).

---

### **Phase 3: Enhance `BursaryDetailsPage`**

**Objective:** Make `BursaryDetailsPage` self-sufficient in displaying full bursary and company details, and capable of triggering application submission.

1.  **Modify `BursaryDetailsPage` (`student_app/lib/features/dashboard/views/bursary_details_page.dart`)**
    *   **Action:**
        *   Ensure the constructor accepts a `Bursary` object (which now contains the `Company` object).
        *   Add an optional `VoidCallback? onApplyConfirmed` parameter to the constructor. This callback will be invoked when the "Apply Now" button *within this dialog* is pressed.
        *   **Display Company Name:** The `_BursaryDetailsPageState` will no longer need to fetch the company name separately, as it will be available directly from `widget.bursary.provider?.name`.
        *   **Integrate `onApplyConfirmed`:** In the "Apply Now" button's `onPressed` callback within `BursaryDetailsPage`, call `widget.onApplyConfirmed?.call();` before closing the dialog (`Navigator.of(context).pop();`).
        *   **Conditional "Apply Now" Button:** The "Apply Now" button within the dialog should only be visible and enabled if `onApplyConfirmed` is not `null`.

---

### **Phase 4: Implement Application Submission Logic**

**Objective:** Create the necessary event and handler within the `ApplicationsBloc` to process a new bursary application.

1.  **Add `ApplyForBursary` Event (`student_app/lib/features/applications/bloc/applications_event.dart`)**
    *   **Action:** Add a new event `class ApplyForBursary extends ApplicationsEvent` that takes a `Bursary` object as a parameter.

2.  **Add `_onApplyForBursary` Handler (`student_app/lib/features/applications/bloc/applications_bloc.dart`)**
    *   **Action:** Add a new `Future<void> _onApplyForBursary(ApplyForBursary event, Emitter<ApplicationsState> emit)` handler.
    *   **Logic:**
        *   Retrieve the current user's ID from `FirebaseAuth`.
        *   Create a new `Application` object with `bursaryId` from `event.bursary.id`, `userId`, `status: ApplicationStatus.pending`, and `appliedDate: DateTime.now()`.
        *   Call `_applicationRepository.createApplication(newApplication)`.
        *   Emit `ApplicationsStatus.loading` before the operation and `ApplicationsStatus.loaded` (or `ApplicationsStatus.error` on failure) after.
        *   Consider adding a `ScaffoldMessenger` message for user feedback (success/failure).

---

### **Phase 5: Integrate `BursaryDetailsPage` and Application Logic into UI**

**Objective:** Standardize "Apply Now" and "View Details" actions across relevant pages to consistently open the enhanced `BursaryDetailsPage` dialog.

1.  **Update `DashboardPage` (`student_app/lib/features/dashboard/views/dashboard_page.dart`)**
    *   **Action:** For `BursaryCard` instances (which are `BursaryCardType.available`):
        *   Set *both* `onApplyPressed` and `onViewDetailsPressed` to show the `BursaryDetailsPage` dialog.
        *   When showing the `BursaryDetailsPage`, pass the `onApplyConfirmed` callback.

2.  **Update `BursariesPage` (`student_app/lib/features/dashboard/views/bursaries_page.dart`)**
    *   **Action:** For `BursaryCard` instances (which are `BursaryCardType.available`):
        *   Set *both* `onApplyPressed` and `onViewDetailsPressed` to show the `BursaryDetailsPage` dialog.
        *   When showing the `BursaryDetailsPage`, pass the `onApplyConfirmed` callback.

3.  **Update `ApplicationsPage` (`student_app/lib/features/applications/views/applications_page.dart`)**
    *   **Action:** For `BursaryCard` instances (which are `BursaryCardType.application`):
        *   Ensure `onApplyPressed` is explicitly set to `null`.
        *   Ensure `onViewDetailsPressed` shows the `BursaryDetailsPage` dialog, passing `application.bursary` and `onApplyConfirmed: null`.

---

### **Phase 6: Documentation Updates**

**Objective:** Update the changelog for all modified files in the `documentation` folder.

1.  **Update Documentation Files:**
    *   `documentation/data_layer/lib/src/models/bursary_model.dart.md`
    *   `documentation/data_layer/lib/src/models/company_model.dart.md`
    *   `documentation/data_layer/lib/src/repositories/bursary_repository.dart.md`
    *   `documentation/data_layer/lib/src/repositories/company_repository.dart.md`
    *   `documentation/student_app/lib/features/dashboard/views/bursary_details_page.dart.md`
    *   `documentation/student_app/lib/features/applications/bloc/applications_event.dart.md`
    *   `documentation/student_app/lib/features/applications/bloc/applications_bloc.dart.md`
    *   `documentation/student_app/lib/features/dashboard/views/dashboard_page.dart.md`
    *   `documentation/student_app/lib/features/dashboard/views/bursaries_page.dart.md`
    *   `documentation/student_app/lib/features/applications/views/applications_page.dart.md`
    *   Add entries to the "Changelog" section of each updated file, detailing the purpose and functionality of the changes.
