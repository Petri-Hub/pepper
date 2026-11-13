--!strict

return table.freeze({
	SpeedBonus = 0.5, -- +50% walk speed while sprinting
	DrainPerSecond = 15,
	MinToStart = 10, -- needs at least this much stamina to begin
	TickSeconds = 0.1,
	Modifier = "sprint", -- the name this feature uses with Movement
	Attribute = "Sprinting", -- replicated so the client can correct its prediction
	RemoteName = "SprintIntent",
})
