# Requirements Document

## Introduction

A professional, SEO-optimized README.md for a GitHub repository that teaches AWS, Terraform, and DevOps through daily hands-on projects. The README serves as the primary landing page for students, job seekers, and developers who want to learn Terraform and AWS, pass HashiCorp and AWS certifications, and follow along with structured daily projects. It must be visually impressive, badge-rich, and discoverable via Google search.

## Glossary

- **README**: The root-level `README.md` file rendered by GitHub as the repository's homepage
- **Badge**: A shields.io or similar inline image conveying status, technology, or social metadata
- **Day_Folder**: A directory named `DayN_<Topic>` containing one self-contained Terraform + AWS project
- **Visitor**: Any person who lands on the repository page (student, recruiter, developer)
- **Author**: The repository owner (Upasana Tailor)
- **Certification**: HashiCorp Terraform Associate or AWS certification exams

---

## Requirements

### Requirement 1: Hero Section with Branding

**User Story:** As a Visitor, I want to see a visually striking header with the project logo and title, so that I immediately understand what the repository is about.

#### Acceptance Criteria

1. THE README SHALL display the logo image located at `Images/logo.jpeg` as a centered banner at the top of the document
2. THE README SHALL include a centered, prominent repository title below the logo
3. THE README SHALL include a concise tagline describing the daily Terraform + AWS project structure
4. THE README SHALL render the hero section using HTML centering tags so it displays correctly on GitHub

---

### Requirement 2: Technology Badges

**User Story:** As a Visitor, I want to see technology and status badges at a glance, so that I can quickly identify the tools, languages, and platforms used.

#### Acceptance Criteria

1. THE README SHALL include a shields.io badge for Terraform
2. THE README SHALL include a shields.io badge for AWS
3. THE README SHALL include a shields.io badge for HashiCorp
4. THE README SHALL include a shields.io badge indicating the license type
5. THE README SHALL include a shields.io badge showing the repository star count
6. THE README SHALL include a shields.io badge showing the repository fork count
7. THE README SHALL include a shields.io badge showing the last commit date
8. THE README SHALL render all badges in a single centered row beneath the title

---

### Requirement 3: What is Terraform Section

**User Story:** As a Visitor who is new to Terraform, I want a clear explanation of what Terraform is, so that I understand the tool before diving into projects.

#### Acceptance Criteria

1. THE README SHALL include a dedicated section titled "What is Terraform?"
2. THE README SHALL explain Terraform as an open-source Infrastructure as Code (IaC) tool by HashiCorp
3. THE README SHALL describe Terraform's core workflow (Write → Plan → Apply)
4. THE README SHALL mention that Terraform supports multiple cloud providers including AWS
5. THE README SHALL include the `Images/terraform_archi.webp` architecture image to visually support the explanation

---

### Requirement 4: What is AWS Section

**User Story:** As a Visitor who is new to AWS, I want a clear explanation of what AWS is, so that I understand the cloud platform used in the projects.

#### Acceptance Criteria

1. THE README SHALL include a dedicated section titled "What is AWS?"
2. THE README SHALL describe AWS as Amazon's cloud computing platform offering on-demand infrastructure services
3. THE README SHALL mention key AWS service categories relevant to the projects (compute, networking, storage, security)

---

### Requirement 5: Repository Purpose and Learning Goals

**User Story:** As a student, I want to understand what I will learn from this repository, so that I can decide whether it matches my learning goals.

#### Acceptance Criteria

1. THE README SHALL include a section describing the purpose of the repository
2. THE README SHALL state that each Day_Folder contains one complete, hands-on Terraform + AWS project
3. THE README SHALL list the learning outcomes: Terraform proficiency, AWS service knowledge, DevOps practices, and certification readiness
4. THE README SHALL mention that the content helps prepare for HashiCorp Terraform Associate and AWS certifications

---

### Requirement 6: Project Index / Daily Projects Table

**User Story:** As a student, I want a structured table of all daily projects, so that I can navigate directly to the topic I want to study.

#### Acceptance Criteria

1. THE README SHALL include a section titled "Daily Projects" or equivalent
2. THE README SHALL render a Markdown table with columns: Day, Topic, Key Concepts, and a link to the folder
3. THE README SHALL include a row for Day 2 (VPC Networking) linking to `Day2_VPC_Networking/`
4. THE README SHALL include a row for Day 3 (Variables, Validation & Locals) linking to `Day3_Variables-Validation_locals/`
5. WHEN new Day_Folders are added to the repository, THE README table SHALL be updated to include them
6. THE README SHALL include a note instructing contributors to update the table when adding new days

---

### Requirement 7: How to Use / Getting Started Section

**User Story:** As a student, I want clear instructions on how to clone and use the repository, so that I can start working on projects immediately.

#### Acceptance Criteria

1. THE README SHALL include a "Getting Started" or "How to Use" section
2. THE README SHALL provide a `git clone` command for the repository: `https://github.com/upasanatailor/AWS_Terraform_Projects`
3. THE README SHALL list prerequisites: Terraform CLI, AWS CLI, and an AWS account with credentials configured
4. THE README SHALL describe the steps to navigate into a Day_Folder and run `terraform init`, `terraform plan`, and `terraform apply`
5. THE README SHALL include a note about forking the repository for personal use

---

### Requirement 8: Certification Resources Section

**User Story:** As a student preparing for certifications, I want links and guidance on relevant certifications, so that I know how this repo supports my exam preparation.

#### Acceptance Criteria

1. THE README SHALL include a section referencing HashiCorp Terraform Associate certification
2. THE README SHALL include a section referencing AWS certifications (e.g., AWS Solutions Architect, AWS DevOps Engineer)
3. THE README SHALL describe how the daily projects map to certification exam topics

---

### Requirement 9: Author and Social Links Section

**User Story:** As a Visitor, I want to find the Author's social profiles and contact information, so that I can follow their content and reach out for questions.

#### Acceptance Criteria

1. THE README SHALL include a section with the Author's name: Upasana Tailor
2. THE README SHALL include a clickable badge or link to LinkedIn: `https://www.linkedin.com/in/upasana-tailor-b24539152/`
3. THE README SHALL include a clickable badge or link to GitHub: `https://github.com/upasanatailor`
4. THE README SHALL include a clickable badge or link to Telegram: `https://t.me/prodevopsguy`
5. THE README SHALL include a clickable badge or link to Dev.to: `https://dev.to/notharshhaa`
6. THE README SHALL include a clickable badge or link to Hashnode: `https://hashnode.com/@prodevopsguy`
7. THE README SHALL include a clickable badge or link to YouTube: `https://www.youtube.com/@CloudKaro`
8. THE README SHALL render social links as shields.io badges for visual consistency

---

### Requirement 10: Support / Community Banner

**User Story:** As a Visitor, I want to see a community or support call-to-action, so that I know how to engage with the project's community.

#### Acceptance Criteria

1. THE README SHALL display the `Images/devops.png` banner in a support or community section
2. THE README SHALL include a call-to-action encouraging Visitors to star, fork, and share the repository
3. THE README SHALL include a call-to-action directing Visitors to the Author's YouTube channel for video tutorials

---

### Requirement 11: SEO Optimization

**User Story:** As the Author, I want the README to be discoverable via Google search, so that more students find the repository organically.

#### Acceptance Criteria

1. THE README SHALL include relevant keywords in the title and description: "Terraform", "AWS", "DevOps", "Infrastructure as Code", "IaC", "HashiCorp", "daily projects", "hands-on", "certification"
2. THE README SHALL use descriptive alt text on all images
3. THE README SHALL use descriptive link text rather than raw URLs for all hyperlinks
4. THE README SHALL include a Topics/Keywords section or embed keywords naturally in section headings and body text

---

### Requirement 12: Fork and Contribution Guidance

**User Story:** As a developer, I want clear instructions on how to fork and contribute to the repository, so that I can use it as a template for my own learning.

#### Acceptance Criteria

1. THE README SHALL include a section explaining how to fork the repository on GitHub
2. THE README SHALL include a brief contribution guide encouraging pull requests for new daily projects
3. THE README SHALL include a note about the MIT license governing reuse of the content
