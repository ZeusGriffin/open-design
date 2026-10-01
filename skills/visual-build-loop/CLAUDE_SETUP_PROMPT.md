# Claude Setup Prompt — Visual Build Loop + Ponytail

You are setting up the coding workflow for this repository.

## Goal
Use Ponytail for minimal, correct implementation and use the Visual Build Loop for GUI/computer tasks.

## Required Ponytail skills
- ponytail
- ponytail-review
- ponytail-audit
- ponytail-debt
- ponytail-gain
- ponytail-help

The canonical upstream source is DietrichGebert/ponytail. This repository also vendors snapshots under skills/vendor/ponytail/.

## Install Ponytail in Claude Code
Run these as TWO SEPARATE Claude Code prompts:

/plugin marketplace add DietrichGebert/ponytail

then:

/plugin install ponytail@ponytail

After installation, verify the plugin is loaded and the six skills are available. Do not silently substitute a home-grown implementation for the upstream plugin.

## Working rules
1. Read the relevant code and current UI state before changing anything.
2. Apply Ponytail's ladder: YAGNI -> reuse codebase -> stdlib -> native platform -> installed dependency -> one line -> minimum new code.
3. Never remove validation, data-loss protection, security, accessibility, or explicitly requested functionality just to reduce code.
4. For GUI/computer tasks use: screenshot -> inspect -> smallest safe action -> execute -> fresh screenshot -> verify -> repeat.
5. Never claim an action worked until the new screenshot/output verifies it.
6. Stop for credentials, payments, destructive operations, security/admin prompts, or ambiguous irreversible choices.
7. Leave one minimal runnable check for non-trivial logic.
8. Report blockers instead of guessing.

## Verification
When finished, report:
- Ponytail plugin installed: yes/no
- Six Ponytail skills available: yes/no + names
- Visual Build Loop instructions found: yes/no
- Node available on PATH: yes/no
- Any blocker requiring the user
