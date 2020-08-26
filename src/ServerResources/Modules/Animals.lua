local Animals = {}
 
local animals_container = workspace:FindFirstChild("points_container") or Instance.new("Folder", workspace)
animals_container.Name = "animals_container"

local generated_animals = {}



function Animals:CreateNew(animal_name, animal_body)

    self.Name = animal_name
	self.Body = animal_body:Clone()    
	
	
    return self
end

function Animals.Spawn(animal, position, player, database, spawn_object)
    local network_owner = spawn_object:FindFirstChild("network_owner")
    local spawn_value = spawn_object:FindFirstChild("spawn_value")
    local generation_number = spawn_object:FindFirstChild("spawn_number")

    if generated_animals[generation_number] then 
        print("Animal has been printed in server!")
    else

        local spawn = Animals:CreateNew(animal.name, animal)
        spawn.Body:SetPrimaryPartCFrame(position)
        spawn.Body.Parent = animals_container

        generated_animals[generation_number] = spawn.Body

        spawn.Body.PrimaryPart:SetNetworkOwner(player)


        --network_owner.Value = player.Name
        --spawn_object:SetNetworkOwner(player)
        print(spawn_value.Value)
        
        local player_file = database:FindFirstChild(player.Name) or Instance.new("Folder", database)
        if player_file.Name == "Folder" then
            player_file.Name = player.Name
        end

        local animal_object = Instance.new("ObjectValue", player_file)
        animal_object.Value = spawn.Body

    end
end

function Animals.SpawnRequest(player, animal, position)
    local spawn = Animals:CreateNew(animal.name, animal)
    spawn.Body:SetPrimaryPartCFrame(position)
    spawn.Body.Parent = animals_container

    spawn.Body.PrimaryPart:SetNetworkOwner(player)

    return spawn.Body
end

function Animals.Generate()
   -- local new_animal = Animals:CreateNew()
   -- print(new_animal.Name)

end


return Animals
