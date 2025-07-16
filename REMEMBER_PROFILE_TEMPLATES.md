# Important Note: Profile Templates

This document serves as a reminder regarding the distinct purposes and content of the two profile-related templates:

1.  **`templates/profile.html`**:
    *   **Purpose**: This is intended to be the **simple user profile display page**.
    *   **Content**: It should contain basic user information, possibly read-only, and links to other profile-related actions (like "Complete Profile").
    *   **Key Characteristic**: It is a general-purpose profile view for all users.

2.  **`templates/complete_profile.html`**:
    *   **Purpose**: This is intended to be the **complex profile completion/onboarding form**.
    *   **Content**: It contains the detailed forms for users to upload documents, fill in extensive personal/academic information, and interact with AI processing.
    *   **Key Characteristic**: It is specifically for users who need to complete or update their detailed profile information.

**Crucial Reminder:**
*   **NEVER mix the concerns of these two templates.**
*   `profile.html` is for viewing.
*   `complete_profile.html` is for data entry/completion.

Avoid conflating their functionalities or content. Ensure that views and URLs correctly point to the appropriate template based on its intended purpose.
