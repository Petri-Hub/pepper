--!strict

-- Starts every client feature: each ModuleScript at
-- PlayerScripts.Client.<family>.<feature> is required once. A feature wires itself
-- up when it loads, so adding one never means editing this file.

for _, family in script:GetChildren() do
	for _, feature in family:GetChildren() do
		if feature:IsA("ModuleScript") then
			local ok, message = pcall(require, feature)
			if not ok then
				warn(`[features] {family.Name}.{feature.Name} failed to start: {message}`)
			end
		end
	end
end
