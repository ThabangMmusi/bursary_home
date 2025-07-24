# Flutter UI Structure for Bursary Home Application

This document outlines the proposed Flutter UI structure, including core layouts, reusable widgets, and pages, based on the analysis of the existing Django templates and `styles.css`.

## 1. Core Layouts

These layouts define the overarching structure of different sections of the application.

*   **`AuthLayout`**
    *   **Purpose**: Used for authentication-related screens (Login, Complete Profile).
    *   **Structure**:
        *   **Large Screens**: Two-column layout.
            *   Left column: Branding (logo) and a decorative image.
            *   Right column: Forms and interactive content.
        *   **Small Screens**: Stacks vertically, with branding/image appearing above the forms.
    *   **Styling Notes**: Replicates background wave effects and a "books" decoration (will require custom painters or SVG assets in Flutter).

*   **`DashboardLayout`**
    *   **Purpose**: Used for authenticated user screens (Dashboard, Applications, Profile).
    *   **Structure**:
        *   **Large Screens**: Sidebar navigation on the left, main content area on the right.
        *   **Small Screens**: Sidebar might collapse or become a bottom navigation bar, and content adjusts.
    *   **Widgets Included**: `Sidebar`, `TopHeader` (containing search and user profile section), `MainContentArea`.

## 2. Reusable Widgets/Components

These are individual Flutter widgets designed for reusability across different pages.

*   **`LogoComponent`**:
    *   **Description**: Displays the "Bursary Home" logo image and text title.
    *   **Usage**: Found in both `AuthLayout` and `DashboardLayout`.

*   **`BursaryCard`**:
    *   **Description**: Displays summary information for a single bursary or application.
    *   **Content**: Title, provider, deadline, status/match percentage, field of study tag, and an action button (e.g., "Apply Now", "Cancel Application", "View Details").
    *   **Usage**: Used in `DashboardPage` (for available bursaries) and `ApplicationsPage` (for user's applications).

*   **`CustomModal`**:
    *   **Description**: A generic, customizable modal structure.
    *   **Adaptations**: Will be used to create specific modals like:
        *   `BursaryDetailsModal`: Shows comprehensive details of a selected bursary/application.
        *   `ConfirmationModal`: Used for actions requiring user confirmation (e.g., cancelling an application).
        *   `SuccessDialog`: Displays a success message after an action.

*   **`CustomInputField`**:
    *   **Description**: A styled text input field, potentially with a leading icon.
    *   **Usage**: For email/password input in `LoginPage`, and other text inputs in profile forms.

*   **`SocialLoginButton`**:
    *   **Description**: Buttons for third-party authentication (e.g., Google, Microsoft).
    *   **Content**: Icon and text.
    *   **Usage**: `LoginPage`.

*   **`FileUploadWidget`**:
    *   **Description**: A custom widget for handling file uploads.
    *   **Content**: Label, icon, file hint (e.g., "PDF, max 5MB"), and visual feedback for file selection (e.g., "File Selected").
    *   **Usage**: `CompleteProfilePage`, `ProfilePage`.

*   **`AlertMessage`**:
    *   **Description**: Displays various types of alert messages (error, success, warning, info) with corresponding icons and styling.
    *   **Usage**: `LoginPage`, `CompleteProfilePage`, `ProfilePage`.

*   **`ProgressBar`**:
    *   **Description**: A visual progress bar.
    *   **Usage**: Within `BursaryCard` to show match percentage or application progress.

*   **`StatusLabel`**:
    *   **Description**: Displays the user's profile verification status (e.g., "Verified", "Pending Verification", "Profile Incomplete") with an icon.
    *   **Usage**: `DashboardPage`.

*   **`SidebarMenuItem`**:
    *   **Description**: Individual navigation items within the `Sidebar`.
    *   **Content**: Icon and text, with active state styling.
    *   **Usage**: `DashboardLayout`.

## 3. Pages/Screens

Each Django template will be translated into a dedicated Flutter screen.

*   **`LoginPage`**
    *   **Corresponds to**: `templates/login.html`
    *   **Functionality**: User authentication via email link or social login.
    *   **Layout**: Uses `AuthLayout`.

*   **`CompleteProfilePage`**
    *   **Corresponds to**: `templates/complete_profile.html`
    *   **Functionality**: Initial profile setup, primarily for uploading required academic documents.
    *   **Layout**: Uses `AuthLayout`.

*   **`DashboardPage`**
    *   **Corresponds to**: `templates/dashboard.html`
    *   **Functionality**: Displays a personalized welcome message, user verification status, and a list of available bursaries.
    *   **Layout**: Uses `DashboardLayout`.

*   **`ApplicationsPage`**
    *   **Corresponds to**: `templates/applications.html`
    *   **Functionality**: Lists all bursary applications submitted by the user, showing their status and providing options to cancel or view details.
    *   **Layout**: Uses `DashboardLayout`.

*   **`ProfilePage`**
    *   **Corresponds to**: `templates/profile.html`
    *   **Functionality**: Allows users to view and upload additional profile documents (e.g., ID, proof of income).
    *   **Layout**: Uses `DashboardLayout`.

## 4. Styling & Theming Strategy

*   **Color Palette**: A `ColorScheme` or a custom `AppColors` class will be defined in Flutter, mapping directly to the CSS `--primary-color`, `--error-color`, `--success-color`, `--background-color`, etc.
*   **Typography**: A `TextTheme` will be created to ensure consistent font families (`Segoe UI` or a suitable alternative), font sizes, weights, and colors across the application, mirroring the `styles.css` definitions.
*   **Spacing & Padding**: Consistent use of Flutter's `SizedBox` for spacing and `EdgeInsets` for padding, translating the `margin` and `padding` values from CSS.
*   **Borders & Shadows**: `BoxDecoration` will be extensively used to replicate `border-radius`, `box-shadow`, and `border` properties from the CSS.
*   **Responsive Design**: Flutter's `MediaQuery` and `LayoutBuilder` will be employed to adapt layouts for different screen sizes, effectively translating the `@media` queries found in `styles.css`.
*   **Images**: All static images from the `static/images/` directory (e.g., `Bursary_Logo.svg`, `students.png`, `boy white.png`, `books.png`) will be added to the Flutter project's `pubspec.yaml` and accessed using `AssetImage` or `SvgPicture.asset` (for SVG).
*   **Icons**: `ionicons` and `Font Awesome` icons will be replaced with Flutter's built-in `Icons` class where possible, or by using a custom icon font package if specific icons are not available.

## 5. BLoC State Management Integration Points (Located in `student_app/lib/features/<feature_name>/bloc/`)

Each major functional area within the `student_app` will have a corresponding BLoC (Business Logic Component) to manage its state.

*   **`AuthBloc`**:
    *   **Responsibilities**: Manages user authentication state (login, logout, registration, password reset).
    *   **Interacts with**: Firebase Authentication.

*   **`ProfileBloc`**:
    *   **Responsibilities**: Handles user profile data, including document uploads, profile completion status, and extracted information.
    *   **Interacts with**: Firestore (`students` collection) and Firebase Storage (for documents).

*   **`BursaryBloc`**:
    *   **Responsibilities**: Fetches and manages the list of available bursaries, including filtering and searching.
    *   **Interacts with**: Firestore (`bursaries` collection).

*   **`ApplicationsBloc`**:
    *   **Responsibilities**: Manages the user's submitted bursary applications (fetching, cancelling, updating status).
    *   **Interacts with**: Firestore (likely a subcollection under `students` or a separate `applications` collection).

*   **`ModalCubit` (or similar simple state management for UI)**:
    *   **Responsibilities**: Manages the visibility and content of various modals and dialogs (e.g., `CustomModal`, `SuccessDialog`) by interacting with UI components directly.
