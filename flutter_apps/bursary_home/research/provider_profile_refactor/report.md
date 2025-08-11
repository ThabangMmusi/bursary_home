# Research Report: Provider Profile Refactor

## 1. `uuid` Package

*   **Objective:** Verify if the `uuid` package is available and determine how to use it.
*   **Findings:** The `uuid` package is not listed as a dependency in the `student_app/pubspec.yaml` file. The latest version is `^4.3.0`.
*   **Conclusion:** The `uuid` package needs to be added to the `pubspec.yaml` file. The `uuid.v4()` method will be used to generate a unique ID.

## 2. `AppUser` Model

*   **Objective:** Understand the structure of the `AppUser` model.
*   **Findings:** The `AppUser` class is defined in `data_layer/lib/src/models/app_user.dart`. It has fields for `id`, `email`, `name`, `surname`, `photo`, `gpa`, and `hasCompletedProfile`.
*   **Conclusion:** A `providerId` field of type `String?` will be added to the `AppUser` class, its `copyWith` method, `fromFirestore` factory, `toFirestore` method, and the `props` getter.

## 3. `ProfileRepository`

*   **Objective:** Understand the existing `ProfileRepository` implementation.
*   **Findings:** The `ProfileRepository` in `data_layer/lib/src/repositories/profile_repository.dart` currently handles user profile operations. It has methods like `getProfile`, `createProfile`, and `updateProfile`.
*   **Conclusion:** A new method `createProviderProfile` will be added to this repository. This method will take `userId`, `name`, `surname`, `companyName`, `registrationNumber`, and `taxNumber` as arguments. It will then perform the following actions:
    1.  Generate a new `providerId` using the `uuid` package.
    2.  Update the user's document in the `users` collection with the `name`, `surname`, `isVerified: false`, and the new `providerId`.
    3.  Create a new document in the `providers` collection with the generated `providerId` and the `companyName`.
    4.  Create a `details` document in the `providers/{providerId}/more` sub-collection with the `registrationNumber` and `taxNumber`.

## 4. `ProfileBloc`

*   **Objective:** Understand the existing `ProfileBloc` implementation.
*   **Findings:** The `ProfileBloc` is responsible for managing the profile state. It currently handles loading and updating a user's profile.
*   **Conclusion:** The following changes will be made:
    *   **`profile_event.dart`:** A new event `ProviderProfileSubmitted` will be created with properties for `name`, `surname`, `companyName`, `registrationNumber`, and `taxNumber`.
    *   **`profile_state.dart`:** New statuses will be added to the `ProfileStatus` enum: `providerProfileSubmissionLoading`, `providerProfileSubmissionSuccess`, and `providerProfileSubmissionFailure`.
    *   **`profile_bloc.dart`:** A handler will be added for the `ProviderProfileSubmitted` event. This handler will call the `createProviderProfile` method from the `ProfileRepository` and emit the new states accordingly.

## 5. UI Implementation

*   **Objective:** Understand the existing UI for the "Complete Profile" page.
*   **Findings:**
    *   `complete_profile_page.dart` is the main page for the "Complete Profile" flow. It uses a `BlocListener` to listen for state changes from `CompleteProfileBloc` and displays a `ProfileForm` widget.
    *   `profile_form.dart` contains the actual form fields. It's currently set up for academic details and has a `PersonalDetailsCard`.
*   **Conclusion:**
    *   A new widget `CompanyDetailsForm` will be created. This widget will contain `TextFormField`s for "Company Name", "Registration No", and "Tax Number".
    *   `profile_form.dart` will be modified to conditionally show the `CompanyDetailsForm` based on the user's role.
    *   The `PersonalDetailsCard` will be used for the user's name and surname.
    *   The "Submit" button in `profile_form.dart` will be updated to trigger the `ProviderProfileSubmitted` event in the `ProfileBloc` with the data from both the `PersonalDetailsCard` and the `CompanyDetailsForm`.
