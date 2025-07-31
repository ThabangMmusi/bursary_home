# Purpose

This file defines the repository for managing bursary data.

# Functionality

This repository provides methods for fetching bursaries from Firestore, including methods to load bursaries for the dashboard and all eligible bursaries with pagination.

# Changelog

- **Date:** 2025-07-31
  **Change:** Refactored `getBursariesByGpa` into `loadStudentDashboardBursaries` and `loadStudentBursaries`.
  **Purpose:** To implement efficient loading of limited bursaries for the dashboard and paginated loading for the "See All" page.
  **Functionality:** Introduced `_getExcludedBursaryIds` for filtering, and `getEligibleBursariesCount` for total count.