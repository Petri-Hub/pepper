--!strict

local Config = require(script.Parent.Config)

local Resolve = {}

-- Modifiers are fractions: +0.5 is 50% faster, -0.45 is 45% slower. They add up.
function Resolve.speed(base: number, modifiers: { [string]: number }): number
	local total = 0
	for _, amount in modifiers do
		total += amount
	end
	return base * math.max(Config.MinFactor, 1 + total)
end

return Resolve
