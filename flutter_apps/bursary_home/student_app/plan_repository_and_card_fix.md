# Plan: Fix Bursary Repository and Application Card UI

This plan addresses two specific issues: the missing `getBursary` method in the repository and the incomplete UI for application status and cancellation on the `BursaryCard`.

---

### **Part 1: Add `getBursary` Method to Repository**

**Objective:** Implement the `getBursary(String bursaryId)` method in the `BursaryRepository` so the `ApplicationsBloc` can fetch individual bursary details.

**File to be Modified:**

1.  **`student_app/lib/data/repositories/bursary_repository.dart`**
    *   **Action:** Add a new method to the `BursaryRepository` class:
        ```dart
        Future<Bursary> getBursary(String bursaryId) async {
          try {
            final doc = await _firestore.collection('bursaries').doc(bursaryId).get();
            return Bursary.fromFirestore(doc);
          } catch (e) {
            // Handle errors appropriately
            rethrow;
          }
        }
        ```

---

### **Part 2: Implement Application Status and Cancel Button in UI**

**Objective:** Correctly display the status tag and a conditional "Cancel" button on the `BursaryCard` when it is used for an application.

**File to be Modified (in the `ui` package):**

1.  **`ui/bursary_home_ui/lib/widgets/bursary_card.dart`**
    *   **Action 1: Add Status Tag UI.** Inside the main `Column` of the card's content, add a section that only builds when `type == BursaryCardType.application` and `status != null`. This section will contain a `Chip` widget.
        *   The `Chip`'s `label` will be the status name (e.g., `status.name`).
        *   The `Chip`'s `backgroundColor` will change based on the status value (e.g., `_getColorForStatus(status!)`).
        *   A helper method `_getColorForStatus(ApplicationStatus status)` will be created inside the widget to return the correct color (yellow for pending, orange for processing, green for approved, red for rejected, grey for cancelled).

    *   **Action 2: Add Conditional Cancel Button.** Below the status tag, add a `TextButton` with the label "Cancel Application".
        *   This button should **only be visible** if `type == BursaryCardType.application` and the status is `ApplicationStatus.pending`.
        *   The button's `onPressed` method will call the `onCancelPressed` callback.

---

This plan is now ready. I will await your "code green" command to begin implementation.