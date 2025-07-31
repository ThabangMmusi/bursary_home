# Changelog: Bursary Card Dialog Company Name

## Initial Entry:

- Created plan documents for implementing company name display in bursary card dialog.

## Updates:

- Implemented `Company` data model (`lib/data/models/company_model.dart`).
- Implemented `CompanyRepository` (`lib/data/repositories/company_model.dart`).
- Updated `BursaryDetailsPage` (`lib/features/dashboard/views/bursary_details_page.dart`) to fetch and display the company name from Firestore.
- Modified `DashboardPage` (`lib/features/dashboard/views/dashboard_page.dart`) to show the `BursaryDetailsPage` dialog when the "Apply" button on a `BursaryCard` is pressed.
