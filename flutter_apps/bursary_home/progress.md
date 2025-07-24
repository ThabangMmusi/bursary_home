## Project Progress Log

### Phase 1: Monorepo & Core Infrastructure Setup
- [x] Monorepo Root Created (`bursary_home`)
- [x] Flutter Application (`student_app`) Initialized
- [x] Shared UI Package (`bursary_home_ui`) Initialized
- [x] Firebase Project Setup & Integration for `student_app`
- [x] Core Dependencies Added to `student_app/pubspec.yaml`
- [x] Asset Management Setup (directory created, images copied, `pubspec.yaml` updated)
- [x] Shared UI Package Content (theme files, all shared widgets, and export file created)
- [x] Core Project Structure (directories for features, data, core) created implicitly by file creations.

### Phase 2: Authentication & Routing
- [x] Authentication Repository (`auth_repository.dart`) created.
- [x] Authentication Blocs (`AuthBloc`, `SignInBloc` and their events/states) created.
- [x] Authentication Pages (`LoginPage`) created.
- [x] GoRouter Setup (`app_router.dart` created and `main.dart` updated to use it).
- [x] **Phase 2: Authentication & Routing - COMPLETED**

### Phase 3: Profile Management
- [x] Profile Data Model (`profile_model.dart`) created.
- [x] Profile Repository (`profile_repository.dart`) created.
- [x] Profile Blocs (`ProfileBloc`, `DocumentUploadBloc` and their events/states) created.
- [x] Profile Pages (`CompleteProfilePage`, `ProfilePage`) created.
- [x] `AppRouter` updated with profile routes and redirect logic.
- [x] `main.dart` updated to provide `ProfileBloc` and `DocumentUploadBloc`.
- [x] **Phase 3: Profile Management - COMPLETED**

### Phase 4: Dashboard & Bursary Listing
- [x] Bursary Data Model (`bursary_model.dart`) created.
- [x] Bursary Repository (`bursary_repository.dart`) created.
- [x] Bursary Blocs (`BursaryBloc` and its events/states) created.
- [x] Dashboard Pages (`DashboardPage`, `BursaryDetailsPage`) created.
- [x] `AppRouter` updated with dashboard and bursary details routes.
- [x] `main.dart` updated to provide `BursaryBloc`.
- [x] **Phase 4: Dashboard & Bursary Listing - COMPLETED**

### Phase 5: Applications & Refinement
- [x] Application Data Model (`application_model.dart`) created.
- [x] Application Repository (`application_repository.dart`) created.
- [x] Application Blocs (`ApplicationsBloc` and its events/states) created.
- [x] Applications Pages (`ApplicationsPage`) created.
- [x] `AppRouter` updated with applications route.
- [x] `main.dart` updated to provide `ApplicationsBloc`.
- [x] **Phase 5: Applications & Refinement - COMPLETED**

### Phase 6: Deployment & Final Review
- [ ] Build the Flutter web application for release.
- [x] **Refinement: Handle Nullable Callbacks in UI Components**
  - [x] Modified `bursary_home_ui/lib/widgets/social_login_button.dart` to correctly define `onPressed` as `VoidCallback?`.
  - [x] Verified `student_app/lib/features/auth/views/login_page.dart` correctly handles nullable `onPressed` (no `as VoidCallback?` cast needed).
- [x] **Visual Alignment of Login Page (Student App)**
  - [x] Created `bursary_home_ui/lib/widgets/auth_layout.dart` for two-column/stacked layout and decorative elements.
  - [x] Updated `bursary_home_ui/lib/bursary_home_ui.dart` to export `AuthLayout`.
  - [x] Modified `student_app/lib/features/auth/views/login_page.dart` to use `AuthLayout` and align text/divider with Django student login UI.