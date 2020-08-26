-- testing purposes
local fish

-- services
local Assets = game:GetService("ReplicatedStorage"):WaitForChild("Assets", 10)
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ClientModules = script.Parent.Parent:WaitForChild("Modules", 60)

local ClientEvents = game:GetService("ReplicatedStorage"):WaitForChild("Events", 60)
local ClientDatabase = game:GetService("ReplicatedStorage"):WaitForChild("Database", 60)
-- event declarations

for _, event in ipairs(ClientEvents:GetChildren()) do
    ClientEvents:WaitForChild(event.Name, 5)
    print(event.Name)
end

local Events = {}

for _, event in ipairs(ClientEvents:GetChildren()) do
	Events[event.Name] = event
	
end


-- module declarations

--local Modules = script.Parent.Parent:WaitForChild("Modules", 60)
-- wait for modules to load
for _, module in ipairs(ClientModules:GetChildren()) do
    ClientModules:WaitForChild(module.Name, 5)
 
end

print("connected")

local Modules = {}
-- require/initialize modules
for _, module in ipairs(ClientModules:GetChildren()) do
        Modules[module.Name] = require(module)

end

-- player data
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:wait()
local hum = char:WaitForChild("Humanoid", 3)

--hum:ChangeState(Enum.HumanoidStateType.Physics)

-- camera data
local camera = workspace.CurrentCamera
local camera_mode = "fly"

-- client system data
-- container to hold initialized connections to disconnect later at death or when necessary
local init = {}
local connections = {}

function init.GenerateClient()
	fish =  Events["spawn_request"]:InvokeServer(Assets.Animal:FindFirstChild("Guppy"), CFrame.new(0,3,0))

	--Modules["Camera"].Mode(camera, "locked")
end

function init.CreateConnections()
	ContextActionService:BindAction("left", Modules["Physics"].IntrepretInput, false, Enum.KeyCode.A)
	ContextActionService:BindAction("right", Modules["Physics"].IntrepretInput, false, Enum.KeyCode.D)
	ContextActionService:BindAction("forward", Modules["Physics"].IntrepretInput, false, Enum.KeyCode.W)
	ContextActionService:BindAction("backward", Modules["Physics"].IntrepretInput, false, Enum.KeyCode.S)
	ContextActionService:BindAction("roll_left", Modules["Physics"].IntrepretInput, false, Enum.KeyCode.Q)
	ContextActionService:BindAction("roll_right", Modules["Physics"].IntrepretInput, false, Enum.KeyCode.E)
	ContextActionService:BindAction("move", Modules["Physics"].IntrepretInput, false, Enum.KeyCode.F)
	ContextActionService:BindAction("float", Modules["Physics"].IntrepretInput, false, Enum.KeyCode.Space)
	--self.AnimalRequest = Modules["Request"].RemoteEvent("animal_request", Events) --print(UpdateArea.Scan(char))
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
	local animals_container = workspace:WaitForChild("animals_container", 60)
	local animals = {}



	if char then
		char:FindFirstChild("Humanoid").Died:Connect(function()
			print("Humanoid has died")
			init:Disconnect()
		end)
	end

	for _, animal in pairs(animals_container:GetChildren()) do
		animals[(#animals + 1)] = animal:WaitForChild("RigidBody", 5)
	end

	animals_container.ChildAdded:Connect(function(child)
		--animals[(#animals + 1)] = child:WaitForChild("RigidBody", 5)
	end)

	connections.Physics = RunService.Heartbeat:Connect(function()
		local player_file = ClientDatabase.Player:FindFirstChild(char.Name)

		if player_file then
			Modules["Physics"].UpdateAnimals(player_file:GetChildren(), char.PrimaryPart)
		end
		--if player_ownership then
			--for _, animal in pairs(player_ownership) do
				--print(animal)
			--end
		--end


		if fish then
			Modules["Physics"].Control(fish.PrimaryPart, fish.PrimaryPart:FindFirstChild("BodyGyro"))
		else
			--init:Disconnect()
		end
	
	end)

	connections.Scanner = RunService.Heartbeat:Connect(function()
		for _, animal in pairs(animals_container:GetChildren()) do
			animals[(#animals + 1)] = animal:WaitForChild("RigidBody", 5)
		end


		local Scan = Modules["UpdateArea"].Scan(char, 20, spawn_points)
		local AnimalScan = Modules["UpdateArea"].Scan(char, 20, animals)
		--local Search = Modules["UpdateArea"].Search(char, spawn_points)
		for _, object in pairs(Scan) do
			if object.Name == "spawn_point" then
				local network_owner = object:FindFirstChild("network_owner")
				local spawn_value = object:FindFirstChild("spawn_value")

				if network_owner.Value == "nil" then
					network_owner.Value = plr.Name
					--print(spawn_value.Value .. " " .. network_owner.Value)
					Events["animal_request"]:FireServer(spawn_value.Value, object.CFrame, object)
				end
			end
		end

		for _, animal in pairs(AnimalScan) do
			
			local animal_distance = (char.PrimaryPart.Position - animal.Parent.PrimaryPart.Position).Magnitude
			if animal_distance < 10 then
				--print(animal .. " " .. animal_distance)
				Modules["Physics"].AnimalBehavior("Run", animal.Parent, char.PrimaryPart)
			end
		end
		--print(Scan)
	end)    --print(UpdateArea.Scan(char))
	connections.Camera = RunService.Heartbeat:Connect(function()
		if fish then
			Modules["Camera"].Update(camera, camera_mode, fish, input_object)
		else
			--init:Disconnect()
		end
		--
	end)
	connections.CameraDelta = UserInputService.InputChanged:Connect(function(input_object)
		if fish then
			Modules["Camera"].CalculateDelta(input_object, fish)
			Modules["Physics"].CalculateDelta(input_object, fish.PrimaryPart:FindFirstChild("BodyGyro"))
		else
			--init:Disconnect()
		end
	end)

end



--init:EstablishConnections()

function init.StartClient()
    --init.GenerateClient()
    --init.CreateConnections()
    init.EstablishConnections()
end

init.StartClient()

plr.CharacterAdded:Connect(function()
	init.StartClient()
end)

