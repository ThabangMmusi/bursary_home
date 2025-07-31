# Redesigning the "Complete Profile" Feature

### 1. Objective

To redesign the "Complete Profile" feature to create a more intuitive, guided, and efficient user experience. This redesign will introduce a clear separation between personal and academic details and provide users with the option to populate their academic history either manually or automatically by scanning a document.

### 2. Proposed Flow & UI/UX

The feature will be a single, dynamic page that guides the user through two main sections: Personal Details and Academic Details.

#### **Part 1: Personal Details**

*   **Header:** A clear header titled "Personal Details".
*   **Fields (Pre-filled & Non-Editable):**
    *   `Name`: Pre-populated from the user's login information.
    *   `Surname`: Pre-populated from the user's login information.
*   **Fields (User Input):**
    *   `ID Number`: A field for the user's national ID number.
    *   `Date of Birth`: A date picker for the user's date of birth.

#### **Part 2: Academic Details - Entry Method**

*   Directly below the "Personal Details" section, the user will be presented with two choices for entering their academic information:
    1.  **[Button] Enter Academics Manually:** A standard button for manual data entry.
    2.  **[Button] Read from Document (AI):** A primary or floating action button that initiates the AI-powered document scanning flow.

#### **Part 3: Academic Details - Data Form**

*   This section will become visible after the user chooses an entry method. It will be the same form for both flows, but the AI flow will populate it automatically.
*   **Header:** A clear header titled "Academic Details".
*   **Fields:**
    *   `Qualification Name`: A text field for the name of the qualification (e.g., "BSc in Computer Science").
    *   **Reusable Subject/Module Widget:** A list of reusable widgets, each containing:
        *   `Subject/Module Name`: Text field.
        *   `Marks (%)`: Numerical input field.
        *   `Level/Year`: Dropdown or text field for the academic year/level of the subject.
*   **Actions:**
    *   An "Add Subject" button will be available to allow users to add more subject entries in the manual flow.
    *   The AI flow will populate this form with the data extracted from the document. The user will be able to review and edit the fields.

#### **Part 4: Submission**

*   A single "Submit" button will be present at the bottom of the page to save the complete profile information.

### 3. Technical Implementation Plan

1.  **State Management (BLoC):**
    *   Create a `CompleteProfileBloc` to manage the state of the entire page.
    *   **State:** Will hold user input (`idNumber`, `dateOfBirth`), academic info (`qualificationName`, `List<Subject>`), and the UI state (`entryMode`, `isLoading`, `error`).
    *   **Events:** `ManualEntrySelected`, `AIScanInitiated`, `FilePicked`, `SubjectAdded`, `SubjectRemoved`, `FormSubmitted`.

2.  **Widget Development:**
    *   Create a main `CompleteProfilePage` widget.
    *   Develop a `PersonalDetailsCard` widget.
    *   Develop a reusable `SubjectEntryWidget`.
    *   Develop an `AcademicDetailsForm` widget that contains the qualification and the list of `SubjectEntryWidget`s.

3.  **AI Document Scanning:**
    *   Integrate a file picker package (e.g., `file_picker`).
    *   Implement a service that communicates with a backend (or a local model) to process the uploaded document and extract the academic information. For the frontend task, this can be mocked initially.

4.  **Action Plan:**
    1.  **Structure:** Build the basic page layout with the "Personal Details" section and the two buttons for academic entry.
    2.  **Manual Flow:** Implement the manual entry flow, including the `AcademicDetailsForm` and the ability to add/remove subjects.
    3.  **State & BLoC:** Wire up all manual inputs to the `CompleteProfileBloc`.
    4.  **AI Flow:**
        *   Integrate the file picker.
        *   Create a mock service that returns sample extracted data.
        *   Dispatch an event to the BLoC to populate the form with the mock data upon file selection.
    5.  **Submission:** Implement the final "Submit" logic to send the collected data to the repository.
    6.  **Testing:** Write widget and BLoC tests to ensure all flows work as expected.
