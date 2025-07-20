# Application Features and Flows

This document outlines the core features of the Bursary Home application, detailing their functionality and user flows.

## 1. Authentication (Passwordless Email Login)

**Description:** Allows users to sign in or create an account using only their email address, eliminating the need for passwords. A magic link is sent to the user's email for secure login.

**Flow:**
1.  **User enters Email:** On the login page, the user enters their email address into the designated field.
2.  **Request Login Link:** The user clicks the "Send Login Link" button.
3.  **System Processes Request:**
    *   The system validates the email format.
    *   If the email does not correspond to an existing user, a new user account is created using the provided email as the username.
    *   A unique, time-limited login token is generated and stored, associated with the user.
    *   A magic login link containing this token is constructed.
    *   An email containing the magic link is sent to the user's provided email address (in development, this link is printed to the console).
4.  **User Clicks Magic Link:** The user receives the email and clicks the magic link.
5.  **System Validates Token:**
    *   The system receives the token from the URL.
    *   It validates the token's existence and ensures it has not expired.
    *   If valid, the user associated with the token is logged in.
    *   The used token is immediately invalidated/deleted.
6.  **Redirection Post-Login:**
    *   If the user is new or has an incomplete profile, they are redirected to the "Complete Profile" page.
    *   If the user's profile is complete, they are redirected to the Dashboard.

## 2. Dashboard

**Description:** The main landing page for logged-in users, displaying an overview of available bursaries and the user's profile status.

**Flow:**
1.  **Access Dashboard:** Users are redirected here after successful login (if their profile is complete) or can navigate to it from the sidebar.
2.  **Display Bursaries:** The dashboard lists available bursaries, potentially with details like name, description, amount, deadline, academic level, field of study, and GPA requirements. Sample data is generated if no bursaries exist.
3.  **Display User Status:** The user's profile completion status (e.g., "Profile Incomplete", "Pending Verification", "Verified") is prominently displayed.

## 3. Applications

**Description:** A section where users can view a list of dummy bursary applications, including their status and progress.

**Flow:**
1.  **Access Applications:** Users navigate to this page from the dashboard or sidebar.
2.  **Display Application List:** A list of mock applications is shown, each with details such as name, provider, field of study, GPA requirement, deadline, status (Pending, Approved, Rejected), and a progress bar.

## 4. Profile Management (Complete Profile)

**Description:** Allows users to complete or update their detailed student profile information and upload necessary documents. This is a critical step for new users.

**Flow:**
1.  **Access Complete Profile:** New users are automatically redirected here after their initial login. Existing users with incomplete profiles are also redirected here when attempting to access protected pages. Users can also navigate to it from the sidebar.
2.  **Display Profile Form:** The page presents a form for entering student details (e.g., student number, date of birth, institution, study program, academic year, average grade, contact number) and uploading documents (ID, academic records, proof of registration, financial documents).
3.  **Document Upload and AI Processing (Simulated):**
    *   Users can upload files.
    *   Upon submission, a simulated AI processing step occurs (currently a `time.sleep(2)`).
    *   If required documents (academic records, proof of registration) are uploaded, simulated extracted data (full name, ID number, etc.) is populated, and the `profile_status` is set to "Pending AI".
4.  **Profile Completion Check:** After submission, the system checks if the profile is considered "complete" based on defined criteria (e.g., required documents uploaded and essential textual data present).
5.  **Redirection Post-Completion:**
    *   If the profile is complete, the user is redirected to the Dashboard.
    *   If still incomplete, a message informs the user that more information or AI processing is pending.

## 5. Admin Interface

**Description:** The standard Django administration site for managing application data (Users, Bursaries, Students, Login Tokens).

**Flow:**
1.  **Access Admin:** Accessible via `/admin/` URL.
2.  **Login:** Requires superuser credentials.
3.  **Manage Data:** Provides a web interface to view, add, edit, and delete records for all registered models.
