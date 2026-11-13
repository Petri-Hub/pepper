--!strict

-- Public surface: run setup for every character, now and in the future.
--
--   Characters.observe(function(character, player, cleanup)
--       local connection = character:GetAttributeChangedSignal("X"):Connect(...)
--       cleanup.add(function() connection:Disconnect() end)
--   end)
--
-- Everything added to `cleanup` runs when the character is removed, so a feature
-- never has to watch for death or leaving itself.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cleanup = require(ReplicatedStorage.Shared.core.characters.Cleanup)

export type Callback = (character: Model, player: Player, cleanup: Cleanup.Bag) -> ()

local Characters = {}

local callbacks: { Callback } = {}
local tracked: { [Model]: { player: Player, cleanup: Cleanup.Bag } } = {}

local function track(player: Player, character: Model)
	local entry = { player = player, cleanup = Cleanup.new() }
	tracked[character] = entry
	for _, callback in callbacks do
		callback(character, player, entry.cleanup)
	end
end

local function untrack(character: Model)
	local entry = tracked[character]
	tracked[character] = nil
	if entry then
		entry.cleanup.run()
	end
end

function Characters.observe(callback: Callback)
	table.insert(callbacks, callback)
	for character, entry in tracked do
		callback(character, entry.player, entry.cleanup)
	end
end

local function watch(player: Player)
	player.CharacterAdded:Connect(function(character)
		track(player, character)
	end)
	player.CharacterRemoving:Connect(untrack)
	if player.Character then
		track(player, player.Character)
	end
end

Players.PlayerAdded:Connect(watch)
for _, player in Players:GetPlayers() do
	watch(player)
end

return Characters
