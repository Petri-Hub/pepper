--!strict

-- The arithmetic, as pure functions: same inputs, same output, no engine access.
-- This is the part Jest can test without Studio.

local Config = require(script.Parent.Config)

local Resolve = {}

function Resolve.canAfford(current: number, cost: number): boolean
	return current >= cost
end

function Resolve.afterSpend(current: number, cost: number): number
	return math.max(0, current - cost)
end

function Resolve.afterRegen(current: number, dt: number, secondsSinceSpend: number): number
	if secondsSinceSpend < Config.RegenDelay then
		return current
	end
	return math.min(Config.Max, current + Config.RegenPerSecond * dt)
end

return Resolve
