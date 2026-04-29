---
description: Write tutorial / onboarding documentation for a software library — taking developers from zero to familiarity, with embedded interactive code examples.
argument-hint: "[topic, scope, or page type — optional]"
---

Invoke the `docs` skill on the target inferred from `$ARGUMENTS`.

- If `$ARGUMENTS` describes a specific page or topic ("write the quickstart for X", "draft chapter 1 of the tutorial for Y"), follow that.
- If `$ARGUMENTS` is broader ("plan the docs for X"), start with the decision flow at the top of the skill and confirm scope/IA with the user before writing pages.
- If `$ARGUMENTS` is empty, ask the user what they want documented and which page type (tutorial / quickstart / concept guide / reference / "Why X?" / recipe).

Follow the skill's instructions exactly: pick one of the page templates, run the pre-flight checklist before declaring done, and pull from `references/page-templates.md` and `references/source-projects.md` only when relevant to the specific task.
