--!strict

-- A bag of things to undo later: disconnect a listener, remove a record, destroy an
-- instance. A feature adds to the bag when it sets something up for a character, and
-- `run` releases all of it, newest first, when that character goes away.

export type Bag = {
	add: (undo: () -> ()) -> (),
	run: () -> (),
}

local Cleanup = {}

function Cleanup.new(): Bag
	local pending: { () -> () } = {}
	local finished = false

	local function add(undo: () -> ())
		if finished then
			undo() -- the character is already gone: undo right away
			return
		end
		table.insert(pending, undo)
	end

	local function run()
		if finished then
			return
		end
		finished = true
		for index = #pending, 1, -1 do
			pending[index]()
		end
		table.clear(pending)
	end

	return { add = add, run = run }
end

return Cleanup
