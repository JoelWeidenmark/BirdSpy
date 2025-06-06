# Copilot Instructions for BirdSpy Project

## Project Management and Documentation Guidelines

### Planning and Goal Management
- Always keep the plan in `PROJECT_GOALS.md` and `MVP_PLAN.md` in mind when making any changes or suggestions
- If you need to change the plan, always update the corresponding MD files to reflect the new plan
- Ensure all project decisions align with the documented goals and MVP requirements

### Project Documentation
- Always add an MD file to the root of each sub-project containing:
  - What the project does
  - How it works
  - Key components and architecture
  - Setup and usage instructions
- This documentation should be comprehensive enough for an AI agent to understand the project structure and purpose

### External Project Handling
- **Do not make big changes to the `bird-analyzer` project** - this is an external project that we don't have deep insight into
- Only make minimal, necessary configuration changes to integrate it with the BirdSpy system
- When working with bird-analyzer, focus on understanding its API and interfaces rather than modifying its internal code

### Documentation Maintenance
- Always update all relevant MD files when making changes to:
  - Project structure
  - Functionality
  - Dependencies
  - Configuration
  - Architecture decisions
- Keep documentation current and accurate to reflect the actual state of the project