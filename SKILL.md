---
name: pls
description: Apply Precise, Lean, Streamlined reasoning to code design, implementation, refactoring, and review. Model required behavior before choosing architecture, remove unjustified semantic machinery, and verify success at the affected system boundary.
---
# PLS: Precise, Lean, Streamlined

Use PLS for code design, implementation, refactoring, and review.

## Purpose

Build the smallest correct semantic implementation. Do not optimize only for
few lines, functions, files, or classes.

| Principle   | Meaning                                              |
| ----------- | ---------------------------------------------------- |
| Precise     | Determine exactly what must become true.             |
| Lean        | Use only the semantic machinery that makes it true.  |
| Streamlined | Give every operation and artifact a reason to exist. |

## Rules that always apply

1. Preserve the user's underlying need.
2. Treat a proposed implementation as a hypothesis, unless the user makes it
   a requirement.
3. Preserve repository instructions, explicit constraints, security,
   accessibility, reliability, testing, and operational requirements.
4. Do not add speculative features, abstractions, dependencies, extension points, or future support.
5. Count a future requirement only when it is committed, documented as a
   compatibility promise, or already represented by an existing extension
   point.
6. Treat uncommitted needs as non-requirements. Do not implement them.
7. Scale analysis, code, and verification to the change risk and scope.
8. When two designs preserve the same required behavior, choose the simpler
   user and maintainer mental model. Choose the design that is easier to
   explain, operate, and change safely.
9. Preserve unrelated existing changes. Do not broaden the edit.
10. Before implementation, identify choices left unspecified that change the
    meaning or scope of the result. Resolve them from context, ask when they
    materially affect the answer, or explicitly state the assumption before
    proceeding. Apply this in both Simple and Complex modes.

PLS determines the required meaning. Complexity-reduction guidance, such as
ponytail, can simplify the implementation after that meaning is known.

## Select a mode

| Change  | Use                                                                           |
| ------- | ----------------------------------------------------------------------------- |
| Simple  | A straightforward, bounded change with known behavior. Use Simple mode.       |
| Complex | An ambiguous, risky, cross-boundary, or non-trivial change. Use Complex mode. |

Simple mode is a filter, not a ceremony. Define the behavior, keep the direct
path, prove it once, then stop.

## Simple mode

Use this merged workflow for a straightforward, bounded change with known
behavior:

```text
PRECISE
Need:
Success:
Constraints:
Failure:

LEAN
Input:
Operation: Validate only if needed. Transform once.
Artifact: Use one representation for each meaningful value.
Output: The required output or effect.

Use one direct path from input to outcome:
input → validate only if needed → transform once → output or effect

STREAMLINED
Why does each operation or artifact exist?
What breaks if it is removed?

IMPLEMENT
Do not add future-only options, extension points, or abstractions.
Use the simplest structure that expresses the graph.
If two correct versions exist, choose the version that is easier to explain in
one sentence.

VERIFY
Verify one real success behavior, its relevant failure behavior, and each
explicit constraint. Verify an affected boundary when one exists.
```

Stop when removing another operation can break user-visible behavior, an
explicit constraint, necessary clarity, or the required verification.

## Review mode

For each relevant component, reconstruct this semantic graph:

```text
INPUT
What information does it consume?

OPERATION
What semantic work does it perform?

ARTIFACT
What new information, state, decision, or effect does it create?

JUSTIFICATION
Why must that operation or artifact exist?

DEPENDENT REQUIREMENT
What breaks if it is removed?
```

Report findings in these categories:

| Category     | Finding                                                                |
| ------------ | ---------------------------------------------------------------------- |
| Precision    | The implementation does not satisfy the need or violates a constraint. |
| Lean         | Unnecessary semantic work or representation exists.                    |
| Streamlining | An operation or artifact has no traceable justification.               |

Do not turn a PLS review into a generic style review. Do not apply fixes unless
the user requests implementation.

## Stopping rule

Stop simplifying when another simplification can do one of these things:

- Weaken semantic success.
- Violate a constraint or invariant.
- Duplicate work.
- Hide necessary complexity.
- Reduce required clarity.
- Damage a committed requirement.
- Introduce equal or greater complexity elsewhere.

## Complex mode

Make the full reasoning explicit before editing.

### 1. Build the semantic contract

Determine these facts:

```text
USER NEED
What must become true for the user?

SUCCESS
What observable behavior proves success?

CONSTRAINTS
What explicit restrictions, compatibility promises, and invariants apply?

FAILURE
What must happen when success cannot occur?

SYSTEM CONTEXT
What callers, state, boundaries, current patterns, and dirty changes constrain this?

NON-FUNCTIONAL REQUIREMENTS
What limits apply to security, privacy, performance, accessibility, reliability, and operations?

KNOWN REQUIREMENTS
Which current or explicitly committed future requirements must this support?
```

Separate requirements from assumptions. Verify cheap assumptions. State
unverified assumptions. Do not silently treat them as requirements.

Before you name files, APIs, types, dependencies, or architecture, inspect the
live affected code. Before you change a shared function, search every caller.
When all affected callers use one shared path, fix the root cause in that path.

### 2. Build the semantic graph

Describe the minimum transformation from input to the required outcome:

```text
input
  ↓
semantic operation
  ↓
logical artifact
  ↓
semantic operation
  ↓
required output or effect
```

| Term               | Definition                                                                                                              |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| Semantic operation | Meaningful parsing, validation, calculation, selection, transformation, authorization, persistence, or external action. |
| Logical artifact   | A distinct value, state, decision, or effect that later logic or required behavior meaningfully depends on.             |

Do not treat each temporary variable or machine-level state change as a
logical artifact.

Add an operation or artifact only when it supports one of these needs:

- Semantic success.
- An explicit constraint or invariant.
- Correctness, security, reliability, or required performance.
- A committed compatibility requirement.
- Clarity that is necessary to reason about required logic.

### 3. Justify and simplify the graph

For every operation and artifact, ask:

```text
Why must this exist?
What breaks if it is removed or merged?
```

Remove an item when its removal does not weaken a required behavior or
property. Then ask:

- Can you remove an operation?
- Can an existing artifact serve another operation?
- Can two operations merge without hiding necessary complexity?
- Can two artifacts merge without weakening meaning?
- Does any semantic work run or transform twice?
- Did an unnecessary abstraction create work?

Do not remove an artifact by doing its work twice. For example, do not
normalize once for validation and again for persistence only to remove a named
intermediate value.

Keep essential complexity. Remove accidental complexity.

### 4. Choose and implement

Choose functions, types, files, modules, libraries, storage, interfaces, and
frameworks only after the semantic graph is stable.

Prefer direct implementation and existing repository patterns. Do not add:

- An interface with one implementation.
- A factory with one product.
- A forwarding service layer.
- A duplicate representation.
- Configuration for a value that does not vary.

Do not let an implementation pattern redefine the semantic graph. If coding
shows that the graph is wrong, revise the graph first.

For a bug fix, trace all callers and sibling paths before you edit. Prefer one
shared guard or invariant-preserving fix over repeated caller-specific guards.

### 5. Define recovery and operations

Specify these behaviors when they apply:

- Partial failure.
- Retry and idempotency.
- Interruption or restart.
- Already-applied input.
- Corrupted or inconsistent state.
- Rollback or safe recovery.
- User-visible diagnostics.

Do not add recovery machinery when the operation is local and atomic, and its
existing failure behavior is sufficient.

When the change crosses a process, API, database, UI, device, or external
service boundary, verify that real boundary after implementation. Unit tests
alone do not prove live integration success.

### 6. Derive verification from the contract

Test behavior, not implementation shape. Cover the cases that prove:

- Success behavior.
- Required failure behavior.
- Explicit constraints and invariants.
- Boundary values and relevant malformed input.
- Security or authorization rules.
- Retry, interruption, or recovery behavior, when applicable.
- The affected live boundary, when the change requires it.

Use the smallest runnable check that fails when the semantic contract breaks.
Do not add a test framework, fixture system, or per-function suite without a
concrete need.
