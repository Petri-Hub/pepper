--!strict

-- Stamina owns the stamina value. Nothing else writes it: other features call
-- `spend` or `drain` and listen to `OnDepleted`.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Signal = require(ReplicatedStorage.Packages.Signal)
local Config = require(ReplicatedStorage.Shared.player.stamina.Config)
local Resolve = require(ReplicatedStorage.Shared.player.stamina.Resolve)
local Characters = require(ServerScriptService.Server.core.characters)

type Record = { value: number, lastSpend: number }

local Stamina = {}

-- A fact, not a command: listeners decide what depletion means for them.
Stamina.OnDepleted = Signal.new() :: Signal.Signal<Model>

local records: { [Model]: Record } = {}

local function apply(character: Model, record: Record, newValue: number)
	local before = record.value
	record.value = newValue
	record.lastSpend = os.clock()
	character:SetAttribute(Config.Attribute, newValue)
	if before > 0 and newValue <= 0 then
		Stamina.OnDepleted:Fire(character)
	end
end

function Stamina.get(character: Model): number?
	local record = records[character]
	return record and record.value
end

-- All or nothing: returns false and changes nothing when the cost cannot be paid.
function Stamina.spend(character: Model, cost: number): boolean
	local record = records[character]
	if not record or not Resolve.canAfford(record.value, cost) then
		return false
	end
	apply(character, record, Resolve.afterSpend(record.value, cost))
	return true
end

-- Takes what is there, up to `amount`, and returns what is left. For continuous costs.
function Stamina.drain(character: Model, amount: number): number
	local record = records[character]
	if not record then
		return 0
	end
	apply(character, record, Resolve.afterSpend(record.value, amount))
	return record.value
end

Characters.observe(function(character, _player, cleanup)
	records[character] = { value = Config.Max, lastSpend = 0 }
	character:SetAttribute(Config.Attribute, Config.Max)
	cleanup.add(function()
		records[character] = nil
	end)
end)

-- One loop for everyone, ten times a second. Never replicate per frame.
task.spawn(function()
	while true do
		local dt = task.wait(Config.TickSeconds)
		for character, record in records do
			local regenerated = Resolve.afterRegen(record.value, dt, os.clock() - record.lastSpend)
			if regenerated ~= record.value then
				record.value = regenerated
				character:SetAttribute(Config.Attribute, regenerated)
			end
		end
	end
end)

return Stamina
