# Purpose

This file defines the UI for the all bursaries page.

# Functionality

This file displays a grid of all eligible bursaries. It uses the `BursaryBloc` to get the list of bursaries and the `BursaryCard` widget to display each bursary.

# Changelog

- **Date:** 2025-07-31
  **Change:** Implemented "Apply Now" functionality and `BursaryDetailsPage` integration.
  **Purpose:** To allow users to apply for bursaries and view details directly from the "All Bursaries" page.
  **Functionality:** Added `BlocListener` for `ApplicationsBloc` feedback, updated `onApplyPressed` to dispatch `ApplyForBursary`, and `onViewDetailsPressed` to show `BursaryDetailsPage`.