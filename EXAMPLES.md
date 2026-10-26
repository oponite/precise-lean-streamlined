# PLS Examples

These examples show how PLS turns a request into clear behavior, a direct implementation path, and observable checks.

Each follows the same structure: **request → required behavior → simplest path → proof**.

The decisions below are illustrative requirements, not assumptions an agent should silently make.

## 1. Remove duplicates without changing the order

**Request**

> Remove duplicate names from this list. Use PLS.

**Precise — settle what “duplicate” means.**

Does `"Ada"` count as the same name as `"ada"`? Must the original order survive? Resolve this from existing requirements, or ask if unclear.

For this example, the agreed behavior is:

> Compare names exactly. Keep the first occurrence of each name, in its original position.

**Lean — do only the required work.**

```text
names → keep each name’s first occurrence → unique names
```

No sorting, lowercasing, or whitespace cleanup: each would change behavior beyond the requirement.

**Streamlined — keep state that has a purpose.**

Remembering names already encountered supports duplicate detection. Keeping the result in encounter order preserves the required ordering. Neither is unnecessary merely because it adds code.

**Proof**

```text
["Mia", "Ada", "Mia", "ada"] → ["Mia", "Ada", "ada"]
[]                         → []
```

**Lesson:** A shorter implementation is wrong if it changes what “duplicate” or “keep” means.

## 2. Count open tasks without building a reporting system

**Request**

> Show how many tasks are open. Use PLS.

**Precise — define the count.**

In this example, the application already holds the complete task list. Each task has a validated status. Count tasks whose status is exactly `"open"`; show `0` when none qualify.

**Lean — go directly from tasks to a number.**

```text
tasks → count tasks with status "open" → display count
```

**Streamlined — remove work that cannot affect the answer.**

A proposed implementation sorts tasks by date, creates a list of open tasks, then counts that list.

Sorting cannot change the count. The filtered list has no other consumer. Remove both intermediate steps and count matching tasks directly.

**Proof**

For task lists with these statuses:

```text
["open", "done", "open"] → 2
["done"]               → 0
[]                     → 0
```

**Lesson:** Remove unnecessary work, not just unnecessary lines. If the application has only one page of tasks, this implementation would not satisfy a total-count requirement.

## 3. Save a display name without validating one value and storing another

**Request**

> Trim extra spaces and save my display name. Reject blank names. Use PLS.

**Precise — define the transformation and failure.**

For this example, “extra spaces” means leading and trailing whitespace. Preserve internal spaces. If the trimmed name is empty, show an error and keep the existing name.

**Lean — create the value once.**

```text
entered name → trim → check nonempty → save trimmed name
```

A whitespace-only name takes the error path before saving.

**Streamlined — retain the useful intermediate value.**

Keep the trimmed name so validation and saving use the same value. Removing that variable is not an improvement if it causes repeated trimming or accidentally saves the original input.

**Proof**

```text
"  Ada Lovelace  " → save "Ada Lovelace"
"Ada  Lovelace"    → save "Ada  Lovelace"
"   "             → show error; existing name unchanged
```

After implementation, submit through the actual form and reload to confirm persistence. A trimming-function test alone does not prove saving works.

**Lesson:** Stop simplifying when the next removal would weaken correctness.
