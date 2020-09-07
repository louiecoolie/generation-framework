local Rocks = {}

local rocks_container = workspace:FindFirstChild("rocks_container") or Instance.new("Folder", workspace)
rocks_container.Name = "rocks_container"


local generated_rocks = {}

function Rocks.Create(rock, position, spawn_object)
    local generation_number = spawn_object:FindFirstChild("spawn_number")

    if generated_rocks[generation_number] then 
        print("Rock has been printed in server!")
    else
        if rock then

            local rock_request = rock:Clone()
            local load_bool = Instance.new("BoolValue", rock_request)
            load_bool.Name = "load_bool"
            load_bool.Value = true
            local rock_scan = Ray.new(position.Position, -position.UpVector * 100)
            local ignore_list = {}
            for _, animal in pairs(workspace:FindFirstChild("animals_container"):GetChildren()) do
                table.insert(ignore_list, animal)
            end

            for _, plant in pairs(workspace:FindFirstChild("plants_container"):GetChildren()) do
                table.insert(ignore_list, plant)
            end
    
            table.insert(ignore_list, rock_request)
    
            local _, rock_position = workspace:FindPartOnRayWithIgnoreList(rock_scan, ignore_list)
            
            local rock_cframe = CFrame.new(rock_position.X, rock_position.Y + (rock_request.PrimaryPart.Size.Y/2), rock_position.Z)
            rock_request:SetPrimaryPartCFrame(rock_cframe)
            rock_request.PrimaryPart.Anchored = true
            rock_request.Parent = rocks_container

           -- CreateTree(plant_request)

           generated_rocks[generation_number] = rock_request
        end
    end

end


return Rocks


