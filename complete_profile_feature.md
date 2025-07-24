# Complete Profile Feature

This document outlines the enhanced features for the "Complete Profile" page within the student application.

## 1. Document Upload

The system must allow users to upload two primary documents:
*   **Highest Qualification:** This could be matric results, a diploma, or a degree certificate.
*   **ID Document:** A valid identification document (e.g., national ID card, passport).

## 2. Generative AI Content Extraction

Upon successful upload, the system will utilize Google Gemini 1.5 Pro (Generative AI) to extract relevant information from the uploaded documents.

### Extracted Data Points:

From the **Highest Qualification** document, the AI should extract:
*   **Subjects/Modules:** For each subject/module, the following details should be extracted:
    *   `name`: The name of the subject or module (e.g., "Mathematics", "Software Engineering").
    *   `marks`: The numerical mark obtained (0-100).
    *   `level`: The academic level or grade (1-7, or equivalent if applicable).
    *   `passed`: A boolean indicating whether the subject/module was passed (true/false).
*   **GPA (Grade Point Average):** The calculated GPA based on the extracted marks and levels.

From the **ID Document**, the AI should extract:
*   **Name:** The user's first name(s).
*   **Surname:** The user's last name.

## 3. Content Preview and Verification

After extraction, the system will present a preview of the extracted data to the user. This preview will include:

*   **Personal Details:**
    *   Name
    *   Surname
*   **Academic Details (from Highest Qualification):**
    *   A clear, tabular display of all extracted subjects/modules, showing their name, marks, level, and pass status.
    *   The calculated GPA.

The user will have the opportunity to review this extracted information for accuracy before confirming and saving their profile.
