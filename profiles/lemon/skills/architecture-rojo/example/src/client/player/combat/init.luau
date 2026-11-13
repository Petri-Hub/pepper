--!strict

-- The swing looks instant because the client starts its feedback immediately. The
-- server still decides whether the swing counts and what it hits.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage.Shared.player.combat.Config)

local swing = ReplicatedStorage:WaitForChild(Config.RemoteName) :: RemoteEvent

local function playSwingFeedback()
	-- Start the animation, sound and trail here, without waiting for the server.
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed or input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end
	playSwingFeedback()
	swing:FireServer()
end)

return {}
