# Visualized LineTrace for GZDoom

A mini-library / example for the GZDoom engine that adds functions to draw a series of particles between two coordinates, and a version of LineTrace() that is visualized with those particles.

The functions are static, contained within the `JGP_VisualTrace`.

```csharp
FireVisualTracer(Actor originator, double dist, int flags = 0, double partDist = 1, int partTics = 1, color partColor = color("00FF00"))
```

Fires a LineTrace from the originator and draws particle along its length. Parameters:

* `originator` — the actor the trace originates from. If it's a PlayerPawn, it'll fire fire from its eye height (matching the position of its crosshair), otherwise fires from actor center.

* `dist` — the distance of the trace

* `flags` — same flags as [`LineTrace()`](https://zdoom.org/wiki/LineTrace) uses

* `partDist` — distance between particles

* `partTics` — how long the particles should exist

* `partColor` — the color of the particles.

```csharp
DrawParticlesBetweenPoints(vector3 startpos, vector3 endpos, double partDist = 1, int partTics = 1, color partColor = color("00FF00"), int flags = SPF_FULLBRIGHT|SPF_NOTIMEFREEZE)
```

Draws a line of particles between two points. `FireVisualTracer` utilizes this function. 

Parameters:

* `startpos` — coordinates of the first point

* `endpos` — coordinates of the last point

* `partDist` — distance between particles

* `partTics` — how long the particles should exist

* `partColor` — the color of the particles.

* `flags` — same flags as [`A_SpawnParticle`](https://zdoom.org/wiki/A_SpawnParticle) uses. `SPF_FULLBRIGHT` and `SPF_NOTIMEFREEZE` are enabled by default.

Comes with two examples: `JGP_TraceFromFace` (an item that will fire a linetrace in the direction its owner is looking) and `JGP_ZombiemanWithTrace` (a Zombieman that constantly fires a trace wherever it's aiming).
