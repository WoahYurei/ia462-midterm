
# IA 462 Midterm
**Mark Bowen**  
**Advanced Operating Systems Security & Administration**  
**Fall 2026**

## 1. Repository Overview

This repository demonstrates operating system hardening, vulnerability management, policy enforcement, and software supply-chain security across Linux, Windows, and Docker environments. The project includes a containerized Python Flask application, operating system security configurations, vulnerability scan reports, a Software Bill of Materials (SBOM), and a Sigma detection rule. GitHub Actions, Dependabot, dependency pinning, and automated vulnerability scanning are used to identify security risks and reduce the likelihood of vulnerable dependencies being introduced into the application.

## 2. Cross-Platform Hardening Comparison

| Category | Linux | Windows | Docker |
|---|---|---|---|
| Kernel Model | Monolithic Linux kernel with loadable modules | Windows NT hybrid kernel | Shares the underlying Linux kernel through container isolation |
| Access Control | Unix permissions, PAM, sudo, SELinux and AppArmor | NTFS permissions, ACLs, UAC and Group Policy | Namespaces, Linux capabilities, non-root users and seccomp |
| Auditing | auditd, journald and osquery | Windows Event Logs, Advanced Audit Policy and Sysmon | Container logs, Docker events and host-level auditing |
| Hardening Standard | CIS Linux Benchmarks and DISA STIGs | CIS Windows Benchmarks and DISA STIGs | CIS Docker Benchmark |
| Common Attack Surface | SSH, vulnerable packages, exposed services and privilege escalation | PowerShell abuse, credential attacks, malicious services and vulnerable applications | Vulnerable images, excessive privileges, exposed ports and malicious dependencies |

Although Linux, Windows, and Docker use different security mechanisms, all three benefit from least privilege, secure configurations, vulnerability management, and continuous monitoring. Docker differs from a traditional operating system because its containers share the underlying kernel, making runtime restrictions and host security especially important. Applying multiple security controls across these environments provides defense in depth.

## 3. Supply-Chain Threat Model

An attacker targeting this repository could attempt to compromise application dependencies, container images, GitHub Actions, or the application runtime. The following controls were implemented to reduce these risks.

| Potential Attack | Implemented Security Control |
|---|---|
| Introducing a known-vulnerable Python dependency | Dependency Review and pip-audit identify vulnerable dependencies and fail the associated security checks. |
| Unexpected dependency version changes | Exact dependency pins prevent automatic version changes during installation. |
| Tampering with downloaded Python packages | SHA-256 hashes in requirements.lock and pip's require-hashes option verify package integrity. |
| Replacing a trusted Docker base image | Digest pinning ensures that the build references a specific base image. |
| Compromising a mutable GitHub Action version tag | Full commit SHA pinning prevents unexpected changes to the referenced action version. |
| Exploiting known container package vulnerabilities | Trivy and Grype identify vulnerable packages and provide information for remediation. |
| Concealing vulnerable or outdated dependencies | Syft generates an SPDX SBOM that provides visibility into the image's software inventory. |
| Exploiting excessive container privileges | Non-root execution, dropped capabilities, no-new-privileges, a read-only filesystem, and a focused seccomp profile reduce runtime privileges and attack opportunities. |
| Exploiting outdated dependencies over time | Dependabot monitors dependencies and proposes updates. |

The effectiveness of the dependency security checks was demonstrated by intentionally downgrading Flask from version 3.1.3 to version 2.0.0 in a temporary pull request. Both Dependency Review and pip-audit failed after detecting the vulnerable dependency. The pull request was closed without merging, preserving the audited dependency versions on the main branch.

These controls reduce supply-chain risk but do not eliminate it entirely. Trivy was configured to report vulnerabilities rather than fail the pipeline, and the focused seccomp profile was tested successfully without establishing absolute syscall minimality. Mandatory branch protection would further strengthen enforcement of the failed dependency checks.

### Relevant Course Lecture Decks

- Week 4 — System Administration & Policy for Docker, Windows & Linux
- Week 5 — Security Analysis & Threat Intelligence
- Week 6 — Docker Containers & Virtualization
- Week 7 — Enterprise Policy Management for Docker, Windows & Linux
- Week 8 — Dependency Management & Version Control for GitHub

## 4. Course Learning Objective Crosswalk

- **Section 1 — Linux Hardening:** Demonstrates Linux security best practices through operating system hardening and security configuration. Supports the objective of implementing Windows and Linux best practices to protect against supply-chain attacks.

- **Section 2 — Windows Security:** Demonstrates Windows security configuration, auditing, and event analysis. Supports the objective of utilizing supply-chain security techniques across Windows, Linux, and Docker environments by establishing host-level defensive controls.

- **Section 3 — Docker Hardening:** Demonstrates container policy management through multi-stage builds, non-root execution, daemon configuration, capability restrictions, and seccomp filtering. Supports the objective of applying enterprise patch and policy management for Docker containers, including container hardening.

- **Section 4 — Vulnerability Management:** Demonstrates vulnerability identification using Trivy and Grype, SBOM generation using Syft, and vulnerability research using NVD and MITRE ATT&CK. Supports the objectives of integrating SBOMs into Docker workflows and performing vulnerability management.

- **Section 5 — Policy Enforcement:** Demonstrates security auditing through Docker Bench Security and Windows threat detection through a Sigma rule. Supports the objectives of container policy management and implementing cross-platform security best practices.

- **Section 6 — Dependency Management:** Demonstrates dependency pinning, hashed lock files, version control, Dependabot, and automated dependency review. Supports the objective of applying dependency pinning, version control, and hashing to reduce supply-chain attacks.

- **Section 6 — CI/CD Security:** Demonstrates the integration of Trivy, Syft, and pip-audit into GitHub Actions. Supports the objective of configuring and managing third-party security scanners within a GitHub CI/CD pipeline. Updating and reauditing vulnerable Python dependencies also demonstrates the scan, patch, and retest vulnerability management process.

## References

- IA 462 — Advanced Operating Systems Security & Administration, Fall 2026 Course Syllabus.
- IA 462 — Week 4 through Week 8 lecture deck titles, as listed in the course syllabus.
- CIS Benchmarks: https://www.cisecurity.org/cis-benchmarks
- MITRE ATT&CK: https://attack.mitre.org/
- National Vulnerability Database: https://nvd.nist.gov/
- GitHub Documentation: https://docs.github.com/
