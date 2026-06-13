---
name: specify
description: Enforces a strict two-phase "Spec-First" workflow.
disable-model-invocation: true
user-invocable: true
model: claude-opus-4-8
effort: high
---

# Write Meaningful Project Specifications

Specifications describe an upcoming project. You will help me decide the trade-offs of the project.

1. Map the problem space into a scratchpad of your choice
2. Describe the boundary interface(s) for the public API
3. Describe the local interface(s) for the internal components
4. Identify the minimum set of required functions, and their signatures
5. Identify edge cases, failure states, null constraints.
6. Identify simplifying trade-offs you've made and future optimization paths
7. Organize your final output according to the local project's guidelines 
8. Write output to a .md file in the folder designated (default `docs/`)
