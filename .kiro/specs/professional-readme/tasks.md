# Implementation Plan: Professional README

## Overview

Write a single `README.md` at the repository root that satisfies all 12 requirements. The file is a static Markdown document — no build step required. Tasks follow the 10-section structure defined in the design document.

## Tasks

- [x] 1. Write the README.md hero section
  - Create `README.md` with the centered hero block: logo image, H1 title, tagline, and badge row
  - Use HTML `<div align="center">` for centering
  - Include all 7 shields.io badges (Terraform, AWS, HashiCorp, License, Stars, Forks, Last Commit)
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8_

- [x] 2. Add educational sections (Terraform + AWS)
  - [x] 2.1 Write the "What is Terraform?" section
    - Include H2 heading, explanation, Write→Plan→Apply workflow, architecture image, and key concepts list
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

  - [ ]* 2.2 Write property test for Terraform section content
    - **Property 2: All required AWS service categories are mentioned**
    - **Validates: Requirements 4.3**

  - [x] 2.3 Write the "What is AWS?" section
    - Include H2 heading, explanation, and bullet list of service categories (Compute, Networking, Storage, Security)
    - _Requirements: 4.1, 4.2, 4.3_

- [x] 3. Add About This Repository section
  - Write purpose statement and learning outcomes bullet list covering Terraform proficiency, AWS knowledge, DevOps practices, and certification readiness
  - _Requirements: 5.1, 5.2, 5.3, 5.4_

- [x] 4. Add Daily Projects table
  - [x] 4.1 Write the project index table with Day, Topic, Key Concepts, and Folder link columns
    - Include rows for Day 2 (VPC Networking) and Day 3 (Variables, Validation & Locals)
    - Include contributor maintenance note below the table
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6_

  - [ ]* 4.2 Write property test for project table structure
    - **Property 4: Project table has required columns**
    - **Validates: Requirements 6.2**

- [x] 5. Add Getting Started section
  - [x] 5.1 Write prerequisites subsection and step-by-step clone/run instructions
    - Include `git clone` command, `cd`, `terraform init`, `terraform plan`, `terraform apply` in fenced bash code blocks
    - Include fork note
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_

  - [ ]* 5.2 Write property tests for Getting Started section
    - **Property 5: Prerequisites are all listed**
    - **Property 6: All Terraform workflow commands are present**
    - **Validates: Requirements 7.3, 7.4**

- [x] 6. Add Certification Resources section
  - Write HashiCorp Terraform Associate and AWS certification subsections with links and exam-topic mapping note
  - _Requirements: 8.1, 8.2, 8.3_

- [x] 7. Add Author & Connect section
  - Write author bio for Upasana Tailor with centered LinkedIn, GitHub, and YouTube shields.io badge links
  - Do NOT include Telegram, Dev.to, or Hashnode links
  - _Requirements: 9.1, 9.2, 9.3, 9.7, 9.8_

- [x] 8. Add Community & Support section
  - Include centered `Images/devops.png` banner, star/fork CTA, and YouTube channel CTA
  - _Requirements: 10.1, 10.2, 10.3_

- [x] 9. Add Contributing section
  - Write fork instructions, contribution guidelines, and MIT license note
  - _Requirements: 12.1, 12.2, 12.3_

- [x] 10. Checkpoint — verify SEO keywords and image alt text
  - Confirm all 8 required SEO keywords appear in the document
  - Confirm all images have non-empty descriptive alt text
  - Confirm no raw URLs are used as link text
  - _Requirements: 11.1, 11.2, 11.3, 11.4_

- [x] 11. Final checkpoint — Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Property tests validate universal correctness properties defined in the design document
