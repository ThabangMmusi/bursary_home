# Project Structure

This document outlines the structure of the `lib` and `assets` folders within the project.

## `lib` Folder Structure

```
lib/
├── firebase_options.dart
├── main.dart
├── core/
│   └── routes/
│       └── app_router.dart
├── data/
│   ├── models/
│   │   ├── app_user.dart
│   │   ├── bursary_model.dart
│   │   ├── profile_model.dart
│   │   └── subject_model.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── bursary_repository.dart
│       ├── profile_repository.dart
│       └── application_repository.dart
├── features/
│   ├── applications/
│   │   ├── bloc/
│   │   │   ├── applications_bloc.dart
│   │   │   ├── applications_event.dart
│   │   │   └── applications_state.dart
│   │   └── views/
│   │       └── applications_page.dart
│   ├── auth/
│   │   ├── bloc/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   └── views/
│   │       ├── login_page.dart
│   │       └── signup_page.dart
│   ├── dashboard/
│   │   ├── bloc/
│   │   │   ├── bursary_bloc.dart
│   │   │   ├── bursary_event.dart
│   │   │   └── bursary_state.dart
│   │   └── views/
│   │       ├── bursary_details_page.dart
│   │       └── dashboard_page.dart
│   │   └── widgets/
│   │       └── side_menu.dart
│   ├── profile/
│   │   ├── bloc/
│   │   │   ├── complete_profile_bloc.dart
│   │   │   ├── complete_profile_event.dart
│   │   │   ├── complete_profile_state.dart
│   │   │   ├── document_upload_bloc.dart
│   │   │   ├── document_upload_event.dart
│   │   │   ├── document_upload_state.dart
│   │   │   ├── profile_bloc.dart
│   │   │   ├── profile_event.dart
│   │   │   └── profile_state.dart
│   │   ├── presentation/
│   │   │   └── pages/
│   │   │       ├── complete_profile_page.dart
│   │   │       └── confirmation_page.dart
│   │   │   └── widgets/
│   │   │       ├── academic_details_form.dart
│   │   │       ├── personal_details_card.dart
│   │   │       └── subject_entry_widget.dart
│   │   └── views/
│   │       └── profile_page.dart
```

## `assets` Folder Structure

```
assets/
├── images/
│   ├── bell.png
│   ├── books.png
│   ├── boy white.png
│   ├── Bursary_Logo.svg
│   ├── logo.png
│   ├── school_desk.png
│   ├── school_student.png
│   └── students.png
```
