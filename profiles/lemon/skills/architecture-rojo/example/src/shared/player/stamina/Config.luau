--!strict

-- Numbers the group might want to feel differently live here, never inline.
return table.freeze({
	Max = 100,
	RegenPerSecond = 18,
	RegenDelay = 1.0, -- seconds after spending before regeneration starts
	TickSeconds = 0.1, -- how often the server regenerates and replicates the value
	Attribute = "Stamina", -- the character attribute the client reads
})
