---
title: CyberDeck and SSH Master Index
date: 2026-11-08
status: preparation
tags: [cyberdeck, ssh, iphone15, bambu, raspberry-pi, cardputer]
---
# CyberDeck + SSH — master index

## Separate workstreams
- [[CyberDeck iPhone 15]] — CAD, test cradle, Bambu Studio, slate/clamshell.
- [[Reusable SSH Terminal]] — independent software, Swift iOS + Python reference + embedded feasibility.

## GitHub
- [iPhone 15 CyberDeck](https://github.com/ZeusGriffin/open-design/tree/main/projects/hardware/cyberdeck-iphone15)
- [Reusable SSH Terminal](https://github.com/ZeusGriffin/open-design/tree/main/projects/software/reusable-ssh-terminal)
- [CAD + SSH AI handoff](https://github.com/ZeusGriffin/open-design/blob/main/projects/hardware/cyberdeck-iphone15/AI_HANDOFF_MASTER_PROMPT.md)
- [SSH Python reference code](https://github.com/ZeusGriffin/open-design/blob/main/projects/software/reusable-ssh-terminal/python/ssh_client.py)

## Sources
- [cobanov/cyberdeck](https://github.com/cobanov/cyberdeck)
- [gterm](https://github.com/madeye/gterm)
- [EsperDeck](https://github.com/sigman78/esperdeck)
- [SwiftTerm](https://github.com/migueldeicaza/SwiftTerm)
- [Paramiko](https://www.paramiko.org/)

## Progress
See [PROJECT_PROGRESS_2026-11-08.md](https://github.com/ZeusGriffin/open-design/blob/main/projects/software/reusable-ssh-terminal/PROJECT_PROGRESS_2026-11-08.md).

## Build order
1. CAD first: validate iPhone 15 fit, then keyboard case and Bambu 3MF.
2. SSH independently: review source, implement Swift terminal, test on authorized server.
3. Adapt to Whisplay Pi / Windows / Cardputer / ESP32 only after hardware feasibility review.
