# Plan: Architectural Refactor for Shared Data Layer

This plan details the architectural refactoring to create a shared data package containing both models and repositories. This will support code reuse for the upcoming provider app.

**Problem:** The `bursary_home_ui` package needs access to data models, and the future `provider_app` will need access to both models and data repositories that currently live inside the `student_app`.

**Solution:** Create a new, shared package (`data_layer`) to house all common models and repositories. `student_app`, `bursary_home_ui`, and the future `provider_app` will all depend on this new package.

---

### **Part 1: Create and Populate the Shared `data_layer` Package**

**Objective:** Establish a new package for shared models and repositories and move the relevant files into it.

1.  **Create the New Package:**
    *   In the parent directory, run the command:
        ```sh
        flutter create --template=package data_layer
        ```

2.  **Configure `pubspec.yaml` for `data_layer`:**
    *   Open `data_layer/pubspec.yaml`.
    *   Add necessary dependencies, such as `equatable`, `cloud_firestore`, and `firebase_auth`.
        ```yaml
        dependencies:
          equatable: ^2.0.5
          cloud_firestore: ^4.0.0 # Use relevant versions
          firebase_auth: ^4.0.0
        ```

3.  **Move Model Files:**
    *   Move the contents of `student_app/lib/data/models/` to `data_layer/lib/src/models/`.

4.  **Move Repository Files:**
    *   Move the contents of `student_app/lib/data/repositories/` to `data_layer/lib/src/repositories/`.

5.  **Create Public Export Files:**
    *   Create `data_layer/lib/models.dart` to export all models.
        ```dart
        export 'src/models/app_user.dart';
        export 'src/models/application_model.dart';
        export 'src/models/bursary_model.dart';
        ```
    *   Create `data_layer/lib/repositories.dart` to export all repositories.
        ```dart
        export 'src/repositories/application_repository.dart';
        export 'src/repositories/bursary_repository.dart';
        // Add other repositories as needed
        ```
    *   Create a main export file `data_layer/lib/data_layer.dart`.
        ```dart
        export 'models.dart';
        export 'repositories.dart';
        ```

---

### **Part 2: Update Project Dependencies and Imports**

**Objective:** Integrate the new `data_layer` package into the existing projects.

1.  **Update `student_app` Dependencies:**
    *   Open `student_app/pubspec.yaml`.
    *   Add a path dependency to `data_layer`:
        ```yaml
        dependencies:
          # ... other dependencies
          data_layer:
            path: ../data_layer
        ```

2.  **Update `bursary_home_ui` Dependencies:**
    *   Open `ui/bursary_home_ui/pubspec.yaml`.
    *   Add a path dependency to `data_layer`:
        ```yaml
        dependencies:
          # ... other dependencies
          data_layer:
            path: ../../data_layer # Adjust path as needed
        ```

3.  **Update All Imports:**
    *   Run a global search across both `student_app` and `ui/bursary_home_ui` for the old import paths (e.g., `package:student_app/data/models/` or `package:student_app/data/repositories/`).
    *   Replace them with the new, single import:
        ```dart
        import 'package:data_layer/data_layer.dart';
        ```

---

### **Part 3: Implement Originally Planned Features**

**Objective:** With the architecture fixed, proceed with the original plan.

1.  **Add `getBursary` Method to Repository:**
    *   This method will now be added to `data_layer/lib/src/repositories/bursary_repository.dart`.

2.  **Implement Application Status and Cancel Button in UI:**
    *   In `ui/bursary_home_ui/lib/widgets/bursary_card.dart`, implement the status `Chip` and the conditional "Cancel" button, importing the `ApplicationStatus` enum from the new `data_layer` package.

---

This updated plan provides a robust and scalable architecture. I will await your "code green" command to begin.