import { applyEncounter, disposition, newWorld, replay, memoriesFor, type PersonSeed, type EncounterEvent } from "./core";
const assert = (ok: boolean, label: string) => { if (!ok) throw new Error("FAIL: " + label); };
const seeds: PersonSeed[] = [
  { id: "player", displayName: "Traveler", factionId: "wanderers" },
  { id: "npc-1", displayName: "Willow", factionId: "town" },
  { id: "npc-2", displayName: "Rowan", factionId: "forest" },
  { id: "npc-3", displayName: "Sage", factionId: "town" },
  { id: "npc-4", displayName: "Moss", factionId: "forest" },
];
const log: EncounterEvent[] = [
  { id: "e1", tick: 10, instigatorId: "player", witnessId: "npc-1", action: "assist" },
  { id: "e2", tick: 11, instigatorId: "player", witnessId: "npc-1", action: "assist" },
  { id: "e3", tick: 12, instigatorId: "player", witnessId: "npc-2", action: "rob" },
  { id: "e4", tick: 13, instigatorId: "player", witnessId: "npc-2", action: "intimidate" },
  { id: "e5", tick: 14, instigatorId: "player", witnessId: "npc-3", action: "reconcile" },
];
const first = replay(seeds, log);
const afterSaveLoad = replay(seeds, JSON.parse(JSON.stringify(log)) as EncounterEvent[]);
assert(JSON.stringify(first) === JSON.stringify(afterSaveLoad), "deterministic replay after JSON save/load");
assert(disposition(first.people["npc-1"].affinity.player) === "ally", "assistance produces ally");
assert(disposition(first.people["npc-2"].affinity.player) === "hostile", "robbery+threat produces hostility");
assert(first.events.length === 5 && memoriesFor(first, "npc-1").length === 2, "event journal records witnesses");
const duplicateIgnored = applyEncounter(first, log[0]);
assert(duplicateIgnored === first, "duplicate event is idempotent");
assert(newWorld(seeds).events.length === 0, "fresh save has no journal events");
console.log("PASS 6 checks: replay, ally, hostile, journal, idempotence, fresh world");
console.log("npc-1:", disposition(first.people["npc-1"].affinity.player));
console.log("npc-2:", disposition(first.people["npc-2"].affinity.player));
