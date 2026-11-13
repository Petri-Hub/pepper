--!strict

-- Movement is the only writer of Humanoid.WalkSpeed. Features add and remove named
-- modifiers; this module turns the active ones into a single speed. Two features
-- can therefore never fight over the number.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Config = require(ReplicatedStorage.Shared.player.movement.Config)
local Resolve = require(ReplicatedStorage.Shared.player.movement.Resolve)
local Characters = require(ServerScriptService.Server.core.characters)

local Movement = {}

local modifiers: { [Model]: { [string]: number } } = {}

local function apply(character: Model)
	local active = modifiers[character]
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if active and humanoid then
		humanoid.WalkSpeed = Resolve.speed(Config.BaseWalkSpeed, active)
	end
end

function Movement.setModifier(character: Model, name: string, amount: number)
	local active = modifiers[character]
	if active then
		active[name] = amount
		apply(character)
	end
end

function Movement.clearModifier(character: Model, name: string)
	local active = modifiers[character]
	if active then
		active[name] = nil
		apply(character)
	end
end

Characters.observe(function(character, _player, cleanup)
	modifiers[character] = {}
	apply(character)
	cleanup.add(function()
		modifiers[character] = nil
	end)
end)

return Movement
