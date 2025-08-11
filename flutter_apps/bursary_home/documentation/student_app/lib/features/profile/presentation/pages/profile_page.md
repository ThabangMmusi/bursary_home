# Documentation: ProfilePage

**Date:** 2025-08-11

## 1. Overview

The `ProfilePage` widget is responsible for displaying the user's profile information, including personal details, academic information, and uploaded documents.

## 2. Data Dependencies

-   **`ProfileBloc`**: This page listens to the `ProfileBloc` to get the user's profile data.
-   **`ProfileState`**: The state from the `ProfileBloc` provides the `profile` and `academicDetails` data.

## 3. UI Components

-   **Personal Information**: Displays the user's name, surname, email, and GPA.
-   **Academic Information**: Displays the user's qualification name and a list of subjects with their marks.
-   **Documents**: A placeholder section for displaying uploaded documents.

## 4. Changelog

-   **2025-08-11:** Fixed a bug where academic details were not being displayed. Updated the `ProfileBloc` to fetch the data and the `ProfilePage` to display it safely.