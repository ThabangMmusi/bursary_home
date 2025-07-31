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
