local root = script.Parent.Parent
local JestGlobals = require(root.DevPackages.JestGlobals)
local Cleanup = require(game:GetService("ReplicatedStorage").Shared.core.characters.Cleanup)

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

describe("Cleanup", function()
	it("runs the undo functions newest first", function()
		local order = {}
		local bag = Cleanup.new()
		bag.add(function()
			table.insert(order, "first")
		end)
		bag.add(function()
			table.insert(order, "second")
		end)

		bag.run()

		expect(order).toEqual({ "second", "first" })
	end)

	it("runs only once", function()
		local count = 0
		local bag = Cleanup.new()
		bag.add(function()
			count += 1
		end)

		bag.run()
		bag.run()

		expect(count).toBe(1)
	end)

	it("undoes right away when added after the bag has run", function()
		local ran = false
		local bag = Cleanup.new()
		bag.run()

		bag.add(function()
			ran = true
		end)

		expect(ran).toBe(true)
	end)
end)
