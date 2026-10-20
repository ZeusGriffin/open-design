/** An original, engine-independent NPC relationship simulation. No game assets or code. */
export type Encounter = "assist" | "betray" | "rob" | "intimidate" | "reconcile";

export interface PersonSeed {
  id: string;
  displayName: string;
  factionId: string;
}
export interface EncounterEvent {
  id: string; // stable id supplied by game adapter
  tick: number; // deterministic in-game time, not wall-clock time
  instigatorId: string;
  witnessId: string;
  action: Encounter;
}
export interface RelationshipMemory {
  eventId: string;
  tick: number;
  action: Encounter;
  regardingId: string;
  affinityChange: number;
}
export interface PersonState extends PersonSeed {
  affinity: Record<string, number>;
  memories: RelationshipMemory[];
}
export interface WorldState {
  schemaVersion: 1;
  people: Record<string, PersonState>;
  events: EncounterEvent[];
}
const IMPACT: Record<Encounter, number> = {
  assist: 18,
  betray: -35,
  rob: -25,
  intimidate: -12,
  reconcile: 10,
};
const bound = (n: number): number => Math.max(-100, Math.min(100, n));

/** Seed data is supplied by the game adapter or a stand-alone test harness. */
export function newWorld(seeds: readonly PersonSeed[]): WorldState {
  const people: Record<string, PersonState> = {};
  for (const seed of seeds) {
    if (!seed.id || !seed.displayName || !seed.factionId || people[seed.id]) {
      throw new Error("Invalid or duplicate NPC seed");
    }
    people[seed.id] = { ...seed, affinity: {}, memories: [] };
  }
  return { schemaVersion: 1, people, events: [] };
}

/** Pure reducer: repeating the same ordered input creates an identical state. */
export function applyEncounter(world: WorldState, event: EncounterEvent): WorldState {
  if (!event.id || !Number.isFinite(event.tick) ||
      !(event.action in IMPACT) ||
      !world.people[event.instigatorId] || !world.people[event.witnessId] ||
      event.instigatorId === event.witnessId) {
    throw new Error("Invalid encounter");
  }
  if (world.events.some((prior) => prior.id === event.id)) return world;
  const witness = world.people[event.witnessId];
  const delta = IMPACT[event.action];
  const priorAffinity = witness.affinity[event.instigatorId] ?? 0;
  const nextWitness: PersonState = {
    ...witness,
    affinity: { ...witness.affinity, [event.instigatorId]: bound(priorAffinity + delta) },
    memories: [...witness.memories, {
      eventId: event.id,
      tick: event.tick,
      action: event.action,
      regardingId: event.instigatorId,
      affinityChange: delta,
    }],
  };
  return {
    schemaVersion: 1,
    people: { ...world.people, [event.witnessId]: nextWitness },
    events: [...world.events, { ...event }],
  };
}

export function replay(seeds: readonly PersonSeed[], events: readonly EncounterEvent[]): WorldState {
  return events.reduce(applyEncounter, newWorld(seeds));
}

export function disposition(affinity: number): "ally" | "hostile" | "cautious" | "neutral" {
  if (affinity >= 30) return "ally";
  if (affinity <= -30) return "hostile";
  if (affinity < 0) return "cautious";
  return "neutral";
}

export function memoriesFor(world: WorldState, personId: string): readonly RelationshipMemory[] {
  if (!world.people[personId]) throw new Error("Unknown NPC");
  return world.people[personId].memories;
}
