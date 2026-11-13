--!strict

-- The client only draws. It reads the replicated attribute and never decides anything.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.player.stamina.Config)

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "StaminaBar"
gui.ResetOnSpawn = false

local back = Instance.new("Frame")
back.AnchorPoint = Vector2.new(0.5, 1)
back.Position = UDim2.new(0.5, 0, 1, -90)
back.Size = UDim2.fromOffset(240, 6)
back.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
back.BorderSizePixel = 0
back.Parent = gui

local fill = Instance.new("Frame")
fill.Size = UDim2.fromScale(1, 1)
fill.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
fill.BorderSizePixel = 0
fill.Parent = back

local function bind(character: Model)
	local function update()
		local value = character:GetAttribute(Config.Attribute)
		if typeof(value) == "number" then
			fill.Size = UDim2.fromScale(math.clamp(value / Config.Max, 0, 1), 1)
		end
	end
	-- The connection lives on the character, so it goes away with the character.
	character:GetAttributeChangedSignal(Config.Attribute):Connect(update)
	update()
end

if player.Character then
	bind(player.Character)
end
player.CharacterAdded:Connect(bind)

gui.Parent = player:WaitForChild("PlayerGui")
