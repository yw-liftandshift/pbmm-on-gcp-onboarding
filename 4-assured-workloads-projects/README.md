# Assured Workloads Projects

This repo is part of a multi-part guide that shows how to configure and deploy
the example.com reference architecture described in
[Google Cloud security foundations guide](https://cloud.google.com/architecture/security-foundations). The following table lists the parts of the guide.

This repo is used to create a Protected B Medium-Medium (PBMM) compliant Landing Zone on Google Cloud. 

The `4-assured-workloads-projects` folder proposes a simple project factory creating either a folder or a Data Boundary powered by Assured Workloads depending on the classification of the data. 

## About Data Boundary powered by Assured Workloads

[Assured Workloads](https://cloud.google.com/assured-workloads) is a service that allows you to create and manage controlled environments that enforce specific compliance requirements for your Google Cloud workloads. For this PBMM Landing Zone, it is used to create a data boundary for workloads that handle Protected B data.

When you create an Assured Workloads environment for a compliance regime like `CA_PROTECTED_B`, Google Cloud ensures that the services and resources within that environment adhere to the controls required by that standard. This includes:

*   **Data Residency:** Enforces that customer data is stored and processed only within the specified geographic location (in this case, Canada).
*   **Personnel Access Controls:** Limits Google support and administrative access to personnel who meet the requirements for that compliance regime.
*   **Service Constraints:** Restricts the use of Google Cloud services to only those that are compliant with the specified regime.

In this project factory, an Assured Workloads environment is configured to create a special folder. Projects created through the factory are placed into either a standard "unclassified" folder or the Protected B Assured Workloads folder, based on their `data_classification` metadata. This ensures that any project intended to handle Protected B data automatically inherits the necessary security controls and compliance guardrails.

## Assigning groups

To be able to add gorups, add projects service account to Goups Editor on workspace. 

 ## Sample Architecture

    