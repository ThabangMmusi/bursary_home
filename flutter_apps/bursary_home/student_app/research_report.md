### Research Report: Bursary Matching Logic

**1. Current Implementation:**

The current matching logic is calculated as `bursary.gpa * 10`. This is a simplistic approach and does not accurately represent a "matching strength."

**2. Proposed Solution:**

I propose a new matching logic that takes into account the following factors:

*   **GPA:** The student's GPA will be compared to the bursary's required GPA. A student with a higher GPA than the required GPA will have a higher match score.
*   **Field of Study:** The student's field of study will be compared to the bursary's field of study. A student whose field of study matches the bursary's field of study will have a higher match score.
*   **Other Criteria:** I will investigate if there are other criteria that can be used to calculate the matching strength, such as demographics or financial need.

**3. Implementation Details:**

The new matching logic will be implemented in a new function called `calculateMatchScore`. This function will take a student and a bursary as input and return a match score between 0 and 100. The `BursaryCard` will be updated to display the new match score as a percentage.
