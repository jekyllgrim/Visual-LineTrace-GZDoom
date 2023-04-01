version "4.8.0"

// The main utils class:
class JGP_VisualTrace play abstract
{

	// This fires a tracer and draws particles along
	// its distance.
	// partDist determines how far the particles are
	// partTics determines for how long they will exist
	static void FireVisualTracer(Actor originator, double dist, int flags = 0, double partDist = 1, int partTics = 1, color partColor = color("00FF00"))
	{
		if (!originator || dist <= 0)
			return;
		
		// By default the trace will originate
		// from the actor's center:
		double atkheight = originator.height * 0.5;
		
		// If the actor is a PlayerPawn, originate
		// the tracer from their attack height instead:
		let ppawn = PlayerPawn(originator);
		if (ppawn)
		{
			atkheight = JGP_VisualTrace.GetPlayerAtkHeight(ppawn);
		}
		
		// Do the trace:
		FLineTracedata tr;
		originator.LineTrace(originator.angle, dist, originator.pitch, flags, atkheight, data: tr);
		
		// Get start and end positions:
		vector3 startpos = originator.pos + (0,0, atkheight);
		vector3 endpos = tr.HitLocation;
		
		// Get the vector between them and normalize it:
		let diff = Level.Vec3Diff(startpos, endpos);
		let dir = diff.Unit();
		
		// Make sure distance between particles is no less
		// than 1. From that, get how many particles
		// we'll need to spawn:
		partDist = Clamp(partDist, 1., dist);
		int partSteps = int(tr.Distance / partDist);
		
		// Spawn the particles:
		vector3 nextPos = startpos;
		FSpawnParticleParams traceParticle;
		traceParticle.color1 = partColor;
		traceParticle.lifetime = partTics;		
		traceParticle.size = 1;
		traceParticle.StartAlpha = 1;
		traceParticle.flags = SPF_FULLBRIGHT|SPF_NOTIMEFREEZE;
		for (int i = 1; i <= partSteps; i++)
		{
			traceParticle.pos = nextPos;
			Level.Spawnparticle(traceParticle);
			nextPos += dir * partDist;
		}
	}
	
	// This gets the exact attack height of the
	// giver PlayerPawn:
	static double GetPlayerAtkHeight(PlayerPawn ppawn)
	{
		if (!ppawn)
			return 0;
		let player = ppawn.player;
		if (!player)
			return 0;
		return ppawn.height * 0.5 - ppawn.floorclip + ppawn.AttackZOffset*player.crouchFactor;
	}
}

// Demo class: give this item to yourself
// to start emitting a trace from your face
// towards the point you're aiming at,
// or give it to another actor to have them
// fire a trace from their center:
class JGP_TraceFromFace : Inventory
{
	override void Tick() {}

	override void DoEffect()
	{
		super.DoEffect();
		if (!owner)
		{
			Destroy();
			return;
		}
		
		JGP_VisualTrace.FireVisualTracer(owner, 400);
	}
}

// An example of a monster firing a linetrace
// from their center:
class JGP_ZombiemanWithTrace : Zombieman
{
	override void Tick()
	{
		super.Tick();
		JGP_VisualTrace.FireVisualTracer(self, 256, partDist: 2);
	}
}