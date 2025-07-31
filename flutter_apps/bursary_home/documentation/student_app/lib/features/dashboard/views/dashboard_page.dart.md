# Purpose

This file defines the UI for the dashboard page.

# Functionality

This file displays the main dashboard for the student app. It includes a list of available bursaries and a summary of the user's applications.

# Changelog

- **Date:** 2025-07-31
  **Change:** Updated `DashboardHeaderWidget` usage and "See all" button visibility.
  **Purpose:** To display accurate total eligible bursary count and conditionally show the "See all" button.
  **Functionality:** Passes `totalEligibleBursariesCount` and `bursariesDisplayedCount` to `DashboardHeaderWidget` and wraps the "See all" button with a conditional check.