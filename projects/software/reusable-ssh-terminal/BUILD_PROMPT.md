# Build prompt: reusable SSH terminal

Goal: build a reusable, secure SSH terminal capability for the iPhone 15 CyberDeck and other projects.

Use evidence-first, smallest-change iteration, baseline lock, license compliance, and explicit tests.

1. Inspect upstream gterm, Pockterm, and EsperDeck source; pin commit hashes and inspect licenses and dependency manifests.
2. Select iOS baseline (prefer gterm for keyboard-oriented iPhone 15 CyberDeck if current code builds; compare Pockterm for SFTP and external-display features).
3. Do not copy upstream code blindly or claim an app exists until it builds. Preserve attribution and original source separately.
4. Extract reusable *interfaces and settings*: host name, port, username, SSH key reference, terminal size, color theme, extra keyboard row, connection timeout, keepalive.
5. iOS: use system Keychain for secrets and maintained SSH library. Enforce host-key verification; prompt user on first trust and alert on key changes. No hardcoded passwords or private keys.
6. Windows and Pi: document OpenSSH server configuration with opt-in firewall and user authorization; do not expose port 22 publicly by default. Prefer private LAN or secure VPN.
7. ESP32/Cardputer: implement separate embedded firmware only after memory, display, input and library feasibility checks.
8. Test keyboard input, Ctrl/Alt/Esc/Tab/arrows, resize, disconnect/reconnect, password/key auth, host key mismatch, no credential leaks, SSH sessions with real authorized host.
9. Package iOS project/source, build instructions, ESP32 feasibility notes, and an Obsidian note; do not claim phone install without signed iOS build and physical test.

Success criteria: tested iOS connection to user's authorized Pi or PC, keyboard works, keys protected, host verification correct. Hardware variants have their own pass/fail gates.
