# Plan: New Dashboard Bursary Logic

This plan details the steps to update the dashboard to display a limited number of bursaries and to create a new page to display all bursaries that meet the specified criteria.

### **Part 1: Update the Bursary Repository (Revised)**

**Objective:** Implement the new, more precise bursary filtering and limiting logic in the `BursaryRepository`. The logic will be based on the user's GPA and their existing application statuses, and will use an efficient `whereNotIn` query.

1.  **Update `loadStudentDashboardBursaries` Method:**
    *   In `data_layer/lib/src/repositories/bursary_repository.dart`, modify the `getBursariesForDashboard` method to `loadStudentDashboardBursaries`.
    *   This method will now require the `userId` and `userGpa`.
    *   **Step 1: Fetch Excluded Bursary IDs.** The method will first query the `applications` collection to find all documents where the `userId` matches the current user and the `status` is one of `pending`, `rejected`, or `processing`. It will then extract the `bursaryId` from each of these applications into a local list of "excluded IDs."
    *   **Step 2: Fetch and Filter Bursaries.** The method will then query the `bursaries` collection with the following conditions:
        *   `where('gpa', isLessThanOrEqualTo: userGpa)`
        *   `whereNotIn(FieldPath.documentId, excludedBursaryIds)`
        *   `limit(4)`
    *   The method will return a `Stream<List<Bursary>>` containing the final, filtered list.

2.  **Update `loadStudentBursaries` Method:**
    *   In `data_layer/lib/src/repositories/b_repository.dart`, modify the `getAllBursaries` method to `loadStudentBursaries`.
    *   This method will also require the `userId` and `userGpa`.
    *   It will perform the exact same two-step filtering logic as `loadStudentDashboardBursaries` but will **not** apply the `limit(4)` clause. It will return all bursaries that meet the criteria.

### **Part 2: Update the Bursary Bloc**

**Objective:** Update the `BursaryBloc` to use the new repository methods.

1.  **Rename Events:**
    *   In `student_app/lib/features/dashboard/bloc/bursary_event.dart`, rename `LoadBursaries` to `LoadStudentDashboardBursaries`.
    *   Create a new event named `LoadStudentBursaries`.

2.  **Update `BursaryBloc` Handlers:**
    *   In `student_app/lib/features/dashboard/bloc/bursary_bloc.dart`, rename the `_onLoadBursaries` handler to `_onLoadStudentDashboardBursaries` and have it call the `loadStudentDashboardBursaries` method.
    *   Create a new event handler named `_onLoadStudentBursaries` that will be triggered by the `LoadStudentBursaries` event. This handler will call the `loadStudentBursaries` method.

### **Part 3: Update the UI**

**Objective:** Update the dashboard to display the limited list of bursaries and create a new page to display all bursaries.

1.  **Update `DashboardPage`:**
    *   In `student_app/lib/features/dashboard/views/dashboard_page.dart`, ensure that the `LoadStudentDashboardBursaries` event is dispatched when the page is loaded.
    *   The "See all" button will navigate to the new `BursariesPage`.

2.  **Create `BursariesPage`:**
    *   Create a new file named `bursaries_page.dart` in `student_app/lib/features/dashboard/views/`.
    *   This page will be a `StatelessWidget` that displays a `GridView` of `BursaryCard` widgets.
    *   When the page is loaded, it will dispatch the `LoadStudentBursaries` event to the `BursaryBloc`.

### **Part 4: Update the Application Logic**

**Objective:** Ensure that the `BursaryBloc` has access to the list of applied bursary IDs.

1.  **Update `ApplicationsBloc`:**
    *   In `student_app/lib/features/applications/bloc/applications_bloc.dart`, ensure that the `ApplicationsState` includes a list of the user's applications.
    *   The `BursaryBloc` will then be able to access this list of applications and extract the bursary IDs.

