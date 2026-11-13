--!strict

-- Water was added after Combat, Movement and Stamina existed, and edits none of them:
-- it slows the character through Movement's modifiers and blocks swings through
-- Combat's blocker hook. Adding it created files only inside player/water/.

local ServerScriptService = game:GetService("ServerScriptService")

local Characters = require(ServerScriptService.Server.core.characters)
local Combat = require(ServerScriptService.Server.player.combat)
local Movement = require(ServerScriptService.Server.player.movement)

local MODIFIER = "water"
local SLOW = -0.4
local ATTRIBUTE = "InWater"

Combat.addAttackBlocker("water", function(character)
	return character:GetAttribute(ATTRIBUTE) == true
end)

Characters.observe(function(character, _player, cleanup)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	local connection = humanoid.StateChanged:Connect(function(_old, new)
		local swimming = new == Enum.HumanoidStateType.Swimming
		character:SetAttribute(ATTRIBUTE, swimming)
		if swimming then
			Movement.setModifier(character, MODIFIER, SLOW)
		else
			Movement.clearModifier(character, MODIFIER)
		end
	end)
	cleanup.add(function()
		connection:Disconnect()
	end)
end)

return {}
