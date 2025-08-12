# Provider Profile Refactor Plan Documentation

## Purpose
This document serves as the documentation for the 'Provider Profile Refactor' plan. It outlines the necessary changes to implement a dedicated profile creation and management flow for provider users, including the addition of company-specific details.

## Scope
This plan encompasses modifications to the `AppUser` model, `ProfileRepository`, `ProfileBloc`, and the UI for the "Complete Profile" page. Key changes include:
- Adding a `providerId` to the `AppUser` model.
- Implementing a `createProviderProfile` method in `ProfileRepository` to handle provider-specific data storage in Firestore.
- Extending `ProfileBloc` with new events and states to manage the provider profile submission process.
- Modifying the "Complete Profile" UI to conditionally display and capture company details based on user role.
- Integrating the `uuid` package for generating unique provider IDs.

## Changelog

### 2025-08-11
- **Initial Document Creation:** Created this documentation file based on the existing research report for the plan.
