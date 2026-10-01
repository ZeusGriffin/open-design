# Visual Build Loop

## Purpose
Use screenshot-driven computer control to build, install, configure, test, and repair software or hardware workflows one verified step at a time.

## Mental model (ELI5)
ChatGPT has eyes and hands:
1. Eyes: take a screenshot.
2. Brain: inspect what changed and choose the smallest next action.
3. Hands: click, type, scroll, or run the permitted action.
4. Eyes again: take a fresh screenshot.
5. Verify: compare expected vs actual result.
6. Repeat until the goal is visibly complete.

Never assume an action worked. The next screenshot is the proof.

## Six-step operating loop
1. Define the target outcome and the app/window being controlled.
2. Capture the current screen before acting.
3. Inspect the screenshot and select the smallest safe next action.
4. Execute that action (or a small ordered batch when low-risk).
5. Capture a new screenshot and verify the result/error/state change.
6. Repeat from step 3 until complete; stop for credentials, payments, destructive actions, admin/security prompts, or ambiguity that needs the user.

## Rules
- Screenshot before guessing.
- One small testable change at a time when debugging.
- Never claim success without visual or command/output verification.
- Preserve a rollback point before destructive changes.
- Do not expose secrets in screenshots, logs, or repositories.
- Keep account/security/payment/admin actions user-controlled unless explicitly supported and approved.
- If UI state differs from instructions, trust the current screenshot and adapt.
- Record failures and the successful correction so the next run is faster.

## Build workflow
For coding/build tasks: inspect -> edit -> run/build -> screenshot -> compare -> correct -> repeat.
For hardware setup: inspect connection/state -> perform one setup step -> capture output/UI -> verify -> continue.
For firmware: identify exact board/port/firmware -> preserve backup when possible -> flash -> verify boot/display/serial -> only then continue.

## Completion gate
A task is complete only when the requested end state is visible or independently verified. Report what changed, what was verified, and anything still requiring the user's physical computer.

## Source concept
Based on the screenshot/action feedback-loop pattern described in the user's reference video (YouTube M5KOgtk9VfI) and verified against OpenAI Computer Use documentation.
