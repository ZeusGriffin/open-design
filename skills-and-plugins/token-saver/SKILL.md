---
name: token-saver
description: Keep agent work token-efficient by minimizing reused context, selecting evidence before reading large sources, carrying accepted artifacts instead of full histories, right-sizing output, and stopping wasteful retry loops. Use for long chats, large files, plan/rate-limit pressure, or whenever context efficiency matters.
---

# Token Saver

## Goal
Spend context on information that can still change the answer. Do not optimize token count at the expense of correctness.

## Core operating rules
1. **Edit/rewind instead of stacking corrections** when the interface permits it. Avoid preserving known-wrong branches.
2. **Start clean for a new job.** Do not drag unrelated conversation history into a separate task.
3. **Batch related work.** Keep tightly related questions together; split unrelated work.
4. **Carry the result, not the argument.** Once an artifact/decision is accepted, continue from that compact artifact rather than every draft and discussion that produced it.
5. **Search before reading.** For repositories, logs, transcripts, and large documents, locate likely passages/files first.
6. **Select passages, not whole sources.** Load only the smallest evidence packet sufficient for the job.
7. **Use the lightest useful source representation.** Prefer structured text/snippets over heavier representations when they contain the same needed evidence.
8. **Turn settled procedures into deterministic code or commands.** Counting, sorting, filtering, exact matching, formatting, and other deterministic transformations should not consume model reasoning when a local tool can do them reliably.
9. **Return to accepted answers.** Revise the approved artifact rather than regenerating from the entire history.
10. **Load tools lazily.** Do not expose or invoke irrelevant tools.
11. **Discard stale tool output.** Do not keep huge logs/results active after extracting the needed facts.
12. **Right-size the answer.** Match the requested output format and length; do not generate prose that will become unnecessary reused input.
13. **Route whole jobs deliberately.** A cheaper model is only a saving if total job cost—including retries and handoffs—falls without hurting quality.
14. **Hard-stop retry loops.** Diagnose before repeating a failed oversized or identical call. Change the plan, shrink context, or ask for the missing constraint.
15. **Cache last.** First remove irrelevant context and stabilize the prompt/source packet; then use caching where the host/provider supports it.

## Pre-call checklist
Before a substantial model/tool call ask:
- What information can still change the result?
- Can search/filter/code reduce the source before loading it?
- Is an accepted artifact available instead of the full conversation?
- Are any tools or outputs irrelevant?
- Is this call a retry? If so, what changed?
- What is the smallest output that satisfies the request?

## Long-session handoff
When context is becoming large, produce a compact handoff containing:
- objective
- accepted decisions
- current artifact/file paths
- verified facts
- unresolved blockers
- exact next action

Then continue in a clean thread/session when possible.

## Plugin / gateway layer
Instruction-only behavior handles most cases. A plugin/helper is justified when it can deterministically:
- select matching passages from large files before a model sees them,
- compact or archive stale tool results,
- construct clean handoff packets,
- estimate/request context size,
- reject or shrink obviously oversized/redundant requests before transmission.

Keep this layer optional. Do not add middleware merely to claim token savings; measure whole-job input, output, retries, latency, and correctness.

## Invocation
Explicit: `Use token-saver for this job.`

Natural language triggers include:
- keep this session token-efficient
- don't burn context
- search before reading whole files
- this chat is getting too long
- work lean / preserve my limit

## Provenance
Adapted from publicly described Token Saver/context-hygiene guidance by Nate B. Jones (July 29, 2026). The source reports a large reused-input share in one observed workload and a large reduction in one matched test; those measurements are examples, not guarantees for other hosts or jobs.

This package does not generate free tokens, bypass limits, or modify provider billing.
