local Plants = {}

local plants_container = workspace:FindFirstChild("plants_container") or Instance.new("Folder", workspace)
plants_container.Name = "plants_container"


local generated_plants = {}

function CreateTree(plant)
    local forage_value = Instance.new("BoolValue")
    forage_value.Name = "forage_value"
    forage_value.Value = true
    plant:SetPrimaryPartCFrame((plant.PrimaryPart.CFrame*CFrame.Angles(math.rad(math.random(-15,15)),0,0)*CFrame.new(0,-1,0)))
    local limbs = {}
    for i = 1,6,2 do
        local limb = plant.PrimaryPart:Clone()
        limb.CFrame = limb.CFrame * CFrame.new(0, limb.Size.Y/3, 0)*CFrame.Angles(0, i, 0) * CFrame.Angles(math.rad(45),0,0)*CFrame.new(0, limb.Size.Y/2, 0)
        
        limb.Parent = plant 
        table.insert(limbs, limb)
    end

    for _, limb in pairs(limbs) do
        for i = 1,6,3 do
            local branch = limb:Clone()
            branch.CFrame = branch.CFrame * CFrame.new(0, branch.Size.Y/3, 0)*CFrame.Angles(0, i, 0) * CFrame.Angles(math.rad(45),0,0)*CFrame.new(0, branch.Size.Y/2, 0)
            local leaf = branch:Clone()
            leaf.Color = Color3.new(40, 127, 71)
            leaf.Size = Vector3.new(10,10,10)
            leaf.Transparency = 0.5
            leaf.CFrame = leaf.CFrame * CFrame.new(0, leaf.Size.Y/2, 0)
            leaf.CanCollide = false
            --leaf.CFrame * CFrame.new(0, leaf.Size.Y/3, 0)*
            leaf.Parent = plant
            leaf.Name = "leaf"
            branch.Parent = plant 
        end
    end

    for _, part in pairs(plant:GetChildren()) do
        if part:IsA("BasePart") then
            local forage = forage_value:Clone()
            forage.Parent = part
        end
    end

end







function Plants.Grow(plant, position, spawn_object)
    local generation_number = spawn_object:FindFirstChild("spawn_number")

    if generated_plants[generation_number] then 
        print("Plant has been printed in server!")
    else
        if plant then

            local plant_request = plant:Clone()
            local load_bool = Instance.new("BoolValue", plant_request)
            load_bool.Name = "load_bool"
            load_bool.Value = true
            local plant_scan = Ray.new(position.Position, -position.UpVector * 100)
            local ignore_list = {}
            for _, animal in pairs(workspace:FindFirstChild("animals_container"):GetChildren()) do
                table.insert(ignore_list, animal)
            end
    
            table.insert(ignore_list,plant_request)
    
            local _, plant_position = workspace:FindPartOnRayWithIgnoreList(plant_scan, ignore_list)
            
            local plant_cframe = CFrame.new(plant_position.X, plant_position.Y + (plant_request.PrimaryPart.Size.Y/2), plant_position.Z)
            plant_request:SetPrimaryPartCFrame(plant_cframe)
            plant_request.PrimaryPart.Anchored = true
            plant_request.Parent = plants_container

            CreateTree(plant_request)

            generated_plants[generation_number] = plant_request
        end
    end

end



return Plants


