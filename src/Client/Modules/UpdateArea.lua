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

function UpdateArea.Search(player_character, scan_search)
    for _, item in pairs(scan_search) do
        if item:FindFirstChild("spawn_value") then
            print(item:FindFirstChild("spawn_value").Value)
        end
    end
end

print("item has been required")

return UpdateArea