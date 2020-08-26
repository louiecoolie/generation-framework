local Resources = game:GetService("ServerStorage")
local Assets = Resources:FindFirstChild("Assets")
local ServerModules = Resources:WaitForChild("Modules", 60)
local RunService = game:GetService("RunService")
--local Database = Resources:WaitForChild("Database", 60)

local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events", 60)
local Database = game:GetService("ReplicatedStorage"):WaitForChild("Database", 60)
-- module declarations
-- wait for modules to load
for _, module in ipairs(ServerModules:GetChildren()) do
    ServerModules:WaitForChild(module.Name, 30)
    print(module.Name)
end

local Modules = {}
-- require/initialize modules
for _, module in ipairs(ServerModules:GetChildren()) do
        Modules[module.Name] = require(module)
        print(module.Name)
end

local init = {}
local connections = {}

function init.GenerateServer()
    Modules["Generate"].AnimalSpawns(Vector3.new(0,4,0), 30, 10, 0, "Doe")
end

function init:CreateConnections()

	self.AnimalRequest = Modules["Request"].RemoteEvent("animal_request", Events) --print(UpdateArea.Scan(char))
end

function init:EstablishConnections()
    connections.Animals = self.AnimalRequest.OnServerEvent:Connect(function(player, animal, position, spawn_object)
            Modules["Animals"].Spawn(Assets.Animal:FindFirstChild(animal), position, player, Database.Player, spawn_object)
            
    end)

    connections.UpdatePlayers = RunService.Heartbeat:Connect(function()

            local players_container = workspace:FindFirstChild("players_container") or Instance.new("Folder", workspace)
            players_container.Name = "players_container"
            for _, player in pairs(game.Players:GetChildren()) do
                if workspace:FindFirstChild(player.Name) then
                    player.Character.Parent = players_container
                end
            end

    end)

    connections.UpdateAnimals = RunService.Heartbeat:Connect(function()
        if workspace:FindFirstChild("players_container") then
            Modules["Animals"].UpdateAnimals(workspace:FindFirstChild("players_container"):GetChildren())
        end
    end)



end

function init.StartServer()
    init.GenerateServer()
    init:CreateConnections()
    init:EstablishConnections()
end

init.StartServer()