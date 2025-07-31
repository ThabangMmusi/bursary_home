# Plan: Bursary Card Dialog Company Name

**Objective:** Enhance the bursary card interaction by displaying a dialog that includes the full company name (fetched from Firestore) when either "Apply" or "View Details" is clicked.

**Detailed Steps:**

1.  **Create Plan Documents:**
    *   `plan_Bursary_Card_Dialog_Company_Name_plan.md` (This file)
    *   `plan_Bursary_Card_Dialog_Company_Name_progress.md`
    *   `plan_Bursary_Card_Dialog_Company_Name_changelog.md`

2.  **Define Data Model for Company (if not exists):**
    *   Check if a `Company` model exists. If not, create `lib/data/models/company_model.dart` with `id` and `name` properties.

3.  **Implement Company Repository:**
    *   Create `lib/data/repositories/company_repository.dart` (or add to `BursaryRepository`).
    *   Add a method `getCompanyName(String companyId)` that fetches the company document from the "companies" Firestore collection and returns its `name` field.

4.  **Update `BursaryDetailsPage` (`lib/features/dashboard/views/bursary_details_page.dart`):**
    *   Make `BursaryDetailsPage` a `StatefulWidget` if it's not already.
    *   In `initState`, fetch the company name using the `company_id` from the `bursary` object.
    *   Display a loading indicator while fetching the company name.
    *   Once fetched, display the company name instead of `bursary.company_id`.
    *   Handle potential errors during fetching.

5.  **Modify `DashboardPage` (`lib/features/dashboard/views/dashboard_page.dart`):**
    *   Update the `onApplyPressed` callback for `BursaryCard` to also show a dialog. This dialog can either be `BursaryDetailsPage` (if it's generic enough) or a new `ApplyBursaryDialog`. For simplicity, initially, we can reuse `BursaryDetailsPage`.

6.  **Refine `BursaryCard` Display:**
    *   Once the dialog is working, consider if the `BursaryCard` itself should display the company name instead of the ID. This would require fetching the company name for all displayed bursaries, which might impact performance. (This is a potential future optimization/decision, not part of the core plan for the dialog).
