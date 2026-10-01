# Claude / Agent Prompt

Use the token-saver skill for this job.

Preserve correctness, but keep the working context lean:
- search/filter before reading whole files;
- carry accepted artifacts and decisions instead of full chat history;
- use deterministic local commands/code for deterministic work;
- load only relevant tools and evidence;
- keep outputs to the requested size;
- do not repeat failed calls without changing the plan;
- when the session becomes bloated, create a compact handoff with objective, accepted decisions, files, verified facts, blockers, and next action, then continue cleanly.

Token reduction is not the goal by itself. Optimize the whole job: correctness, retries, review effort, input, cached/reused input, and output.
