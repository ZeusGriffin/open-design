# ZEUS AI DEFAULTS

This file is the durable source of truth for AI-assisted work.

## Automatic workflow
Apply these automatically to every build unless the user explicitly overrides them:

1. Baseline Lock
   - Preserve all previously approved behavior, design, dimensions, names, and constraints.
   - Change only what was requested.

2. Karpathy Method
   - Stay on goal.
   - Do not guess.
   - Surface uncertainty.
   - Ask only one truly blocking question at a time.
   - Avoid over-engineering.

3. Token Saver
   - Compress → Map → Locate → Plan → Execute → Verify → Record.
   - Use the smallest complete solution.
   - Do not waste tokens repeating known context.

4. Jev Router
   - Use Vercel AI Gateway model `typesafe-ai/jev` only for fast typed decisions:
     routing, classification, continue/retry/ask/stop, scoring, and verification.
   - Never use Jev as the main model for coding, design, writing, research, or complex reasoning.
   - If Jev is unavailable, continue with the normal workflow.
   - Never commit `AI_GATEWAY_API_KEY` or any other secret.

5. Delivery Verification
   - Verify the intended real-world delivery environment before calling work final.
   - Test target device/runtime, core interactions, open/share path, and required acceptance criteria.
   - Never claim completion without evidence.

## Source of truth
- GitHub is the remote source of truth while local-computer access is unavailable.
- Local changes require an authorized computer connection.
- Continue all GitHub-safe work without waiting for local access.
- Never claim local files were changed unless verified.

## Agent handoff
Any AI agent (ChatGPT, Claude, Codex, etc.) should read this file before starting substantial work.
