# Plan: Refactor Provider Profile Creation

## Objective

To refactor the "Complete Profile" flow for users with the "Provider" role. This involves creating a new `providers` collection in Firestore, generating a unique ID for each provider, and updating the `AppUser` model.

---

### **Phase 1: Data Layer & Repository**

1.  **Rename and Update `Company` Model:**
    *   Rename the file `data_layer/lib/src/models/company_model.dart` to `data_layer/lib/src/models/provider_model.dart`.
    *   In the newly renamed file, rename the class `Company` to `Provider`.
    *   Add `registrationNumber` and `taxNumber` fields of type `String?` to the `Provider` class.
    *   Update the `copyWith`, `fromFirestore`, `toFirestore` methods, and the `props` getter to include the new fields.

2.  **Add `uuid` Dependency:** Add `uuid: ^4.3.0` to the `dependencies` section of `student_app/pubspec.yaml`.

3.  **Update `AppUser` Model:**
    *   In `data_layer/lib/src/models/app_user.dart`, add a `providerId` field of type `String?` to the `AppUser` class.
    *   Update the `copyWith`, `fromFirestore`, `toFirestore` methods, and the `props` getter to include the new `providerId` field.

4.  **Update `ProfileRepository`:**
    *   In `data_layer/lib/src/repositories/profile_repository.dart`, add a new method `createProviderProfile(String userId, String name, String surname, String companyName, String registrationNumber, String taxNumber)`.
    *   This method will:
        *   Import the `uuid` package.
        *   Generate a new `providerId` using `Uuid().v4()`.
        *   Update the user's document in the `users` collection with `name`, `surname`, `isVerified: false`, and the new `providerId`.
        *   Create a new document in the `providers` collection with the generated `providerId` and the `companyName`.
        *   Create a `details` document in the `providers/{providerId}/more` sub-collection with the `registrationNumber` and `taxNumber`.

---

### **Phase 2: State Management (BLoC)**

1.  **Update `ProfileBloc` Events:**
    *   In `student_app/lib/features/profile/bloc/profile_event.dart`, create a new event `ProviderProfileSubmitted` with properties for `name`, `surname`, `companyName`, `registrationNumber`, and `taxNumber`.

2.  **Update `ProfileBloc` States:**
    *   In `student_app/lib/features/profile/bloc/profile_state.dart`, add new statuses to the `ProfileStatus` enum: `providerProfileSubmissionLoading`, `providerProfileSubmissionSuccess`, and `providerProfileSubmissionFailure`.

3.  **Update `ProfileBloc`:**
    *   In `student_app/lib/features/profile/bloc/profile_bloc.dart`, add a handler for the `ProviderProfileSubmitted` event.
    *   This handler will call the `createProviderProfile` method from the `ProfileRepository` and emit the new states accordingly.

---

### **Phase 3: UI Implementation**

1.  **Create `CompanyDetailsForm` Widget:**
    *   Create a new file `student_app/lib/features/profile/presentation/widgets/company_details_form.dart`.
    *   This widget will be a `StatelessWidget` that contains `TextFormField`s for "Company Name", "Registration No", and "Tax Number".

2.  **Update `CompleteProfileEvent`:**
    *   In `student_app/lib/features/profile/bloc/complete_profile_event.dart`, add a new event `ProviderProfileSubmitted` with properties for `name`, `surname`, `companyName`, `registrationNumber`, and `taxNumber`.

3.  **Update `CompleteProfileState`:**
    *   In `student_app/lib/features/profile/bloc/complete_profile_state.dart`, add a new property `userRole` of type `String?`.

4.  **Update `CompleteProfileBloc`:**
    *   Inject the `AppBloc` into the `CompleteProfileBloc` to get the user's role.
    *   In the constructor, get the user's role from the `AppBloc` and store it in the state.
    *   Add a handler for the `ProviderProfileSubmitted` event. This handler will call the `createProviderProfile` method from the `ProfileRepository`.
    *   Modify the existing `FormSubmitted` handler to only handle student profile submissions.

5.  **Modify `ProfileForm` Widget:**
    *   In `student_app/lib/features/profile/presentation/widgets/profile_form.dart`, use the `userRole` from the `CompleteProfileState` to conditionally display the `CompanyDetailsForm`.
    *   Instantiate the `TextEditingController`s for the `CompanyDetailsForm`.
    *   Update the "Submit" button to dispatch the correct event (`FormSubmitted` or `ProviderProfileSubmitted`) based on the user's role.
