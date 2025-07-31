# App Flow: Authentication and Profile Completion

This document outlines the core application flow, focusing on user authentication, profile completion, and data management.

## 1. Initial Application Load

Upon launching the application, the system performs an initial check:

*   **Authentication Status:** It first verifies if a user is currently logged in (authenticated).
    *   **If NOT Authenticated:** The user is immediately redirected to the **Login Screen**.
    *   **If Authenticated:** The system proceeds to check the user's profile status.

## 2. Profile Completion Check

Once a user is authenticated, the application determines if their profile is complete:

*   **Database Document Check (Initial):** The system queries Firestore to check for the existence of the user's main document: `users/{userId}`.
    *   **If Main Document DOES NOT Exist:** This indicates a new user with no profile data yet. The user is redirected to the **Complete Profile Page**.
    *   **If Main Document EXISTS:** The system then proceeds to check for profile *completion*.
        *   **Profile Completion Check (Secondary):** The system checks for the existence of the academic details document: `users/{userId}/more_details/academics`.
            *   **If `academics` Document DOES NOT Exist:** This indicates an incomplete profile. The user is redirected to the **Complete Profile Page**.
            *   **If `academics` Document EXISTS:** This indicates a complete profile. The user is redirected to the **Dashboard Page**.

## 3. Complete Profile Page

This page guides users through providing their personal and academic details.

*   **Name and Surname Sourcing:**
    *   Initially, the user's name and surname displayed on this page are retrieved from their **authentication provider** (e.g., Firebase Auth's display name).
    *   However, upon successful submission of the complete profile, the name and surname stored in the **database** (`users/{userId}` document) become the authoritative source for these details across the application.
*   **Academic Details Entry:**
    *   Users are presented with two options to populate their academic history:
        *   **Enter Manually:** Users can manually input their qualification name and add multiple subject entries (module name, marks, auto-calculated level).
        *   **Read from Document (AI):** An AI-powered feature allows users to upload a document, from which academic information is extracted and pre-fills the form.
*   **GPA Calculation:** As subjects and marks are entered (manually or via AI), the user's GPA is calculated in real-time based on the defined grading scale.

## 4. Profile Submission and Data Persistence

When the user submits their complete profile:

*   **Data Collection:** The application collects:
    *   User's Name and Surname (from the form).
    *   Calculated GPA.
    *   Qualification Name.
    *   List of Modules (name, marks).
*   **Database Storage:**
    *   The **Name, Surname, and GPA** are saved directly to the user's main document in Firestore (`users/{userId}`).
    *   The **Qualification Name and Modules** are saved to a dedicated sub-collection document: `users/{userId}/more_details/academics`.
*   **Internal App Status Update:**
    *   After successful data saving, the application updates an internal flag within the `AppUser` model. This flag, previously `hasCompletedProfile`, is now renamed to `hasProfile`.
    *   **Important:** This `hasProfile` status is purely an **application-level indicator** and is *not* persisted to the database. Profile completion is solely determined by the existence of the `users/{userId}/more_details/academics` document in Firestore.

## 5. Post-Submission Navigation

*   Upon successful profile submission and internal status update, the user is shown a success message (e.g., a SnackBar) and then automatically navigated to the **Dashboard Page**.

This flow ensures a clear separation of concerns, centralizes profile status and key data points within the `AuthBloc` for easy access, and provides a robust mechanism for profile completion.
