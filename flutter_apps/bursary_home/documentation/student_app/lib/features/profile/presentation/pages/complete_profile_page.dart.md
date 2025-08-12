# Purpose

This file defines the UI for the complete profile page.

# Functionality

This file displays the complete profile form. It uses the `CompleteProfileBloc` to manage the form state and the `ProfileBloc` to save the user's profile information.

# Changelog
*   **2025-08-12:** Added a logout button to the top right of the complete profile page using a `Stack` and `Positioned` widget. The button dispatches an `AppLogoutRequested` event when pressed and is only visible when the user is authenticated.