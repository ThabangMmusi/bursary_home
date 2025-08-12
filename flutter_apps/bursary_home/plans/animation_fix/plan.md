# Plan: Fix Animation

## Phase 1: Research and Investigation

*   [x] **Step 1.1:** Identified the problematic animation: login animation in `auth_layout.dart`.
*   [x] **Step 1.2:** Analyzed the code related to the animation.
*   [x] **Step 1.3:** Formulated a detailed plan for the fix.

## Phase 2: Implementation

*   [x] **Step 2.1:** Implemented the planned fix (added ThemeColors extension to providerTheme).

## Phase 3: Verification

    *   [x] **Step 3.1:** Tested the animation and confirmed it is working as expected.
        *   [x] **Step 3.1.5:** Adjusted App Bar and Logo animation to slide up/down from off-screen.
        *   [x] **Step 3.1.6:** Adjusted App Bar animation duration.
        *   [ ] **Step 3.1.7:** Remove fading from App Bar and Logo animations. (Reverted AnimatedSwitcher)
        *   [ ] **Step 3.1.8:** Adjust App Bar animation reverse duration. (Reverted AnimatedSwitcher)
        *   [ ] **Step 3.1.9:** Implement combined animation for App Bar and Logo. (Reverted Combined Animation)
        *   [ ] **Step 3.1.12:** Adjusted App Bar animation duration for 'coming back'.
        *   [x] **Step 3.1.13:** Re-implemented App Bar and Logo animations using AnimatedSwitcher with specified durations.
        *   [ ] **Step 3.1.14:** Implement text change during reverse animation for App Bar and Logo.
        *   [x] **Step 3.1.15:** Implemented sequential animation (old slides off, then new slides on).
        *   [x] **Step 3.1.16:** Adjusted App Bar top position.
        *   [x] **Step 3.1.17:** Adjusted Logo top position for animation.
        *   [x] **Step 3.1.18:** Adjusted Main Image animation for sequential appearance and speed.
        *   [x] **Step 3.1.19:** Adjusted Main Image Tween range for complete disappearance (changed to -1.5).
        *   [x] **Step 3.1.20:** Re-adjusted Logo top position for animation.
        *   [ ] **Step 3.1.8:** Adjust App Bar animation reverse duration. (Reverted AnimatedSwitcher)
        *   [x] **Step 3.1.9:** Implemented combined animation for App Bar and Logo.
    *   [x] **Step 3.1.1:** Modified AnimatedSwitcher transition to slide from/to left (corrected large screen).
    *   [x] **Step 3.1.2:** Animated App Bar (Login Text) position (using AnimatedSwitcher).
    *   [x] **Step 3.1.3:** Animated Logo position (using AnimatedSwitcher).
    *   [x] **Step 3.1.4:** Animated Books Image position (using AnimatedPositioned).
    *   [x] **Step 3.1.3:** Animated Logo position.
    *   [ ] **Step 3.1.4:** Animate Books Image position.
*   [ ] **Step 3.2:** Create a restore point (commit) after verification.