---
name: supervised-team
description: Run a supervised team of parallel Codex/tmux sessions for large, high-stakes work that benefits from independent workers, explicit artifacts, verification gates, and anti-drift supervision. Use when the user asks for multi-agent, subagent, tmux, supervisor/worker, autonomous team, parallel exploration, unsupervised implementation, or resource-maximizing workflows, especially when they want to specify work intensity and prevent agents from doing shallow workarounds.
---

# Supervised Team

## Overview

Use this skill to turn a broad objective into a supervised parallel-work system. The core pattern is a central supervisor that owns strategy, decomposition, integration, and quality gates while bounded worker sessions produce inspectable artifacts in disjoint scopes.

The skill is useful for product redesigns, compiler/runtime work, large refactors, defect discovery, research-heavy implementation, CI repair campaigns, and any task where a single agent tends to drift into local fixes instead of addressing the hard problem.

## First Response

When this skill triggers, do not immediately start random workers. First produce or update a supervisor brief that defines:

- the objective and non-goals;
- work intensity;
- worker topology;
- owned files or domains per worker;
- required artifacts;
- quality gates;
- escalation rules;
- what counts as a rejected distraction;
- final acceptance criteria.

If the user gave enough context, make reasonable assumptions and proceed. Ask only for missing details that would make execution risky, such as unknown repository locations or credentials.

## Work Intensity

Let the user specify intensity in plain language or explicitly as one of these levels. If unspecified, choose `standard` for normal coding work and `high` for ambitious unsupervised exploration.

| Intensity | Use when | Starting workers | Supervisor cadence | Verification |
| --- | --- | ---: | --- | --- |
| `light` | Small exploration or low-risk task | 2-3 | Check after each artifact | Basic tests/screenshots |
| `standard` | Normal product/code work | 4-6 | Check every 20-30 minutes or phase | Tests plus focused review |
| `high` | Important broad work with ample resources | 8-12 | Active backlog and integration loop | Scenario tests, screenshots, logs |
| `max` | User explicitly wants aggressive resource use | 16-50+ if resources allow | Continuous supervisor loop | Multi-pass evaluators and reproductions |

For `max`, require resource-aware scaling. Monitor CPU, RAM, disk, and queue length. Spawn more workers only for independent work with inspectable outputs. Do not multiply workers on the same ambiguous task.

## Team Topology

Use these roles as needed:

- `supervisor`: owns plan, decomposition, backlog, integration, final quality, and anti-drift enforcement.
- `research`: gathers source truth, prior art, constraints, APIs, user flows, existing behavior, or failing evidence.
- `architect`: proposes system/product structure, tradeoffs, and hard-problem framing.
- `worker`: implements or prototypes within a clearly owned file/domain scope.
- `evaluator`: tests artifacts against scenarios, screenshots, metrics, accessibility, performance, or reproductions.
- `triage`: turns raw findings into prioritized defects or decisions.
- `polisher`: refines the chosen artifact after structure is validated.

Assign each worker a disjoint ownership scope. For code changes, specify exact files, modules, or directories. For design/research, specify exact artifact paths.

## Supervisor Brief Template

Create a repo-local `supervisor.md` or task-specific brief using this structure:

```markdown
# Supervisor Goal: [objective]

## Outcome
- [final artifacts]

## Intensity
- Level: [light|standard|high|max]
- Starting workers: [n]
- Scaling rule: [resource and independence criteria]

## Non-Goals
- [things not to work on]

## Ground Truth
- [sources, existing files, PRs, docs, tests]

## Worker Topology
- supervisor: [responsibilities]
- worker-name: [task, owned files, completion criteria]

## Workflow
1. Research and inventory
2. Design/architecture brief
3. Divergent solutions or implementation slices
4. Evaluation and triage
5. Integration and polish
6. Verification

## Quality Gates
- [tests, screenshots, scenario scores, review criteria]

## Rejected Distractions
- [tempting but shallow tasks]

## Final Acceptance Criteria
- [objective done when...]
```

## Worker Prompt Template

Give every worker a bounded prompt:

```text
You are one worker in a supervised team. You are not alone in the workspace.
Do not revert or overwrite work outside your assigned scope.
Work only in the files or domains assigned below.
Produce inspectable output before declaring completion.

Objective context:
[brief summary]

Assigned task:
[specific task]

Owned scope:
[files/directories/artifacts]

Completion criteria:
[tests/artifacts/decision needed]

When done, report only:
- files changed or artifacts created;
- key decisions;
- unresolved blockers.
```

## Anti-Drift Rules

The supervisor must actively reject shallow progress:

- Do not let workers patch symptoms when the brief names a deeper problem.
- Do not let a worker turn an exploration into generic cleanup.
- Do not accept "tool unavailable" as terminal until at least two alternatives were attempted.
- Do not let all workers converge on the same idea unless convergence is an explicit phase.
- Do not polish before hierarchy, architecture, or core behavior is validated.
- Do not allow hidden work. Every worker must leave a file, diff, log, screenshot, test result, or structured note.
- Do not confuse more workers with more progress. Parallelize only independent, checkable work.

Keep a visible backlog with three buckets:

- `Must fix before final`
- `Could improve if time remains`
- `Rejected distraction`

## Resource-Aware Scaling

For `high` and `max`, supervise scaling with simple checks:

```bash
nproc
free -h
df -h .
ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -40
tmux list-sessions
tmux list-windows -a
```

Spawn additional sessions only when:

- there is enough free RAM and disk for the task;
- the task is independent;
- expected output is defined;
- integration risk is bounded;
- the supervisor can review the result.

Stop or merge workers when outputs become duplicative, blocked, or low-value.

## Evaluation Pattern

Prefer evaluator workers that operate from user scenarios and objective checks, not taste or vague review.

Examples:

- UI work: screenshots at desktop/mobile, scenario walkthroughs, readability, overlap, keyboard/focus, design-system consistency.
- Compiler/runtime work: conformance suites, differential tests against reference runtime, minimized repros, performance counters, crash triage.
- Refactors: behavior-preserving tests, API compatibility, migration checks, benchmark deltas.
- Defect campaigns: find potential defects, triage, reproduce from real flows, minimize, then assign fixes.

A finding is useful only if it has evidence, reproduction steps, a file/path/screenshot/log, or a clear decision impact.

## Integration

The supervisor integrates only after reviewing worker artifacts. Preserve user or unrelated changes. For code, run tests after each integration batch. For design, compare screenshots before and after polish.

When finishing, report:

- final artifacts and paths;
- work intensity used;
- workers/tasks run;
- verification performed;
- remaining risks or blocked items.
