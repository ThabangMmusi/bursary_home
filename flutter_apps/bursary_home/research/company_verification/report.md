# Research Report: Company Verification APIs (CIPC & SARS)

## Problem Statement

To enhance the integrity of the platform, we need a way to automatically verify the registration and tax status of bursary providers. This research investigates the feasibility of integrating with CIPC and SARS to achieve this.

## Key Findings

### CIPC (Companies and Intellectual Property Commission)

*   **Direct API:** A direct RESTful API exists, but the developer registration process is poorly documented and has been a point of frustration for many.
*   **Third-Party APIs:** Several third-party providers, such as **Datanamix** and **SearchWorks™**, offer developer-friendly APIs that simplify access to CIPC data. These services are more reliable and provide better support.

### SARS (South African Revenue Service)

*   **No Public API:** There is no public-facing API for real-time tax status checks.
*   **Formal B2B Integration:** Integration with SARS is a formal, complex process that requires registering as an Independent Software Vendor (ISV) and adhering to strict security protocols (VPN, SFTP, digital certificates).

## Conclusion

*   **SARS Integration:** Direct integration with SARS is not feasible for this project due to the high complexity and formal requirements.
*   **CIPC Integration:** Integration with CIPC is feasible and highly recommended. The most practical approach is to use a third-party API provider.

## Recommendation

Proceed with a plan to integrate a third-party CIPC API to verify the registration status of companies. This will be the most efficient and reliable way to implement the verification feature.
