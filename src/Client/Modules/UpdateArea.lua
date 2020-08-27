local UpdateArea = {}

local TweenService = game:GetService("TweenService")


function UpdateArea.Scan(player_character, scan_size, scan_whitelist)
    local player_position = player_character.PrimaryPart.Position
    local region_scan = 
        Region3.new(
            Vector3.new(player_position.X - scan_size, player_position.Y - scan_size, player_position.Z - scan_size),
            Vector3.new(player_position.X + scan_size, player_position.Y + scan_size, player_position.Z + scan_size)
        )

    if scan_whitelist then
        local return_scan = workspace:FindPartsInRegion3WithWhiteList(region_scan, scan_whitelist, 1000)
        
        return return_scan
    else
        local return_scan = workspace:FindPartsInRegion3(region_scan)

        return return_scan
    end

end

function UpdateArea.UpdateLoad(object, load_condition)
    if load_condition then
        for _, part in pairs(object:GetChildren()) do
            if part:IsA("BasePart") then
                if part.Name == "leaf" then
                    --part.Transparency = (part.Transparency >= 0.5 and 0.5) or (part.Transparency - 
                    local tween = TweenService:Create(part, TweenInfo.new(2), {Transparency = 0.5})
                    tween:Play()
                    --part.Transparency = 0.5
                elseif part.Name == "RigidBody" then
                
                else
                            -- part.Transparency = (part.Transparency == 0 and 0) or (part.Transparency - 0.1)
                    local tween = TweenService:Create(part, TweenInfo.new(2), {Transparency = 0})
                    tween:Play()
                    --part.Transparency = 0
                end
            end
        end
    else
        for _, part in pairs(object:GetChildren()) do
            if part:IsA("BasePart") then
            --part.Transparency = (part.Transparency >= 1 and 1) or (part.Transparency + 0.5)
            local tween = TweenService:Create(part, TweenInfo.new(2), {Transparency = 1})
            tween:Play()
                --part.Transparency = 1
            end
        end
    end
end


function UpdateArea.UpdateAnimalRender(player_character, animal_list)
    for _, animal in pairs(animal_list) do
        
        if player_character.PrimaryPart and animal.PrimaryPart then
            local distance = (player_character.PrimaryPart.Position - animal.PrimaryPart.Position).Magnitude
            local load_bool = animal:FindFirstChild("load_bool")
            if distance > 50 then
                load_bool.Value = false
               -- for _, part in pairs(animal:GetChildren()) do
                    --part.Transparency = (part.Transparency >= 1 and 1) or (part.Transparency + 0.5)
                    --part.Transparency = 1
                    --part.Anchored = true
               -- end
            elseif distance < 50 then
                if animal.PrimaryPart.Transparency <= 1 then
                    load_bool.Value = true
                    --for _, part in pairs(animal:GetChildren()) do
                        --if part.Name == "RigidBody" then
                        
                        --else
                           -- part.Transparency = (part.Transparency == 0 and 0) or (part.Transparency - 0.1)
                            --part.Transparency = 0
                            --part.Anchored = false
                        --end
                    --end
                end
            end
        end
    end
    
end

function UpdateArea.UpdatePlantRender(player_character, plant_list)
    for _, plant in pairs(plant_list) do

        if player_character.PrimaryPart and plant.PrimaryPart then
            local distance = (player_character.PrimaryPart.Position - plant.PrimaryPart.Position).Magnitude
            local load_bool = plant:FindFirstChild("load_bool")
            if distance > 50 then
                --for _, part in pairs(plant:GetChildren()) do
                    --part.Transparency = (part.Transparency >= 1 and 1) or (part.Transparency + 0.5)
                    --part.Transparency = 1
                --end
                load_bool.Value = false
            elseif distance < 50 then
                if plant.PrimaryPart.Transparency <= 1 then
                    load_bool.Value = true
                    --for _, part in pairs(plant:GetChildren()) do
                        --if part.Name == "leaf" then
                           -- part.Transparency = (part.Transparency >= 0.5 and 0.5) or (part.Transparency - 0.1)
                            --part.Transparency = 0.5
                        --else
                           -- part.Transparency = (part.Transparency == 0 and 0) or (part.Transparency - 0.1)
                            --part.Transparency = 0
                        --end
                   -- end
                end
            end 
        end
    end
end



return UpdateArea