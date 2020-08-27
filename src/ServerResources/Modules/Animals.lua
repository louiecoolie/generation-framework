local Animals = {}
 
local animals_container = workspace:FindFirstChild("animals_container") or Instance.new("Folder", workspace)
animals_container.Name = "animals_container"

local generated_animals = {}

local turn = nil
local walk = nil

function Animals:CreateNew(animal_name, animal_body)

    self.Name = animal_name
	self.Body = animal_body:Clone()    
	
	
    return self
end

function Animals.Spawn(animal, position, player, database, spawn_object)
    local generation_number = spawn_object:FindFirstChild("spawn_number").Value

    if generated_animals[generation_number] then 
        print("Animal has been printed in server!")
    else
        if animal then


            local spawn = Animals:CreateNew(animal.name, animal)
            spawn.Body:SetPrimaryPartCFrame(position)
            spawn.Body.Parent = animals_container
            
            local load_bool = Instance.new("BoolValue", spawn.Body)
            load_bool.Name = "load_bool"
            load_bool.Value = true

            generated_animals[generation_number] = spawn.Body
        end
    end
end



function Animals.AnimalBehavior(behavior, animal, player_body)
    local animal_body = animal.PrimaryPart
    
    if behavior == "Run" then
        local orientation_frame = CFrame.new(animal_body.CFrame.Position, Vector3.new(player_body.Position.X, animal_body.CFrame.Position.Y, player_body.Position.Z)) * CFrame.Angles(0, math.rad(180), 0)
        animal:SetPrimaryPartCFrame(orientation_frame)
        animal_body.Velocity = animal_body.CFrame.LookVector * 15
    elseif behavior == "Idle" then
        local turn_chance = math.random(0,1000)
        local walk_chance = math.random(0,1000)

        local turn_cframe = animal_body.CFrame * CFrame.Angles(-math.rad(animal_body.Orientation.X),math.rad(1),-math.rad(animal_body.Orientation.Z))
        if turn_chance > 999 then
                --print("turn")
            if turn == false then
                turn = true
            else
                turn = false 
            end
                
                
        end

        if walk_chance > 99 then
            if walk == true then
                walk = false
            else
                walk = true
            end
                
        end


        if walk then
            animal_body.Velocity = animal_body.Velocity + (animal_body.CFrame.LookVector * .5)
        end

        if turn then
            animal:SetPrimaryPartCFrame(turn_cframe)
        end
    end
end


function Animals.UpdateAnimals(player_list)
    --print(animal_list[animal_index])
   for index, object in pairs(generated_animals) do
        local animal = object
        if animal.PrimaryPart then
            for _, player in pairs(player_list) do
                if player then
                    local player_body = player.PrimaryPart
                    
                    local animal_distance = (player_body.Position - animal.PrimaryPart.Position).Magnitude
                    local animal_body = animal.PrimaryPart
                    local update_cframe = animal_body.CFrame * CFrame.Angles(-math.rad(animal_body.Orientation.X),0,-math.rad(animal_body.Orientation.Z))
                    animal:SetPrimaryPartCFrame(update_cframe)
                    --print(animal_distance)
                    if animal_distance < 10 then
                        Animals.AnimalBehavior("Run", animal, player_body)
                    elseif animal_distance < 30 then
                        Animals.AnimalBehavior("Idle", animal, player_body)
                    end
                end
            end
        else
            table.remove(generated_animals, index)
        end
    end
end










return Animals
