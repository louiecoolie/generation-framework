-- services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ClientModules = script.Parent.Parent:WaitForChild("Modules", 60)
local ClientEvents = game:GetService("ReplicatedStorage"):WaitForChild("Events", 60)

local Events = {}
local Modules = {}
-- event declarations
for _, event in ipairs(ClientEvents:GetChildren()) do
    ClientEvents:WaitForChild(event.Name, 5)

end

for _, event in ipairs(ClientEvents:GetChildren()) do
	Events[event.Name] = event
	
end

for _, module in ipairs(ClientModules:GetChildren()) do
    ClientModules:WaitForChild(module.Name, 5)
 
end

for _, module in ipairs(ClientModules:GetChildren()) do
        Modules[module.Name] = require(module)

end

-- player data
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:wait()


-- client system data
-- container to hold initialized connections to disconnect later at death or when necessary
local init = {}
local connections = {}

function init.GenerateClient()

end

function init.CreateConnections()
end

function init.Disconnect()
	for _, object in pairs(connections) do
		if object then
			object:Disconnect()
		end
	end
end

function init.EstablishConnections()
	local spawn_points = workspace:WaitForChild("points_container", 60):GetChildren()
	

	connections.UpdateAnimalRender = RunService.Heartbeat:Connect(function()
		local animals = workspace:FindFirstChild("animals_container")
		local plants = workspace:FindFirstChild("plants_container")

		if plants and char then
			Modules["UpdateArea"].UpdatePlantRender(char, plants:GetChildren())
		end

		if animals and char then
			Modules["UpdateArea"].UpdateAnimalRender(char, animals:GetChildren())
		end
	

	end)


	connections.ScanSpawns = RunService.Heartbeat:Connect(function()

		local Scan = Modules["UpdateArea"].Scan(char, 20, spawn_points)
	
		for _, object in pairs(Scan) do
			if object.Name == "spawn_point" then
				local request_value = object:FindFirstChild("request_value")
				local spawn_value = object:FindFirstChild("spawn_value")
				local plant_value = object:FindFirstChild("plant_value")

				if request_value.Value == "nil" then
					request_value.Value = "true"
					--print(spawn_value.Value .. " " .. network_owner.Value)
					if spawn_value.Value then
						Events["animal_request"]:FireServer(spawn_value.Value, object.CFrame, object)
					end
					if plant_value.Value then
						Events["plant_request"]:FireServer(plant_value.Value, object.CFrame, object)
						print(plant_value.Value)
					end
				end
			end
		end
	end)    
end


function init.StartClient()
    --init.GenerateClient()
    --init.CreateConnections()
    init.EstablishConnections()
end

init.StartClient()



