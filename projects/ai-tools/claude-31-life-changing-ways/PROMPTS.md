# Prompt Library — 31 Claude Use Cases

These are **working reconstructions** based on the public video and visible on-screen details. They are designed to reproduce the intent while adding rollback, verification, and ownership checks.

## 1. Remove ads from your TV
I own this TV: [brand/model]. Help me clean up its interface. First determine whether it is Android/Google TV and whether ADB is supported. Back up installed packages and relevant settings before changing anything. Identify telemetry, ad, recommendation, and bloat packages, explain each proposed change, and ask before disabling anything that could affect apps I use. Then install or build a lightweight launcher with the apps I choose. Do not uninstall system packages; prefer reversible disable actions. Finish with a restore script and verify Home, remote, Wi-Fi, streaming apps, voice features, casting, and firmware updates.

## 2. Build the gadget you want
I want to build a small [device description] that does [goal]. Design the whole project from idea to prototype: parts list, component choices, wiring/breadboard diagram, power requirements, firmware architecture, enclosure dimensions, and a 3D-printable case plan. Favor common parts and explain substitutions. Create a bring-up checklist and test each subsystem separately before integration. Keep the design modular so I can swap the MCU, display, battery, or microphone later.

## 3. Fix an appliance with a bad app
I own [appliance/model] and dislike its official control app. Using only interfaces I am authorized to access, help me document how the appliance communicates and build a cleaner local controller. Start read-only: inspect network traffic, local APIs, serial/Bluetooth behavior, or existing documentation. Then build a desktop or mobile UI with the controls I actually use. Keep the original app functional, avoid cloud dependency when possible, and document how to roll back.

## 4. Jailbreak an old Kindle
I own this Kindle: [model/firmware]. Research the safest currently supported method for installing user-controlled software on this exact version. Back up anything recoverable first. Do not guess across firmware versions. If the device can be safely modified, help me add open-source reading/home-dashboard tools and private networking while preserving a recovery path. Stop if the firmware is unsupported or the process risks an unrecoverable brick.

## 5. Fix a slow Wi-Fi router
This is my router: [brand/model/firmware], and my current measured speed is [speed]. Start with a read-only audit of configuration and local RF conditions. Keep credentials out of chat and use the OS credential store/keychain if automation needs them. Identify settings that could be hurting performance, rank them by likely impact, and change only one at a time with my approval. After each change, run the same speed/latency test and log old value, new value, and result. Provide a full restore checklist.

## 6. Print a morning paper
I have a Bluetooth/USB receipt printer: [model]. Build a small local service that creates a compact morning paper from sources I choose, such as my calendar, weather, reminders, RSS, and a short email digest. Format it for the printer width, avoid wasting paper, and schedule it for [time]. Keep authentication tokens local and add a manual “print test page” button plus a failure log.

## 7. Turn a drone into security
I own [drone/model] and want a local, privacy-preserving property-monitoring prototype for my own property. Use official/local SDKs where available. Start with a simulator and geofenced test area. Build event-triggered patrol/inspection behavior with conservative speed, altitude, obstacle avoidance, return-to-home, manual override, and no autonomous pursuit of people. Keep video processing local where possible and require a human to approve any real flight.

## 8. Turn an old iPad into a wall panel
I own an old iPad [model/iOS version]. Determine what still works reliably on it and build a lightweight wall-panel interface for [Home Assistant/dashboard/local controls]. Prefer a native or extremely simple local web UI that works with the device's old browser/runtime. Make large touch targets, full-screen mode, auto-refresh/reconnect, burn-in-aware behavior, and a simple recovery path if the app crashes.

## 9. A $60 phone with Claude Code
I have an older phone with a physical keyboard: [model]. Help me turn it into a pocket terminal for SSH and AI-assisted coding without weakening account security. Use a modern supported SSH client or a safe remote-shell path, keep keys encrypted, and treat the phone as a thin client rather than storing sensitive repositories locally. Build a minimal launcher/workflow for connecting to my main development machine.

## 10. Cancel your subscriptions
Create an inventory of my recurring software subscriptions from the list I provide. For each one, classify it as keep, cancel, replace with open source, or build a small custom replacement. Estimate the effort and risk of replacement and prioritize the easiest wins. Do not cancel anything automatically. Produce a migration checklist and a monthly savings total only after I confirm the prices.

## 11. Agents that haggle for you
I want to [buy/sell] [item] on [marketplace]. Research recent comparable listings/sales, separate asking prices from actual sold prices where possible, and give me a reasonable range. Suggest an opening number, target number, and walk-away point. Draft a polite first message, counteroffer, and close. Do not misrepresent the item's condition, fabricate competing offers, impersonate me, or send anything without my approval.

## 12. Automate a dating app
Help me create a private preference rubric for reviewing dating profiles I manually export or describe. Turn my stated preferences and deal-breakers into a scored checklist, explain why each profile matches or does not, and keep the final choice with me. Do not auto-swipe, message people, evade platform rules, or impersonate me.

## 13. Find a hidden crypto miner
My computer is unusually hot/slow. Build a read-only diagnostic that records CPU/GPU temperature, utilization, battery/power draw, top processes, startup items, and network connections. Flag unexplained sustained usage and known miner-like behavior, but do not delete or kill anything until I review it. Give me the evidence, likely causes, and safe remediation steps.

## 14. Audit your car
I own this vehicle/head unit: [vehicle/model/head-unit]. Perform a read-only privacy/security audit using interfaces I am authorized to access. Inventory installed apps/services, microphones, voice assistants, Bluetooth behavior, logging, update mechanisms, permissions, background network connections, and vendor telemetry. Flag suspicious or overly broad capabilities with evidence. Do not alter safety-critical vehicle systems.

## 15. Sweep a hotel room
Create a read-only privacy sweep for a hotel/Airbnb I am staying in. Inventory devices visible on the local network without trying to break into them; flag likely camera/IoT vendors and common streaming ports. Check my own phone/laptop for suspicious configuration, profiles, or known spyware indicators using reputable tools. Scan Bluetooth for persistent trackers and explain normal false positives. Do not access other guests' devices.

## 16. Research your own cancer
Help me organize medical literature about [diagnosis/topic] for discussion with licensed clinicians. Build a source-backed research map: standard-of-care guidelines, major trials, biomarkers, open questions, and questions to ask my oncology team. Separate established evidence from experimental ideas and preprints. Do not recommend changing treatment, dosing, or testing without the treating team.

## 17. A one-person biotech
Design an AI-assisted operations system for a one-person biotech/research company that focuses on literature review, project tracking, documentation, data analysis, vendor coordination, and regulatory/admin workflows. Keep laboratory decisions and biological experiments under qualified human review. Define agent roles, shared context, review gates, audit logs, and what must never be autonomous.

## 18. Find a planet
Using a public astronomy dataset I specify, build a reproducible analysis pipeline for identifying candidate anomalies such as transit-like signals. Start with published methods and a small validation subset. Write scripts that log every transformation, visualize candidates, compare against known catalogs, and rank interesting signals for expert follow-up. Do not label a candidate a discovery until independently verified.

## 19. Discover a new enzyme
Using public sequence datasets, help me build a **non-operational computational** literature/data-mining workflow that clusters unusual protein or repeat-system patterns and produces hypotheses for expert review. Keep the output at sequence-analysis and literature-comparison level; do not provide wet-lab engineering, synthesis, culture, or experimental optimization instructions. Clearly mark uncertainty and known homologs.

## 20. Translate a game for your kid
For a game I legally own, help me create a personal localization patch. Inventory text/audio assets, extract them without distributing copyrighted game files, transcribe dialogue, translate it into [language], and generate replacement voice assets using appropriately licensed/local voices. Keep a manifest of changed files and package only the patch/diff needed for my own copy.

## 21. A 9-year-old builds a website
Act as a patient website-building partner for a child. Ask one simple question at a time about colors, interests, books, drawings, photos, and layout, then build the site from those choices. Keep code and deployment complexity hidden unless asked. Do not collect personal contact details, precise location, school information, or other sensitive data. Require an adult for publishing/domain setup.

## 22. Plan a room in 3D
I will provide room measurements, photos, doors/windows, and furniture dimensions. Build a to-scale 2D and 3D room planner with multiple layout options. Let me drag/resize furniture and wall art, change lighting, and walk through the room. Warn about blocked doors/windows, bad clearances, or furniture collisions. Keep measurements editable because photo-derived estimates may be wrong.

## 23. Walk through a house before it exists
I will provide a floor plan, elevations, finishes, and reference photos. Build a to-scale browser-based 3D walkthrough of the proposed house. Preserve room dimensions and openings, label uncertain assumptions, and let me swap materials/furniture without changing structural geometry. Add a simple shareable presentation mode and a checklist for validating the model against the architectural drawings.

## 24. Build your family tree
Starting from records I legally possess and public genealogy sources, help me build a family tree. For every relationship, preserve the source, date, location, and confidence level. Do not merge people solely because names match. Flag contradictory records and ask for confirmation before accepting uncertain links. Produce both a human-readable tree and a source ledger.

## 25. Replace an app you pay for
I currently pay for [app] mainly to do [features I actually use]. Design a minimal replacement that covers only those workflows. First list must-have features, data I need to migrate, and platform constraints. Then build the simplest local-first version with export/backup, no ads, and no unnecessary accounts. Do not copy proprietary branding, source code, or protected assets.

## 26. Learn drones without crashing one
Build an educational drone-lab simulator where I can assemble a drone from real-world component classes, see weight/thrust/battery tradeoffs, and fly the result in a safe virtual range. Explain the effect of each part and include beginner missions. Treat physics as an approximation and label any values that are simulated rather than manufacturer-verified.

## 27. Turn podcasts into a playbook
I will give you a set of podcast/video links or transcripts about [topic]. Extract the highest-value actionable lessons, deduplicate repeated advice, preserve who said what and where, and organize the result into principles, workflows, examples, and checklists. Separate consensus from disagreement and create a short “do this first” section.

## 28. Bring old games back
For a game I legally own and a preservation-compatible open project, help me study/decompile/reimplement only what is legally and technically appropriate. Start by locating existing open-source decompilation, server-revival, or compatibility projects. Keep proprietary game assets out of the repository. Build tests that compare behavior against my own copy and document what remains incomplete.

## 29. Port games to old hardware
I have [open-source/homebrew game or legally usable code] and want to target [hardware]. Inventory the hardware limits, toolchain, graphics/audio/input constraints, memory map, and cartridge/storage format. Build a minimal proof of concept first, then port one subsystem at a time. Test on emulator and real hardware where available. Do not distribute copyrighted ROMs or proprietary assets.

## 30. Find the game nobody made
Build a market-gap map for games. Collect a large catalog of public game metadata, turn descriptions/tags into embeddings, cluster similar concepts, and sample the sparse spaces between clusters. Rank gaps by novelty, audience plausibility, and buildability. For the top ideas, explain the neighboring games and why the concept is meaningfully different rather than just a mashup.

## 31. An overnight photographer
I own and control this camera: [model]. Build a safe overnight creative-photography routine using its supported tethering/API controls. Define a fixed shooting area, exposure boundaries, focus strategy, interval logic, and storage limit. Experiment with composition/timing while I sleep, but do not move beyond the configured field of view or capture private areas. In the morning, make a contact sheet and rank the best shots with reasons.

# Bonus ideas from the closing montage

## Market research
Research [market] across competitors, customer complaints, pricing, substitutes, and unmet needs. Build a source-backed map of opportunities and rank them by evidence strength.

## Fitness / glucose / genome
Use AI to summarize and organize data I explicitly provide, detect trends, and generate questions for a qualified clinician or coach. Do not diagnose conditions or change medication/treatment based on the model alone.
