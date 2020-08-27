local UpdateArea = {}

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


function UpdateArea.UpdateAnimalRender(player_character, animal_list)
    for _, animal in pairs(animal_list) do

        if player_character.PrimaryPart and animal.PrimaryPart then
            local distance = (player_character.PrimaryPart.Position - animal.PrimaryPart.Position).Magnitude

            if distance > 50 then
                for _, part in pairs(animal:GetChildren()) do
                    part.Transparency = (part.Transparency >= 1 and 1) or (part.Transparency + 0.5)
                end
            elseif distance < 50 then
                if animal.PrimaryPart.Transparency <= 1 then
                    for _, part in pairs(animal:GetChildren()) do
                        if part.Name == "RigidBody" then
                            print("rigid body")
                        else
                            part.Transparency = (part.Transparency == 0 and 0) or (part.Transparency - 0.1)
                        end
                    end
                end
            end
        end
    end
    
end

function UpdateArea.UpdatePlantRender(player_character, plant_list)
    for _, plant in pairs(plant_list) do

        if player_character.PrimaryPart and plant.PrimaryPart then
            local distance = (player_character.PrimaryPart.Position - plant.PrimaryPart.Position).Magnitude

            if distance > 50 then
                for _, part in pairs(plant:GetChildren()) do
                    part.Transparency = (part.Transparency >= 1 and 1) or (part.Transparency + 0.5)
                end
            elseif distance < 50 then
                if plant.PrimaryPart.Transparency <= 1 then
                    for _, part in pairs(plant:GetChildren()) do
                        if part.Name == "leaf" then
                            part.Transparency = (part.Transparency >= 0.5 and 0.5) or (part.Transparency - 0.1)
                        else
                            part.Transparency = (part.Transparency == 0 and 0) or (part.Transparency - 0.1)
                        end
                    end
                end
            end 
        end
    end
end

print("item has been required")

return UpdateArea