--!strict

-- Feel first, truth second: the field-of-view change starts on key press without
-- waiting for the server, and the replicated attribute corrects it if the server
-- disagrees (for example when stamina runs out mid-sprint).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage.Shared.player.sprint.Config)

local player = Players.LocalPlayer
local intent = ReplicatedStorage:WaitForChild(Config.RemoteName) :: RemoteEvent

local function showFieldOfView(sprinting: boolean)
	local camera = workspace.CurrentCamera
	if camera then
		TweenService:Create(camera, TweenInfo.new(0.2), { FieldOfView = if sprinting then 78 else 70 }):Play()
	end
end

local function request(sprinting: boolean)
	intent:FireServer(sprinting)
	showFieldOfView(sprinting) -- prediction
end

UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.LeftShift then
		request(true)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		request(false)
	end
end)

local function watch(character: Model)
	character:GetAttributeChangedSignal(Config.Attribute):Connect(function()
		showFieldOfView(character:GetAttribute(Config.Attribute) == true) -- correction
	end)
end

if player.Character then
	watch(player.Character)
end
player.CharacterAdded:Connect(watch)

return {}
