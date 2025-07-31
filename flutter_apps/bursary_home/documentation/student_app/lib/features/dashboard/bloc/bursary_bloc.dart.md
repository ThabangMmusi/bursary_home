# Purpose

This file defines the BLoC for the bursary feature.

# Functionality

This BLoC is responsible for loading and managing the list of bursaries. It communicates with the `BursaryRepository` to fetch the bursaries from Firestore.

# Changelog

- **Date:** 2025-07-31
  **Change:** Updated `_onLoadStudentDashboardBursaries` to fetch `totalEligibleBursariesCount`.
  **Purpose:** To provide an accurate total count of eligible bursaries for the dashboard header.
  **Functionality:** Calls `_bursaryRepository.getEligibleBursariesCount` and includes the result in the `BursaryState`.