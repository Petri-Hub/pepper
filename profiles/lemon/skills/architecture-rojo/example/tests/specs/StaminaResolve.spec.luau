local root = script.Parent.Parent
local JestGlobals = require(root.DevPackages.JestGlobals)
local Config = require(game:GetService("ReplicatedStorage").Shared.player.stamina.Config)
local Resolve = require(game:GetService("ReplicatedStorage").Shared.player.stamina.Resolve)

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

describe("stamina resolve", function()
	it("refuses a cost the character cannot pay", function()
		expect(Resolve.canAfford(10, 15)).toBe(false)
		expect(Resolve.canAfford(15, 15)).toBe(true)
	end)

	it("never goes below zero", function()
		expect(Resolve.afterSpend(5, 20)).toBe(0)
	end)

	it("waits for the regen delay before recovering", function()
		expect(Resolve.afterRegen(50, 1, Config.RegenDelay - 0.1)).toBe(50)
		expect(Resolve.afterRegen(50, 1, Config.RegenDelay)).toBe(50 + Config.RegenPerSecond)
	end)

	it("never recovers past the maximum", function()
		expect(Resolve.afterRegen(Config.Max - 1, 10, Config.RegenDelay)).toBe(Config.Max)
	end)
end)
