--!strict

-- Combat decides whether a swing counts. It does not know water, falling or stunned
-- exist: any feature can register an attack blocker, and Combat just asks them.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Signal = require(ReplicatedStorage.Packages.Signal)
local Config = require(ReplicatedStorage.Shared.player.combat.Config)
local Characters = require(ServerScriptService.Server.core.characters)
local Movement = require(ServerScriptService.Server.player.movement)
local Stamina = require(ServerScriptService.Server.player.stamina)

local Combat = {}

Combat.OnSwing = Signal.new() :: Signal.Signal<Model>

local blockers: { [string]: (character: Model) -> boolean } = {}
-- A deadline, not a flag: a swing can never lock a character forever.
local swingingUntil: { [Model]: number } = {}

-- The extension point. Returning true from `isBlocked` stops the swing.
function Combat.addAttackBlocker(name: string, isBlocked: (character: Model) -> boolean)
	blockers[name] = isBlocked
end

local function canSwing(character: Model): boolean
	if os.clock() < (swingingUntil[character] or 0) then
		return false
	end
	for _, isBlocked in blockers do
		if isBlocked(character) then
			return false
		end
	end
	return true
end

local swing = Instance.new("RemoteEvent")
swing.Name = Config.RemoteName
swing.Parent = ReplicatedStorage

swing.OnServerEvent:Connect(function(player: Player)
	local character = player.Character
	if not character or not canSwing(character) then
		return
	end
	if not Stamina.spend(character, Config.SwingCost) then
		return
	end
	swingingUntil[character] = os.clock() + Config.SwingSeconds
	Movement.setModifier(character, Config.SlowModifier, Config.SwingSlow)
	task.delay(Config.SwingSeconds, function()
		Movement.clearModifier(character, Config.SlowModifier)
	end)
	Combat.OnSwing:Fire(character)
	-- Damage resolution goes here: the server decides who was hit and for how much.
end)

Characters.observe(function(character, _player, cleanup)
	cleanup.add(function()
		swingingUntil[character] = nil
	end)
end)

return Combat
