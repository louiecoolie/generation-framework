local Plants = {}

local plants_container = workspace:FindFirstChild("plants_container") or Instance.new("Folder", workspace)
plants_container.Name = "plants_container"


local generated_plants = {}

function Plants.Grow(plant, position, spawn_object)
    local generation_number = spawn_object:FindFirstChild("spawn_number")

    if generated_plants[generation_number] then 
        print("Plant has been printed in server!")
    else
        if plant then
            print(plant.PrimaryPart)
            local plant_request = plant:Clone()
            local plant_scan = Ray.new(position.Position, -position.UpVector * 10)
            local ignore_list = {}
            for _, animal in pairs(workspace:FindFirstChild("animals_container"):GetChildren()) do
                table.insert(ignore_list, animal)
            end
    
            table.insert(ignore_list,plant_request)
    
            local _, plant_position = workspace:FindPartOnRayWithIgnoreList(plant_scan, ignore_list)
            print(plant_position, position.Position)
            local plant_cframe = CFrame.new(plant_position.X, plant_position.Y + (plant_request.PrimaryPart.Size.Y/2), plant_position.Z)
            plant_request:SetPrimaryPartCFrame(plant_cframe)
            plant_request.PrimaryPart.Anchored = true
            plant_request.Parent = plants_container

            generated_plants[generation_number] = plant_request
        end
    end

end



return Plants


