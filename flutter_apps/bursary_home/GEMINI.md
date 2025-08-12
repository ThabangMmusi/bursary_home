# Gemini CLI Agent Rules

## New Rule: Verify Step

When a task requires verification, the following process should be followed:

1.  **Research:** Thoroughly research the relevant code, documentation, or external resources.
2.  **Research Report:** Create a `research_report.md` file detailing the findings of the research. This report should include:
    *   Problem statement/area of investigation.
    *   Key findings and relevant information.
    *   Potential solutions or approaches.
    *   Any uncertainties or areas requiring further clarification.
3.  **Verification:** Based on the research, proceed with the verification steps for the task.

## New Rule: Documentation

1.  **Documentation First:** Before making any code changes, you must first consult the relevant file in the `documentation` folder to understand its context and history.
2.  **Changelog Maintenance:** After successfully modifying any file, you must immediately update its corresponding documentation file's "Changelog" section. This entry will detail the purpose of the change and the specific functionality that was altered.
3.  **Informed Suggestions:** You will leverage the entire `documentation` folder to provide more accurate, context-aware suggestions and to ensure you are following the established architectural and functional paths of the project.

## New Rule: Development Workflow

1.  **Documentation Update:** Every time any file is updated, its corresponding documentation must also be updated.
2.  **Research Existing Implementations:** Before coding, always research existing implementations to understand context and conventions.
3.  **Plan Review:** Review the plan thoroughly before starting any coding.
4.  **Phased and Step-by-Step Coding:** Code development will proceed phase by phase, and within each phase, step by step.
5.  **User Approval:** All phases and individual steps require explicit user approval before coding commences.
6.  **Dynamic Plan Updates:** The plan will be updated with actual steps and progress whenever a step is fixed or new information from research becomes available.
7.  **Research-Driven Planning:** Plans must be thoroughly researched before implementation.
8.  **Restore Point:** After every accomplished plan, a restore point (Git commit) must be created.
9.  **Plan Directory:** All plans must be created under the `plans` directory, adhering to the existing structure.
