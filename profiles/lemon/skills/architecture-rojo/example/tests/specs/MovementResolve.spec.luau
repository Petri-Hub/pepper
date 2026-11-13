local root = script.Parent.Parent
local JestGlobals = require(root.DevPackages.JestGlobals)
local Config = require(game:GetService("ReplicatedStorage").Shared.player.movement.Config)
local Resolve = require(game:GetService("ReplicatedStorage").Shared.player.movement.Resolve)

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

describe("movement resolve", function()
	it("keeps the base speed with no modifiers", function()
		expect(Resolve.speed(16, {})).toBe(16)
	end)

	it("adds modifiers together", function()
		expect(Resolve.speed(20, { sprint = 0.5, swinging = -0.25 })).toBe(25)
	end)

	it("never drops below the minimum factor", function()
		expect(Resolve.speed(16, { water = -0.9, swinging = -0.9 })).toBe(16 * Config.MinFactor)
	end)
end)
