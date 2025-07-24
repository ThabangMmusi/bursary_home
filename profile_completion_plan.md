# Profile Completion Feature Plan

This document outlines the detailed plan for implementing the enhanced profile completion feature within the student application. The core idea is to securely extract information from user-uploaded documents (ID and academic qualifications) using Google Gemini 1.5 Pro, and then use this extracted data to build and enrich the user's profile in Firestore.

## 1. Overall Architecture

The architecture involves a secure backend intermediary (Firebase Cloud Function) to handle sensitive AI interactions, ensuring that the Google Gemini API key is never exposed on the client side.

*   **Flutter Client:** Handles document selection, uploads to Firebase Storage, and invokes the Cloud Function. It then *reads* the updated profile data from Firestore to display the extracted data preview.
*   **Firebase Storage:** Stores the raw uploaded documents (ID and academic).
*   **Firebase Cloud Function (`processDocumentExtraction`):**
    *   Triggered by the Flutter client.
    *   Fetches documents (or receives content) from the client/Storage.
    *   Securely calls Google Gemini 1.5 Pro for data extraction.
    *   Processes and validates AI responses.
    *   **Updates Firestore directly with the extracted data and document URLs, including setting the user's role to 'student' by default upon ID document upload.**
    *   Returns a success/failure status to the Flutter client.
*   **Google Gemini 1.5 Pro API:** Performs the intelligent content extraction from documents.
*   **Firestore:** Stores the structured user profile data, including extracted information and document URLs.

## 2. Phase 1: Firebase Cloud Function Development (Backend)

**Goal:** Create a secure, scalable, and robust Firebase Cloud Function to act as a proxy for Google Gemini 1.5 Pro, handling document processing, data extraction, and direct Firestore updates.

### Detailed Steps:

1.  **Initialize Firebase Functions Project:**
    *   Initialize a Cloud Functions project within your Firebase project using `firebase init functions`.
    *   Choose Node.js (recommended) or Python.
2.  **Securely Store Google Gemini API Key:**
    *   **Crucial:** Never hardcode the API key.
    *   Use Firebase Functions environment configuration:
        ```bash
        firebase functions:config:set gemini.api_key="YOUR_GEMINI_API_KEY_HERE"
        ```
3.  **Install Necessary Dependencies:**
    *   Navigate to the `functions` directory.
    *   Install the official Google Generative AI SDK: `npm install @google/generative-ai` (for Node.js).
    *   Install Firebase Admin SDK: `npm install firebase-admin` (for Node.js).
    *   Consider `cors` if your Flutter app is a web app (`npm install cors`).
4.  **Outline the `processDocumentExtraction` HTTP Callable Function:**
    *   **Type:** `functions.https.onCall` for secure client-to-function communication.
    *   **Input Parameters:**
        *   `userId`: The authenticated user's ID.
        *   `documentType`: A string, either `'id_document'` or `'academic_document'`.
        *   `documentContent`: The document's content (e.g., base64 encoded string for smaller files, or a Firebase Storage URL for larger files).
        *   `documentUrl`: The Firebase Storage URL of the uploaded document.
    *   **Authentication & Authorization:**
        *   Verify `context.auth.uid` to ensure the user is authenticated.
        *   Ensure `userId` passed in `data` matches `context.auth.uid`.
    *   **Retrieve API Key:** Access `functions.config().gemini.api_key`.
    *   **Input Validation:** Validate all incoming parameters (`userId`, `documentType`, `documentContent`, `documentUrl`).
    *   **Document-Specific AI Integration & Firestore Update Logic:**
        *   **If `documentType` is `'id_document'`:**
            *   Send ID document content to Gemini 1.5 Pro.
            *   **Prompt:** "Extract the `name` (first name) and `surname` (last name) from this ID document in JSON format: `{'name': '...', 'surname': '...'}`. Ensure high accuracy."
            *   **Firestore Update:** Upon successful extraction, update the `users/{userId}` document with `name`, `surname`, and **`role: 'student'` (default)**. Also, update `users/{userId}/details/profile_details/documents` with `id_document_url`.
            *   **Return:** A success status.
        *   **If `documentType` is `'academic_document'`:**
            *   Send academic document content to Gemini 1.5 Pro.
            *   **Prompt:** "Extract a list of `modules/subjects` (each with `name`, `marks` (0-100), `level` (1-7), `passed` (true/false)) and calculate the `GPA` from this academic document in JSON format: `{'subjects': [{'name': '...', 'marks': ..., 'level': ..., 'passed': ...}], 'gpa': ...}`."
            *   **Firestore Update:** Upon successful extraction, update `users/{userId}` document to set `role: 'student'`. Also, update `users/{userId}/details/profile_details/academics` with `subjects` and `gpa`. Update `users/{userId}/details/profile_details/documents` with `academic_document_url`.
            *   **Return:** A success status.
    *   **Error Handling:** Implement robust `try-catch` blocks to handle API failures, invalid document types, or AI extraction issues. Return meaningful `HttpsError` messages.

## 3. Phase 2: Flutter Client Integration (Frontend)

**Goal:** Implement the client-side logic to upload documents, invoke the Cloud Function, and reactively display updated profile data from Firestore.

### Detailed Steps:

1.  **Add Firebase Functions Dependency:**
    *   Add `cloud_functions` to `pubspec.yaml`.
2.  **Modify `_submitProfile` and `DocumentUploadBloc` Logic:**
    *   **Step 1: ID Document Upload and Core Profile Creation Trigger:**
        *   When the user uploads the **ID document**:
            *   Upload the ID document file to **Firebase Storage** (e.g., `users/{userId}/documents/id_document.pdf`). Get the `documentUrl`.
            *   Call the `processDocumentExtraction` Cloud Function, passing the document content (or Storage URL), `documentType: 'id_document'`, and the `documentUrl`.
            *   **Client Action:** The client will *not* directly update Firestore here. It will wait for the Cloud Function to complete and then rely on Firestore listeners to update the UI.
    *   **Step 2: Academic Document Upload and Profile Enrichment Trigger:**
        *   When the user uploads the **academic document**:
            *   Upload the academic document file to **Firebase Storage** (e.g., `users/{userId}/documents/academic_document.pdf`). Get the `documentUrl`.
            *   Call the `processDocumentExtraction` Cloud Function, passing the document content (or Storage URL), `documentType: 'academic_document'`, and the `documentUrl`.
            *   **Client Action:** Similar to Step 1, the client will *not* directly update Firestore. It will wait for the Cloud Function to complete and then rely on Firestore listeners to update the UI.
3.  **Reactive Data Display (Firestore Listeners):**
    *   Implement Firestore listeners (e.g., using `StreamBuilder` or `BlocListener` with a `ProfileBloc` that listens to Firestore streams) on:
        *   `users/{userId}` (for `name`, `surname`, `role`)
        *   `users/{userId}/details/profile_details/academics` (for `subjects`, `gpa`)
        *   `users/{userId}/details/profile_details/documents` (for `id_document_url`, `academic_document_url`)
    *   The `_extractedData` in `complete_profile_page.dart` will be populated from these Firestore streams, ensuring the UI always reflects the latest data from the backend.

## 4. Phase 3: Firestore Data Structure

**Goal:** Define the precise structure for storing user profile data, extracted information, and document URLs in Firestore.

### Detailed Structure:

1.  **`users` Collection:**
    *   **Document ID:** `userId` (e.g., from Firebase Authentication `uid`)
    *   **Fields:**
        *   `name`: (String, from ID document extraction)
        *   `surname`: (String, from ID document extraction)
        *   `role`: (String, `'student'` by default upon ID document upload, or explicitly set to `'student'` if academic document uploaded)

2.  **`details` Sub-collection/Sub-document within `users/{userId}`:**
    *   **Path:** `users/{userId}/details/profile_details` (This will be a single sub-document named `profile_details` within a `details` sub-collection, or just a `details` sub-document if you prefer. A sub-document is simpler for a single set of details.)
    *   **Fields within `profile_details`:**
        *   **`academics` (Map):**
            *   `subjects`: (List of Maps)
                *   `[{'name': 'Math', 'marks': 85, 'level': 7, 'passed': true}, {'name': 'Physics', 'marks': 70, 'level': 6, 'passed': true}, ...]`
            *   `gpa`: (Number)
        *   **`documents` (Map):**
            *   `id_document_url`: (String, Firebase Storage URL)
            *   `academic_document_url`: (String, Firebase Storage URL)
            *   *(This map will contain URLs for all uploaded documents.)*

## 5. Key Considerations & Security Notes

*   **API Key Security:** The Firebase Cloud Function is paramount for keeping your Google Gemini API key secure.
*   **Error Handling:** Implement comprehensive error handling on both the client and server sides to provide a robust user experience.
*   **User Feedback:** Provide clear visual feedback to the user during document upload, AI processing, and data saving (e.g., loading indicators, success/error messages).
*   **File Size Limits:** Be aware of Firebase Storage and Google Gemini API file size limits.
*   **Cost Management:** Monitor Firebase and Google Gemini API usage to manage costs.
*   **Data Validation:** Implement server-side validation of extracted data before saving to Firestore to ensure data integrity.
*   **Idempotency:** Ensure that repeated calls to the Cloud Function (e.g., due to network retries) do not lead to unintended side effects or duplicate data.
*   **Privacy:** Handle user documents and extracted personal information with utmost care, adhering to privacy regulations.