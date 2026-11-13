--!strict

-- Sprint owns nothing except the "is sprinting" flag. It spends Stamina's value and
-- asks Movement for speed, both through their public surfaces.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Config = require(ReplicatedStorage.Shared.player.sprint.Config)
local Characters = require(ServerScriptService.Server.core.characters)
local Movement = require(ServerScriptService.Server.player.movement)
local Stamina = require(ServerScriptService.Server.player.stamina)

local sprinting: { [Model]: boolean } = {}

local function stop(character: Model)
	if sprinting[character] then
		sprinting[character] = nil
		Movement.clearModifier(character, Config.Modifier)
		character:SetAttribute(Config.Attribute, false)
	end
end

local function start(character: Model)
	local available = Stamina.get(character)
	if sprinting[character] or not available or available < Config.MinToStart then
		return
	end
	sprinting[character] = true
	Movement.setModifier(character, Config.Modifier, Config.SpeedBonus)
	character:SetAttribute(Config.Attribute, true)
end

-- The client sends intent. The server validates it and decides.
local intent = Instance.new("RemoteEvent")
intent.Name = Config.RemoteName
intent.Parent = ReplicatedStorage

intent.OnServerEvent:Connect(function(player: Player, wantsSprint: unknown)
	local character = player.Character
	if not character or typeof(wantsSprint) ~= "boolean" then
		return
	end
	if wantsSprint then
		start(character)
	else
		stop(character)
	end
end)

-- Running out of stamina ends the sprint; Stamina does not know sprint exists.
Stamina.OnDepleted:Connect(stop)

Characters.observe(function(character, _player, cleanup)
	cleanup.add(function()
		sprinting[character] = nil
	end)
end)

task.spawn(function()
	while true do
		local dt = task.wait(Config.TickSeconds)
		for character in sprinting do
			Stamina.drain(character, Config.DrainPerSecond * dt)
		end
	end
end)

return {}
