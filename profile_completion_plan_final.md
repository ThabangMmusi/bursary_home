# Profile Completion Feature: Final Plan

This document serves as the comprehensive and definitive plan for implementing the enhanced profile completion feature. It consolidates all agreed-upon architectural decisions, responsibilities, and data structures to ensure a clear roadmap for development.

## 1. Overall Goal

To enable users to securely upload their ID and academic qualification documents, leverage Google Gemini 1.5 Pro for intelligent data extraction from these documents, and automatically populate/enrich their user profile in Firestore, providing a seamless and accurate profile completion experience.

## 2. Architecture Overview

The system employs a robust and secure architecture, separating concerns between the client, file storage, backend processing, AI interaction, and database.

*   **Flutter Client (Frontend):**
    *   Allows users to select and initiate the upload of ID and academic documents.
    *   Uploads raw document files directly to **Firebase Storage**.
    *   Invokes a **Firebase Cloud Function** to trigger AI processing and Firestore updates.
    *   Listens to **Firestore** for real-time updates to the user's profile and reactively displays extracted data for user review.
*   **Firebase Storage:**
    *   Serves as the secure repository for the raw, uploaded ID and academic document files.
*   **Firebase Cloud Function (`processDocumentExtraction` - Backend):**
    *   Triggered by the Flutter client via an HTTP Callable Function.
    *   Fetches the uploaded document content from Firebase Storage using the provided URL.
    *   Securely interacts with the **Google Gemini 1.5 Pro API** for data extraction.
    *   Parses and validates the AI's response.
    *   **Directly updates the user's profile data in Firestore** based on the extracted information and document type.
    *   Returns a simple success/failure status to the Flutter client.
*   **Google Gemini 1.5 Pro API:**
    *   The powerful multimodal AI model responsible for extracting structured data (names, subjects, grades, GPA) from scanned or digital documents, including PDFs and images.
*   **Firestore (Backend Database):**
    *   The NoSQL cloud database that stores the structured user profile data, including extracted personal details, academic records, and references (URLs) to the uploaded documents.

## 3. Phase 1: Firebase Cloud Function Development (Backend)

**Goal:** Develop a secure, scalable, and intelligent Firebase Cloud Function that orchestrates document fetching, AI extraction, and Firestore updates.

### Detailed Steps:

1.  **Initialize Firebase Functions Project:**
    *   Ensure Node.js and Firebase CLI are installed.
    *   Navigate to your project's root and run `firebase init functions`.
    *   Select your Firebase project and preferred language (Node.js recommended).
2.  **Securely Store Google Gemini API Key:**
    *   **Critical:** Never hardcode API keys in your code.
    *   Use Firebase Functions environment configuration:
        ```bash
        firebase functions:config:set gemini.api_key="YOUR_GEMINI_API_KEY_HERE"
        ```
3.  **Install Necessary Dependencies:**
    *   Navigate into the `functions` directory (`cd functions`).
    *   Install the official Google Generative AI SDK: `npm install @google/generative-ai`.
    *   Install Firebase Admin SDK: `npm install firebase-admin`.
    *   (Optional) Install `cors` if your Flutter app targets web: `npm install cors`.
4.  **Implement `processDocumentExtraction` HTTP Callable Function (`functions/index.js`):**
    *   **Function Type:** `exports.processDocumentExtraction = functions.https.onCall(async (data, context) => { ... });`
    *   **Authentication & Authorization:**
        *   Verify `context.auth` to ensure the user is authenticated.
        *   Use `const userId = context.auth.uid;` for all Firestore operations to prevent unauthorized access.
        *   Validate `data.userId` matches `context.auth.uid`.
    *   **Input Parameters (from Flutter Client):**
        *   `userId`: (String) The authenticated user's ID.
        *   `documentType`: (String) Either `'id_document'` or `'academic_document'`.
        *   `documentUrl`: (String) The Firebase Storage URL of the uploaded document.
    *   **Input Validation:** Ensure all required parameters are present and valid (`documentType`, `documentUrl`).
    *   **Retrieve Gemini API Key:** Access `functions.config().gemini.api_key`.
    *   **Fetch Document from Firebase Storage:**
        *   Use `admin.storage().bucket().file(filePath).download()` to get the document content as a buffer.
        *   Extract `filePath` and `mimeType` from `documentUrl` and file metadata respectively.
    *   **Prepare Content for Gemini API:** Convert the downloaded buffer to a base64 string and create `inlineData` parts for the Gemini API request.
    *   **Document-Specific AI Interaction & Firestore Update Logic:**
        *   **If `documentType` is `'id_document'`:**
            *   **Gemini Prompt:** "Extract the `name` (first name) and `surname` (last name) from this ID document in JSON format: `{'name': '...', 'surname': '...'}`. Ensure high accuracy."
            *   **Firestore Update:** Upon successful extraction, update the `users/{userId}` document with `name`, `surname`, and **`role: 'student'` (default role)**. Also, update `users/{userId}/details/profile_details/documents` with `id_document_url`.
        *   **If `documentType` is `'academic_document'`:**
            *   **Gemini Prompt:** "Extract a list of `modules/subjects` (each with `name`, `marks` (0-100), `level` (1-7), `passed` (true/false)) and calculate the `GPA` from this academic document in JSON format: `{'subjects': [{'name': '...', 'marks': ..., 'level': ..., 'passed': ...}], 'gpa': ...}`."
            *   **Firestore Update:** Upon successful extraction, update `users/{userId}` document to ensure `role: 'student'` (idempotent). Update `users/{userId}/details/profile_details/academics` with `subjects` and `gpa`. Update `users/{userId}/details/profile_details/documents` with `academic_document_url`.
    *   **AI Response Parsing:** Parse the `extractedText` from Gemini (expected to be JSON) into a JavaScript object.
    *   **Error Handling:** Implement robust `try-catch` blocks. Use `functions.https.HttpsError` for client-facing errors and `functions.logger.error` for server-side logging.
    *   **Return Value:** Return a simple `{ status: 'success', message: '...' }` or an error object.

## 4. Phase 2: Flutter Client Integration (Frontend)

**Goal:** Enable the Flutter application to upload documents, trigger backend processing, and reactively display the updated user profile.

### Detailed Steps:

1.  **Add Firebase Dependencies (`pubspec.yaml`):**
    *   Add `cloud_functions`, `firebase_storage`, and `cloud_firestore` to your `pubspec.yaml`.
    *   Run `flutter pub get`.
2.  **Modify `DocumentUploadBloc`:**
    *   **File Upload to Firebase Storage:**
        *   Use `FirebaseStorage.instance.ref().child('users/${userId}/documents/${documentType}_${timestamp}.pdf').putData(fileBytes)` to upload the document.
        *   Retrieve the `downloadURL` upon successful upload.
    *   **Cloud Function Invocation:**
        *   Instantiate `FirebaseFunctions.instance.httpsCallable('processDocumentExtraction')`.
        *   Call the function, passing `userId`, `documentType`, and the obtained `documentUrl`.
        *   Handle the success/failure response from the Cloud Function.
        *   **Crucially, the client will NOT update Firestore directly with extracted data.** Its role is to upload and trigger the backend process.
3.  **Reactive Data Display (Firestore Listeners in `ProfileBloc`):**
    *   **`ProfileBloc` (or similar state management):** Modify it to listen to real-time changes in Firestore.
        *   Listen to `FirebaseFirestore.instance.collection('users').doc(userId).snapshots()` for `name`, `surname`, and `role`.
        *   Listen to `FirebaseFirestore.instance.collection('users').doc(userId).collection('details').doc('profile_details').snapshots()` for `academics` (subjects, GPA) and `documents` (URLs).
        *   Combine these streams to form a comprehensive `StudentProfile` object in the Bloc's state.
    *   **UI (`complete_profile_page.dart`):**
        *   Remove local `_extractedData` state.
        *   The UI will now `context.watch<ProfileBloc>().state.profile?.extractedData` (or similar) to display the extracted information, ensuring it always reflects the latest data from Firestore.
4.  **User Feedback:** Implement loading indicators during file upload and Cloud Function processing, and display success/error messages using `ScaffoldMessenger`.

## 5. Phase 3: Firestore Data Structure

**Goal:** Define the precise, normalized structure for storing user profile data, extracted information, and document URLs in Firestore.

### Detailed Structure:

1.  **`users` Collection:**
    *   **Document ID:** `userId` (e.g., from Firebase Authentication `uid`)
    *   **Fields:**
        *   `name`: (String, extracted from ID document)
        *   `surname`: (String, extracted from ID document)
        *   `role`: (String, `'student'` - set by default upon ID document upload, or explicitly set/confirmed if academic document uploaded)

2.  **`details` Sub-collection/Sub-document within `users/{userId}`:**
    *   **Path:** `users/{userId}/details/profile_details` (This will be a single sub-document named `profile_details` within a `details` sub-collection. This approach keeps related details together while maintaining separation from the main user document.)
    *   **Fields within `profile_details`:**
        *   **`academics` (Map):**
            *   `subjects`: (List of Maps)
                *   `[{'name': 'Math', 'marks': 85, 'level': 7, 'passed': true}, {'name': 'Physics', 'marks': 70, 'level': 6, 'passed': true}, ...]`
            *   `gpa`: (Number)
        *   **`documents` (Map):**
            *   `id_document_url`: (String, Firebase Storage URL)
            *   `academic_document_url`: (String, Firebase Storage URL)
            *   *(This map will contain URLs for all uploaded documents.)*

## 6. Key Considerations & Security Notes

*   **API Key Security:** The Firebase Cloud Function is the cornerstone for keeping your Google Gemini API key secure. It never leaves the Google Cloud environment.
*   **Error Handling:** Implement comprehensive error handling on both the client and server sides to provide a robust user experience and aid debugging.
*   **User Feedback:** Crucial for a good UX. Provide clear visual cues (loading spinners, progress bars) and informative messages (success, failure, processing status).
*   **File Size Limits:** Be mindful of Firebase Storage limits (per file) and Google Gemini API limits (per request). For very large documents, consider breaking them down or using alternative processing.
*   **Cost Management:** Monitor Firebase (Storage, Cloud Functions, Firestore) and Google Gemini API usage to manage potential costs effectively.
*   **Data Validation:** Implement server-side validation of extracted data before saving to Firestore to ensure data integrity and prevent malformed data from entering your database.
*   **Idempotency:** Design Cloud Functions to be idempotent, meaning that repeated calls with the same input produce the same result without unintended side effects. This is important for handling network retries.
*   **Privacy & Compliance:** Handle user documents and extracted personal information with the utmost care. Ensure compliance with relevant data privacy regulations (e.g., GDPR, CCPA).
*   **Firebase Security Rules:** Implement strict Firebase Storage and Firestore Security Rules to control read/write access to user data and documents, ensuring only authenticated users can access their own data.
